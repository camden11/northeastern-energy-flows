import java.util.Date;
import java.text.SimpleDateFormat;
import java.util.TimeZone;

// Controller for NortheasternEnergyFlows
public class NEFController {
  
  private final NEFModel model;
  private final NEFView view;
  
  private final SimpleDateFormat dateFormat; 
  
  // Whether or not time is currently being changed by dragging
  private boolean changingTime;
  
  private final double PREFERRED_MIN_POWER = 0;
  private double preferredMaxPower;
  
  // Constructs an NEFController with the given model and view
  public NEFController(NEFModel model, NEFView view) {
    this.model = model;
    this.view = view;
    setBuildingShapes();
    changingTime = false;
    dateFormat = new SimpleDateFormat("dd MMM yyyy h:mm a");
    dateFormat.setTimeZone(TimeZone.getTimeZone("GMT"));
    preferredMaxPower = model.getMaxPowerLevel() / 2;
    updateBuildingColors();
  }
  
  // Plays NortheasternEnergyFlows
  public void play() {
    view.renderBackground();
    view.beginZoomContent();
    view.renderShapes();
    view.endZoomContent();
    view.renderInfoBox();
    view.renderTimeBar();
    view.setDate(convertCurrentTime());
    currentBuilding();
  }
  
  // Runs when the mouse is dragged and shift is not being pressed
  public void checkMouseDragged() {
    if (!(keyPressed && keyCode == SHIFT)) {
      currentBuilding();
      beginChangingTime();
      changeTime();
    }
  }
  
  // Runs when mouse button is released
  public void checkMouseReleased() {
    endChangingTime();
  }
  
  // Runs when a key is pressed
  public void checkKeyPressed() {
    if (keyCode == LEFT) {
      model.decrementTime();
      updateBuildingColors();
      updateViewScrollerPosition();
    }
    else if (keyCode == RIGHT) {
      model.incrementTime();
      updateBuildingColors();
      updateViewScrollerPosition();
    }
    
  }
  
  // Sets building location data from the model as shapes in the view
  private void setBuildingShapes() {
    for (int i = 0; i < model.buildingCount(); i++) {
      view.newShapeFromOutline(model.getBuilding(i).getOutline());
    }
  }
  
  // Converts the model's currentTime to a string with day, month, year, hours, and minutes
  private String convertCurrentTime() {
    Date date = new Date(model.timeAsUnix());
    return dateFormat.format(date);
  }
  
  // Sets the view's current building to the building that is currently being hovered over
  private void currentBuilding() {
    int buildingNumber = view.checkHits();
    if (buildingNumber >= 0) {
      view.setCurrentBuilding(model.getBuilding(buildingNumber).getName());
      view.changeBuildingOutline(buildingNumber);
      updateSiteData(buildingNumber);
    } else { 
      view.setCurrentBuilding(""); 
      view.resetAllBuildingOutline();
      view.resetDataLines();
    }
  }
  
  // Called when user begins dragging, allows for dragging of the time bar
  private void beginChangingTime() {
    if (view.timeBarScrollerHover()) {
      changingTime = true;
    }
  }
  
  // Called when user releases mouse, locks time bar scrolling
  private void endChangingTime() {
    changingTime = false;
  }
  
  // Changes the time in response to user mouse drags 
  private void changeTime() {
    if (changingTime) {
      float viewScrollSpan = width - 2 * view.getLineX();
      int newTime = floor(((mouseX - view.getLineX()) / viewScrollSpan) * model.getMaxTime());
      model.setCurrentTime(min(max(0, newTime), model.getMaxTime()));
      updateViewScrollerPosition();
      updateBuildingColors();
    }
  }
  
  // Updates the position of the view's time scroller based on the model's current time
  private void updateViewScrollerPosition() {
    float viewScrollSpan = width - 2 * view.getLineX();
    float newPos = ((float)model.getCurrentTime() / (float)model.getMaxTime()) * viewScrollSpan + view.getLineX();
    view.setTimeBarScrollerPosition(newPos);
  }
  
  // Updates the color of buildings in the view from power level data in the model;
  private void updateBuildingColors() {
    for (int i = 0; i < model.buildingCount(); i++) {
      view.setBuildingColor(i, view.convertColor
      (model.getBuildingPowerLevel(i), PREFERRED_MIN_POWER, preferredMaxPower));
    }
  }
  
  // Sets the view dataLines to reflect the siteData of the given building
  private void updateSiteData(int buildingIndex) {
    ArrayList<String> siteData = model.getSiteData(buildingIndex);
    int numSites = siteData.size();
    for (int i = 0; i < numSites; i++) {
      view.setData(i, siteData.get(i));
    }
      
    for (int i = numSites; i < view.getSupportedLines(); i++) {
      view.setData(i, "");
    }
  }
  

}
