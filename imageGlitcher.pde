import java.io.File;

PImage mImg;
PImage lImg;
ArrayList<String> cafeFiles;
ArrayList<String> cursoFiles;
ArrayList<String> oficinaFiles;

void setup() {
  size(900, 700);

  cafeFiles = new ArrayList<String>();
  cursoFiles = new ArrayList<String>();
  oficinaFiles = new ArrayList<String>();

  File f = new File(dataPath(""));
  File[] fs = f.listFiles();
  for (int i=0; i<fs.length; i++) {
    if (fs[i].isFile() && fs[i].getName().endsWith(".jpg")) {
      if (fs[i].getName().startsWith("cafe")) {
        cafeFiles.add(fs[i].getName());
      } else if (fs[i].getName().startsWith("curso")) {
        cursoFiles.add(fs[i].getName());
      } else {
        oficinaFiles.add(fs[i].getName());
      }
    }
  }

  processArray(cafeFiles, 0x808000);
  processArray(cursoFiles, 0x008080);
  processArray(oficinaFiles, 0x800080);
}

void processArray(ArrayList<String> files, int ccc) {
  for (int fi=0; fi<files.size(); fi++) {
    mImg = loadImage(dataPath(files.get(fi)));
    lImg = loadImage(dataPath("lilo.png"));
    int nSize = (int)(min(mImg.width,mImg.height)); 
    lImg.resize(nSize,nSize);
    
    mImg.blend(lImg,0,0,lImg.width,lImg.height,0,0,mImg.width,mImg.height,DARKEST);

    mImg.loadPixels();
    for (int y=0; y<mImg.height; y++) {
      for (int x=0; x<mImg.width; x++) {
        float ff = noise(40*y/mImg.height, 2f*x/mImg.width, fi);
        int i = y*mImg.width + x;
        mImg.pixels[i] |= ccc;
        if (ff <0.3) {
          mImg.pixels[i] = mImg.pixels[(i+y+x)%int(ff*mImg.pixels.length)];
          //mImg.pixels[i] += ccc/2;
        }
      }
    }
    mImg.updatePixels();
    mImg.save(dataPath("out/"+files.get(fi)));
  }
}

void draw() {
  background(0);
  float scaleFactor = min((float)width/mImg.width, (float)height/mImg.height);
  image(mImg, 0, 0, scaleFactor*mImg.width, scaleFactor*mImg.height);
}