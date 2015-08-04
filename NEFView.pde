import org.gicentre.utils.move.*;
// View for NortheasternEnergyFlows
public class NEFView {
  
  private final int VIEW_WIDTH = width;
  private final int VIEW_HEIGHT = height;
  private final double VIEW_RATIO = VIEW_WIDTH / VIEW_HEIGHT;
  private final color BG_COLOR = color(50);
  
  // The geographic coordinate of the center of the view
  private final Posn CENTER_COORDINATE= Posn.posnFromCoordinate(42.339010, -71.088500);
  // The difference in latitude between the center and edge of the view
  private final double SCOPE_RADIUS = .0055;
  // Highest / Lowest longitude displayed
  private final double MAX_LONG = CENTER_COORDINATE.x() + SCOPE_RADIUS * VIEW_RATIO;
  private final double MIN_LONG = CENTER_COORDINATE.x() - SCOPE_RADIUS * VIEW_RATIO;
  // Highest / Lowest latitude displayed
  private final double MAX_LAT = CENTER_COORDINATE.y() - SCOPE_RADIUS;
  private final double MIN_LAT = CENTER_COORDINATE.y() + SCOPE_RADIUS;
  private final double LONG_RANGE = MAX_LONG - MIN_LONG;
  private final double LAT_RANGE = MAX_LAT - MIN_LAT;
  private final color BASE_BUILDING_COLOR = color(150);
  private final color ACTIVE_BUILDING_COLOR = color(173, 40, 40);
  
  private final color BASE_RED = 86;
  private final color MAX_RED = 232;
  private final color BASE_GREEN = 232;
  private final color MIN_GREEN = 86;
  private final color BLUE = 84;

  private final ZoomPan zoomer;
  private final float MIN_ZOOM_SCALE = .75;
  private final float MAX_ZOOM_SCALE = 3;
  
  private final ArrayList<PShape> shapesToDraw;
  private final ArrayList<Integer> shapeColors;
  
  private final float INFO_BOX_WIDTH = VIEW_WIDTH / 3;
  private final float INFO_BOX_HEIGHT = VIEW_HEIGHT / 4;
  private final float INFO_BOX_X = VIEW_WIDTH - INFO_BOX_WIDTH;
  private final float INFO_BOX_X_MARGIN = 15;
  private final float INFO_BOX_TEXT_X = VIEW_WIDTH - INFO_BOX_WIDTH + INFO_BOX_X_MARGIN;
  private final float INFO_BOX_Y = 0;
  private final float LINE_HEIGHT = 15;
  private final float INFO_BOX_LINE_1 = INFO_BOX_Y + 20;
  private final float INFO_BOX_LINE_2 = INFO_BOX_Y + 45;
  private final float INFO_BOX_LINE_3 = INFO_BOX_LINE_2 + 18;
  private final float INFO_BOX_LINE_4 = INFO_BOX_LINE_3 + LINE_HEIGHT;
  private final float INFO_BOX_LINE_5 = INFO_BOX_LINE_4 + LINE_HEIGHT;
  private final float INFO_BOX_LINE_6 = INFO_BOX_LINE_5 + LINE_HEIGHT;
  private final float INFO_BOX_LINE_7 = INFO_BOX_LINE_6 + LINE_HEIGHT;
  private final float INFO_BOX_LINE_8 = INFO_BOX_LINE_7 + LINE_HEIGHT;
  private final color INFO_BOX_COLOR = color(0, 0, 0, 125);
  private final color INFO_BOX_TEXT_COLOR = color(255);
  private final int DATE_SIZE = 24;
  private final int BUILDING_NAME_SIZE = 20;
  private final int DATA_SIZE = 16;
  private String date;
  private String currentBuilding;
  
