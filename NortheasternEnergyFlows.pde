import org.gicentre.utils.move.*;

// Controller used for application
NEFController controller;

PFont helvetica24;
PFont helvetica20;

void setup() {
  size(800, 600, P2D);
  smooth();
  
  // Load fonts
  helvetica24 = loadFont("HelveticaNeue-24.vlw");
  helvetica20 = loadFont("HelveticaNeue-20.vlw");
  
  // Load building database
  Table buildingDB = loadTable("buildingDB.csv", "header");
  Building[] modelBuildings = new Building[buildingDB.getRowCount()];
  for (int i = 0; i < buildingDB.getRowCount(); i++) {
    modelBuildings[i] = new Building(buildingDB.getRow(i));
  }
  
  // Load site database
  Table siteDB = loadTable("siteDB.csv", "header");
  Table powerLevels = loadTable("measureDB_parallel.csv", "header");
  Site[] modelSites = new Site[siteDB.getRowCount()];
  for (int i = 0; i < siteDB.getRowCount(); i++) {
    modelSites[i] = new Site(siteDB.getRow(i), powerLevels);
  }
  
  // Power level data for model
  int baseTime = powerLevels.getRow(0).getInt("timestamp");
  int timeIncrement = powerLevels.getRow(1).getInt("timestamp") - baseTime;
  int numTimeIncrements = powerLevels.getRowCount() - 1;

  // Construct model
  NEFModel model = new NEFModel(modelBuildings, modelSites, baseTime, timeIncrement, numTimeIncrements);
  
  // Create zoomer, construct view
  ZoomPan zoomer = new ZoomPan(this);
  NEFView view = new NEFView(zoomer);
  
  // Assign controller with model and view
  controller = new NEFController(model, view);
  

}


void draw() {
  controller.play();
}

void mouseDragged() {
  controller.checkMouseDragged();
}

void mouseReleased() {
  controller.checkMouseReleased();
}

void keyPressed() {
  controller.checkKeyPressed();
}
