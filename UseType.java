public enum UseType {
  Athletic, Classroom, ClassAdmin, ClassResearch, ClassRes, ClassLibrary, Administrative, 
  Services, Research, Residence, Mechanical;
  
  // Returns the given string as a UseType
  // Throws an exception if the given string does not represent a known UseType
  public static UseType fromString(String asString) {
    if (asString.equals("Athletic Facility")) {
      return UseType.Athletic;
    } else if (asString.equals("Classroom")) {
     return UseType.Classroom;
    } else if (asString.equals("Classroom/Admin.")) {
      return UseType.ClassAdmin;
    } else if (asString.equals("Research/Classroom")) {
      return UseType.ClassResearch;
    } else if (asString.equals("Residence Facility/Academic")) {
      return UseType.ClassRes;
    } else if (asString.equals("Library/Classroom") || asString.equals("Classroom/Library")) {
      return UseType.ClassLibrary;
    } else if (asString.equals("Administrative")) {
      return UseType.Administrative;
    } else if (asString.equals("Student Services")) {
      return UseType.Services;
    } else if (asString.equals("Research")) {
      return UseType.Research;
    } else if (asString.equals("Residence Facility")) {
      return UseType.Residence;
    } else if (asString.equals("Mechanical Facility")) {
      return UseType.Mechanical;
    } else {
      throw new IllegalArgumentException("Unsupported use type");
    }
  }
}
