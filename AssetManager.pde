import java.util.*;

class AssetManager {

  HashMap<String, PImage> images;

  // Constructor
  AssetManager() {
    images = new HashMap<String, PImage>();
    loadAllImages();
  }

  void add(String imageFileName) {
    PImage newImage = loadImage(imageFileName);
    images.put(imageFileName, newImage);    
    println(imageFileName);
  }
  
  PImage get(String imageName){
    if (images.containsKey(imageName)) 
      return images.get(imageName);
      
    return null;
  }

  void loadAllImages() {

    File dataFolder = new File(dataPath(""));
    File [] files = dataFolder.listFiles();

    for (File file : files)
      if (file.getName().toLowerCase().endsWith(".png"))
        add(file.getName());
  }
}


