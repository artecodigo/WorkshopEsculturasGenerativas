/*

 WORKSHOP ESCULTURAS GENERATIVAS 
 André Sier @as1er
 s373.net/x art codex studios 
 
*/

import s373.marchingcubes.*;

// import a library
import ddf.minim.*;

// um objecto da biblioteca
Minim minim;
// o objecto do input sonoro
AudioInput in;
float audioEnergySmooth;

MarchingCubes mc;
float isoval = 0.21;
PVector rot=new PVector();
boolean drawwireframe = false;
boolean drawnormals = true;


float zLoc = 0;
float zSpeed = -5;

void setup() {

  size(1000, 600, P3D); 
  int mcres = 64;
  mc = new MarchingCubes(this, 1000, 600, -1000, mcres, mcres, mcres * 2);  
  mc.zeroData();
  mc.isolevel = 0.02;
  mc.polygoniseData();


  minim = new Minim(this);
  minim.debugOn();

  // get a line in from Minim, default bit depth is 16
  in = minim.getLineIn(Minim.STEREO, 512);
}





void draw() {

  // calc code
  zLoc += zSpeed;
  if(zLoc < mc.worlddim.z) {
    zLoc = 0;    
  }
  
  float dstAudio = in.mix.level() * 100;
  audioEnergySmooth += ( dstAudio  - audioEnergySmooth) * 0.05;
  //println(audioEnergySmooth); // 0-10..?
  
  float mdwidthx = map(audioEnergySmooth, 0, 10, 1, 1000); 
  float mdwidthy = map(audioEnergySmooth, 0, 10, 1, 600); 
  float mdwidthz = -mc.worlddim.z /  mc.gz * 0.5; 
  
  
  XYZ mcloc = new XYZ ( width/2, height/2, zLoc);
  XYZ mcdim = new XYZ ( mdwidthx, mdwidthy, mdwidthz );
  
  mc.addCube( 0.1, mcloc, mcdim ) ; 
  mc.multData( 0.9898 );
  mc.polygoniseData();
  
  
  // draw code
  
  background(0);
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
  stroke(255, 0, 0, 150);  
  fill(255, 200);
  mc.draw();
  if (drawnormals)
    mc.drawnormals(0.01);
  popMatrix();
  
}



void keyPressed() {

  if (key=='s') {
    mc.writeStl(""+frameCount+".stl");
  }

  if (key=='0') {
    mc.zeroData();
  }
}

