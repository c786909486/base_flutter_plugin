
class Drawable{
  static String image_empty = getImagePath("image_empty");
  static String image_error = getImagePath("error");
}

String getImagePath(String name,{String format = "png"}){
  return "images/$name.$format";
}