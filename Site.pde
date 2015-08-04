// A data site with recordings of power levels over time
public class Site{
  
  private final int id;
  private final String name;
  private final String abbreviation;
  private final int buildingId; // Building located inside of
  private final Double[] powerLevels; // Power levels at various intervals in kilowatts
  private double maxPowerLevel;
  
  // Constructs a new site from a TableRow, list of known Buildings, and Table of power data
  public Site(TableRow row, Table powerTable) {
    this.id = row.getInt("sID");
    this.name = row.getString("Name");
    this.abbreviation = row.getString("Abbreviation");
    this.buildingId = row.getInt("bID");
    this.powerLevels = parseTable(powerTable, id);
  }
  
  // Returns an array of power levels in kilowatts as doubles from the given table at
  // the given column
  private Double[] parseTable(Table powerTable, int siteId) {
    Double[] powerLevelArray = new Double[powerTable.getRowCount()];
    for (int i = 0; i < powerTable.getRowCount(); i++) {
      double currentPowerLevel = powerTable.getRow(i).getDouble(Integer.toString(siteId));
      powerLevelArray[i] = currentPowerLevel;
      if (currentPowerLevel > maxPowerLevel) {
        maxPowerLevel = currentPowerLevel;
      }
    }
    return powerLevelArray;
  }
  
  // Returns this site's id
  public int getId() {
    return buildingId;
  }
  
  // Returns this site's power reading at the given time
  public double getPowerReading(int time) {
    return powerLevels[time];
  }
  
  // Returns this site's highest power level
  public double maxPowerLevel() {
    return maxPowerLevel;
  }
  
  // Returns this site's data for the given time as a string
  public String toString(int time) {
    if (Double.isNaN(powerLevels[time])) {
      return abbreviation + ": No data for this time";
    }
    return abbreviation + ": " + Double.toString(powerLevels[time]) + " kW";
  }
  
}
