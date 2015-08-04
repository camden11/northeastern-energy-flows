// Model for NortheasternEnergyFlows
public class NEFModel {
  
  private Building[] buildings;
  private Site[] sites;
  
  // the power levels at each building at the current time
  // buildings that have more than one site have those sites power levels added up
  private double[] currentBuildingPowerLevels;
  private double maxPowerLevel;
  
  // Power level information for each site as a string
  private ArrayList<String>[] siteData;
  
  // Starting time of site power data. 
  // The UNIX time stamp of the the first index of each site's powerLevels
  private final long baseTime;
  
  // The difference in seconds (UNIX time) between two indices in each site's powerLevels
  private final long timeIncrement;
  
  // The amount of time increments in each site's powerLevels
  private final int numTimeIncrements;
  
  private int currentTimeIncrement;
  
  // Constructs a model with the given lists of buildings and sites
  public NEFModel(Building[] buildings, Site[] sites, long baseTime, long timeIncrement, int numTimeIncrements) 
  {
    this.buildings = buildings;
    this.sites = sites;
    this.baseTime = baseTime;
    this.timeIncrement = timeIncrement;
    this.numTimeIncrements = numTimeIncrements;
    currentTimeIncrement = 0;
    currentBuildingPowerLevels = new double[buildings.length];
    setCurrentBuildingPowerLevels();
    siteData = (ArrayList<String>[])new ArrayList[buildings.length];
    for (int i = 0; i < siteData.length; i++) {
      siteData[i] = new ArrayList<String>();
    }
    setSiteData();
    determineMaxPowerLevel();
  }
  
  // Returns the number of buildings this model has data on
  public int buildingCount() {
    return buildings.length;
  }
  
  // Returns the building at the given index
  public Building getBuilding(int i) {
    return buildings[i];
  }
  
  // Returns the current time as a UNIX time stamp
  public long timeAsUnix() {
    return (baseTime + currentTimeIncrement * timeIncrement) * 1000;
  }
  
  // Sets the current time equal to the given time
  public void setCurrentTime(int time) {
    currentTimeIncrement = time;
    setCurrentBuildingPowerLevels();
    setSiteData();
  }
  
  // Returns the currentTimeIncrement
  public int getCurrentTime() {
    return currentTimeIncrement;
  }
  
  // Decreases time by 1 and updates building power levels
  public void decrementTime() {
    if (currentTimeIncrement > 0) {
      currentTimeIncrement--;
      setCurrentBuildingPowerLevels();
      setSiteData();
    }
  }
  
  // Increments time by 1 and updates building power levels
  public void incrementTime() {
    if (currentTimeIncrement < numTimeIncrements) {
      currentTimeIncrement++;
      setCurrentBuildingPowerLevels();
      setSiteData();
    }
  }
  
  // Returns the latest time this model has data for
  public int getMaxTime() {
    return numTimeIncrements;
  }
  
  // Updates currentPowerLevels for the current time
  private void setCurrentBuildingPowerLevels() {
    for (int i = 0; i < currentBuildingPowerLevels.length; i++) {
      currentBuildingPowerLevels[i] = 0;
    }
    
    for (int i = 0; i < sites.length; i++) {
      Site site = sites[i];
      currentBuildingPowerLevels[site.getId()] += site.getPowerReading(currentTimeIncrement); 
    }
  }
  
  // Updates site data for the current time increment
  private void setSiteData() {
    for (int i = 0; i < siteData.length; i++) {
      siteData[i] = new ArrayList<String>();
    }
    
    for (int i = 0; i < sites.length; i++) {
      Site site = sites[i];
      siteData[site.getId()].add(site.toString(currentTimeIncrement));
    }
  }
  
  public double getBuildingPowerLevel(int index) {
    return currentBuildingPowerLevels[index];
  }
  
  // Returns the siteData at the given index
  public ArrayList<String> getSiteData(int index) {
    return siteData[index];
  }
  
  // Determines the highest power level of any site this model knows about
  private void determineMaxPowerLevel() {
    for (int i = 0; i < sites.length; i++) {
      if (sites[i].maxPowerLevel() > maxPowerLevel) {
        maxPowerLevel = sites[i].maxPowerLevel();
      }
    }
  }
  
  // Returns the highest power level this model has data for
  public double getMaxPowerLevel() {
    return maxPowerLevel;
  }
    
}