  private final ArrayList<String> dataLines;
  private final int SUPPORTED_LINES = 6;
  private final Posn LOC_1 = new Posn(INFO_BOX_TEXT_X, INFO_BOX_LINE_3);
  private final Posn LOC_2 = new Posn(INFO_BOX_TEXT_X, INFO_BOX_LINE_4);
  private final Posn LOC_3 = new Posn(INFO_BOX_TEXT_X, INFO_BOX_LINE_5);
  private final Posn LOC_4 = new Posn(INFO_BOX_TEXT_X, INFO_BOX_LINE_6);
  private final Posn LOC_5 = new Posn(INFO_BOX_TEXT_X, INFO_BOX_LINE_7);
  private final Posn LOC_6 = new Posn(INFO_BOX_TEXT_X, INFO_BOX_LINE_8);
  private final Posn[] DATA_LOCATIONS = new Posn[] {LOC_1, LOC_2, LOC_3, LOC_4, LOC_5, LOC_6};
  
  private final float LINE_Y = VIEW_HEIGHT - 40;
  private final float LINE_X = 40;
  private final float SCROLLER_DIAMETER = 15;
  private float scrollerX;
  
  // Constructs a new view with the given ZoomPan
  public NEFView(ZoomPan zoomer) {
    this.zoomer = zoomer;
    zoomer.setMinZoomScale(MIN_ZOOM_SCALE);
    zoomer.setMaxZoomScale(MAX_ZOOM_SCALE);
    zoomer.setMouseMask(SHIFT);
    shapesToDraw = new ArrayList<PShape>();
    shapeColors = new ArrayList<Integer>();
    currentBuilding = "";
    dataLines = new ArrayList<String>(SUPPORTED_LINES);
    initDataLines();
    date = "09 Dec 2013 12:00 AM";
    scrollerX = LINE_X;
  }
  
  // Initiailizes dataLines as an ArrayList of empty strings
  private void initDataLines() {
    for (int i = 0; i < SUPPORTED_LINES; i++) {
      dataLines.add(i, "");
    }
  }
  
  // Given an array of coordinates as posns, constructs a shape from these coordinates
  public void newShapeFromOutline(Posn[] coordinates) {
    PShape outline = createShape();
    outline.beginShape();
    outline.fill(BASE_BUILDING_COLOR);
    outline.stroke(BASE_BUILDING_COLOR);
    
    for (int i = 0; i < coordinates.length; i++) {
      Posn currentPosn = coordinates[i];
      float xPos = (float)Math.abs(((currentPosn.x() - MIN_LONG) / LONG_RANGE)) * VIEW_WIDTH;
      float yPos = (float)Math.abs(((currentPosn.y() - MIN_LAT) / LAT_RANGE)) * VIEW_HEIGHT;
      outline.vertex(xPos, yPos);
    }
    outline.endShape(CLOSE);
    shapeColors.add(BASE_BUILDING_COLOR);  
    shapesToDraw.add(outline);
  }
  
  // Renders each of this view's known shapes
  public void renderShapes() {
    for (int i = 0; i < shapesToDraw.size(); i++) {
      PShape toDraw = shapesToDraw.get(i);
      toDraw.setFill(shapeColors.get(i));
      shape(toDraw);
    }
  }
  
  // Renders the background of the view
  public void renderBackground() {
    background(BG_COLOR);
  }
  
  // Renders the information box
  public void renderInfoBox() {
    noStroke();
    fill(INFO_BOX_COLOR);
    rect(INFO_BOX_X, INFO_BOX_Y, INFO_BOX_WIDTH, INFO_BOX_HEIGHT);
    fill(INFO_BOX_TEXT_COLOR);
    textFont(helvetica24);
    textSize(DATE_SIZE);
    text(date, INFO_BOX_TEXT_X, INFO_BOX_LINE_1);
    textFont(helvetica20);
    textSize(BUILDING_NAME_SIZE);
    text(currentBuilding, INFO_BOX_TEXT_X, INFO_BOX_LINE_2);
    textSize(DATA_SIZE);
    for (int i = 0; i < SUPPORTED_LINES; i++) {
      text(dataLines.get(i), DATA_LOCATIONS[i].xFloat(), DATA_LOCATIONS[i].yFloat());
    }
  }
  
