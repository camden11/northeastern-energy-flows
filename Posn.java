// A position as a pair of geographic coordinates
public class Posn {
  
  private final double x;
  private final double y;
  
  // Constructs a posn with the given x and y coordinates
  public Posn(double x, double y) {
    this.x = x;
    this.y = y;
  }
  
  // X value of this posn
  public double x() {
    return x;
  }
  
  // X value of this posn as a float
  public float xFloat() {
    return (float) x;
  }
  
  // Y value of this posn
  public double y() {
    return y;
  }
  
  // Y value of this posn as a float
  public float yFloat() {
    return (float)y;
  }
  
  // Returns a new posn given latitude and longitude in their traditional order
  public static Posn posnFromCoordinate(double latitude, double longitude) {
    return new Posn(longitude, latitude);
  }
  
  // Constructs a posn from coordinates as a string
  public static Posn fromString(String asString) {
    String removeBrackets = asString.substring(1, asString.length() - 1);
    String[] numbers = removeBrackets.split(", ");
    return new Posn(Double.parseDouble(numbers[0]), Double.parseDouble(numbers[1]));
  }
  
  // Constructs an array of posns from a string
  public static Posn[] arrayFromString(String asString) {
    String removeBrackets = asString.substring(1, asString.length() - 1);
    String[] posns = removeBrackets.split("], ");
    for (int i = 0; i < posns.length - 1; i++) {
      posns[i] = posns[i] + "]";
    }
    
    Posn[] posnArray = new Posn[posns.length];
    for (int i = 0; i < posns.length; i++) {
      posnArray[i] = fromString(posns[i]);
    }
    return posnArray;
  }
  
  
}
