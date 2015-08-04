import java.util.Arrays;

// Represents a building on Northeastern's campus
public class Building {
  
  private final int id;
  private final String name;
  private final UseType useType;
  private final int floors;
  private final int yearAcquired;
  private final int perimeter;
  private final double area;
  private final int footprint; // (area on ground/ area of first floor)
  private final Posn centroid;
  private final Posn[] outline;
  
  // Constructs a building from a row of data in csv table
  public Building(TableRow row) {
    this.id = row.getInt("bID");
    this.name = row.getString("Name");
    this.useType = UseType.fromString(row.getString("Primary Use"));
    this.floors = row.getInt("Floors");
    this.yearAcquired = row.getInt("Year Acquired");
    this.perimeter = row.getInt("Perimeter");
    this.area = row.getDouble("Area");
    this.footprint = row.getInt("Footprint");
    this.centroid = Posn.fromString(row.getString("Centroid"));
    this.outline = Posn.arrayFromString(row.getString("Outline"));
  }
  
  // Return's this building's name as a string
  public String getName() {
    return name;
  }
  
  // Returns this building's outline as an array of Posn coordinates
  public Posn[] getOutline() {
    return outline;
  }
  
}