  // Renders the time bar
  public void renderTimeBar() {
    stroke(255);
    line (LINE_X, LINE_Y, VIEW_WIDTH - LINE_X, LINE_Y);
    fill(255);
    ellipse(scrollerX, LINE_Y, SCROLLER_DIAMETER, SCROLLER_DIAMETER);
  }
  
  // Called when drawing to signal that the following functions draw things that are zoomable
  public void beginZoomContent() {
    pushMatrix();
    zoomer.transform();
  }
  
  // Called when drawing to signal that the following functions draw things that are not zoomable
  public void endZoomContent() {
    popMatrix();
  }
  
  // Checks if the use is currently hovering over any of the building shapes, and returns that 
  // building's index number if they are
  public int checkHits() {
    for (int i = 0; i < shapesToDraw.size(); i++) {
      if (containsPoint(shapesToDraw.get(i), zoomer.getMouseCoord().x, zoomer.getMouseCoord().y)) {
        return i;
      }
    }
    return -1;
  }
  
  // Returns true if the use is hovering over the timeBarScroller
  public boolean timeBarScrollerHover() {
    return dist(mouseX, mouseY, scrollerX, LINE_Y) <= (SCROLLER_DIAMETER / 2);
  }
  
  // Changes the current building to the given string
  public void setCurrentBuilding(String buildingName) {
    currentBuilding = buildingName;
  }
  
  // Changes the date to the given string
  public void setDate(String newDate) {
    date = newDate;
  }
  
  // Sets the the given index on shapeColors to the given color
  public void setBuildingColor(int index, color c) {
    shapeColors.set(index, c);
  }
  
  // Sets the given index of dataLines to the given string
  public void setData(int index, String data) {
    dataLines.set(index, data);
  }
  
  
  // Sets the position of the timeBarScroller to the given point if it is in range
  public void setTimeBarScrollerPosition(float pos) {
    scrollerX = max(LINE_X, min(VIEW_WIDTH - LINE_X, pos));
  }
  
  // Returns LINE_X
  public float getLineX() {
    return LINE_X;
  }
  
  // Returns the number of lines of site data that this view supports
  public int getSupportedLines() {
    return SUPPORTED_LINES;
  }
  
  // Marks the building that is currently being hovered over
  public void changeBuildingOutline(int buildingIndex) {
    shapesToDraw.get(buildingIndex).setStroke(color(255));
  }
  
  // Returns all buildings to non-hovered state
  public void resetAllBuildingOutline() {
    for (int i = 0; i < shapesToDraw.size(); i++) {
      shapesToDraw.get(i).setStroke(shapeColors.get(i));
    }
  }
  
  // Resets each line of dataLines to an empty string
  public void resetDataLines() {
    for (int i = 0; i < SUPPORTED_LINES; i++) {
      dataLines.set(i, "");
    }
  }
  
  
  
  // Returns true if the given PShape cointains the given x and y coordinates
  // From toxi.geom
  private boolean containsPoint(PShape shape, float px, float py) {
    int num = shape.getVertexCount();
    int i, j = num - 1;
    boolean oddNodes = false;
    for (i = 0; i < num; i++) {
      PVector vi = shape.getVertex(i);
      PVector vj = shape.getVertex(j);
      if (vi.y < py && vj.y >= py || vj.y < py && vi.y >= py) {
        if (vi.x + (py - vi.y) / (vj.y - vi.y) * (vj.x - vi.x) < px) {
          oddNodes = !oddNodes;
        }
      }
      j = i;
    }
     return oddNodes;
  }
  
  // Converts a values position between a min and max to a color. Green is closer to min,
  // red is closer to max
  public color convertColor(double value, double min, double max) {
    if (Double.isNaN(value)) {
      return BASE_BUILDING_COLOR;
    }
    
    float red = BASE_RED;
    float green = BASE_GREEN;
    float blue = BLUE;
    
    red += min((float)((value - min) / ((max - min) / 2)), 1.0) * (MAX_RED - BASE_RED);
    
    if (red == 232) {
      green -= min((float)((value - min - max/2) / ((max - min) / 2)), 1) * (BASE_GREEN - MIN_GREEN);
    }
    
    return color(red, green, blue);
  }
}
