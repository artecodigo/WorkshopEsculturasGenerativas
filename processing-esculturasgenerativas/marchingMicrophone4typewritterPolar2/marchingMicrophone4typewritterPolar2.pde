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

float xLoc = 0;
float zLoc = 0;
float zSpeed = -5;

float headAngle = 0;
float headRadius = 10;
float headSpeed = PI/4;
float headX, headZ, headY;

void setup() {

  size(1000, 600, P3D); 
  int mcres = 64;
//  mc = new MarchingCubes(this, 1000, 600, -2000, mcres, mcres, mcres * 2);  
  mc = new MarchingCubes(this, 1000, 600, -1000, mcres, mcres, mcres);  
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
//  zLoc += zSpeed;
//  if(zLoc < mc.worlddim.z) {
//    zLoc = 0;    
//    xLoc += 100;
//    if(xLoc >= width){
//       xLoc = 0; 
//    }
//  }
  
  // calc polar
  headAngle += headSpeed; // 0-2PI
  if(headAngle > TWO_PI){
    headAngle -= TWO_PI;
    headRadius += 10;
    
    if(headRadius > height*0.7){
       headRadius = 10; 
       mc.zeroData();
    }
    
    headSpeed = map(headRadius, 10, width, PI/40.0, PI/5000.0f);
  }
  
  headX = width/2 + cos(headAngle) * headRadius;
  headZ = -width/2 + sin(headAngle) * headRadius;
  
  float mdwidthy = map(audioEnergySmooth, 0, 10, 1, 300);
  
  headY = height/2 - mdwidthy/2; 
  
  
  
  float dstAudio = in.mix.level() * 100;
  audioEnergySmooth += ( dstAudio  - audioEnergySmooth) * 0.15;
  //println(audioEnergySmooth); // 0-10..?
  
  float mdwidthx = 0;//100;//map(audioEnergySmooth, 0, 10, 1, 1000); 
  //float mdwidthy = 0;//map(audioEnergySmooth, 0, 10, 1, 600); 
  float mdwidthz = 0;//-mc.worlddim.z /  mc.gz * 0.15; 
  
  
  //XYZ mcloc = new XYZ ( width/2, height/1.9 - mdwidthy*0.5, zLoc);
  XYZ mcloc = new XYZ ( headX, headY, headZ);
  XYZ mcdim = new XYZ ( mdwidthx, mdwidthy, mdwidthz );
  
  mc.addCube( 0.1, mcloc, mcdim ) ; 
 // mc.multData( 0.9898 );
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

