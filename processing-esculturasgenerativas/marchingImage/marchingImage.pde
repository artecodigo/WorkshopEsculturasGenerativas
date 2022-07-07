/*

 WORKSHOP ESCULTURAS GENERATIVAS 
 André Sier @as1er
 s373.net/x art codex studios 
 
*/

import s373.marchingcubes.*;

PImage video;

int res = 8;//4; // 1 fullres

PFont f;

// o cubo marchante
MarchingCubes mc;
// o valor iso
float isoval = 0.21;
PVector rot=new PVector();
boolean drawwireframe = false;
boolean drawnormals = true;

void setup() {
  size(1000, 600, P3D); 
  f = createFont("sans-serif", 12); 
  textFont(f, 12);

  int mcres = 64;
  mc = new MarchingCubes(this, 1000, 600, -500, mcres, mcres, mcres * 2);  
  mc.zeroData();
  mc.isolevel = 0.02;
  mc.polygoniseData();

 
//  video = loadImage("automato-universal3d-IMG_20150406_194927.jpg");
  video = loadImage("theresAHoleInThePan.png");


   mc.zeroData();

    // extrudir cada pixel dependendo do brilho dele
    for (int y=0; y<video.height; y+=res) {
      for (int x=0; x<video.width; x+=res) {
        
        color pix = video.get(x, y);
        
        float bright = brightness(pix);//0-255
        
        XYZ loc = new XYZ(
            map(x, 0, video.width, 0, mc.worlddim.x), 
            map(y, 0, video.height, 0, mc.worlddim.y), 
            map(bright, 0, 255, 0, mc.worlddim.z)
          );
        
        XYZ dim = new XYZ(res+1,res+1,res+1);
        
        //mc.addIsoPoint( 0.5, loc);
        mc.addCube( 0.5, loc, dim);
      }
    }
    // poligonizar a data só depois de adicionar os vals todos
    mc.polygoniseData();

}


boolean showImage = true;

void draw() {

  background(0);

  if (showImage) {
    image(video, 0, 0, video.width/res, video.height/res);
  }

  lights();

  if (mousePressed) {
    rot.x += -(mouseX-pmouseX)*0.05;
    rot.y += (mouseY-pmouseY)*0.05;
  }

  pushMatrix();
  translate(mc.worlddim.x/2, mc.worlddim.y/2, mc.worlddim.z/2);
  rotateX(rot.y);
  rotateY(rot.x);
  translate(-mc.worlddim.x/2, -mc.worlddim.y/2, -mc.worlddim.z/2);
  stroke(0,255, 0, 150);  
  fill(255, 200);
  mc.draw();
  if (drawnormals)
    mc.drawnormals(0.11);
  popMatrix();

  //  noStroke();
  fill(255);
}


void keyPressed() {

  if (key=='i') {
    showImage^=true;
  }


  if (key=='s') {
    mc.writeStl(""+frameCount+".stl");
    saveFrame(""+frameCount+".jpg");
  }
}

