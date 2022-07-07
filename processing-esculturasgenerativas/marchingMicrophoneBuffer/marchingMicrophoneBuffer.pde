/*

 WORKSHOP ESCULTURAS GENERATIVAS 
 André Sier @as1er
 s373.net/x art codex studios 
 
*/

// import a library
import s373.marchingcubes.*;
import ddf.minim.*;

// um objecto da biblioteca
Minim minim;
// o objecto do input sonoro
AudioInput in;
float audioEnergySmooth;

// o cubo marchante
MarchingCubes mc;
// o valor iso
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



int modo = 0; // left, right, stereo, twice

void draw() {

  // limpar o mc
  mc.zeroData();
  // adicionar o valor das samples para o espaço mc
  for (int i = 0; i < in.bufferSize() - 1; i++) {
    float sample = 0.0f;
    if (modo==0) {
      sample = in.left.get(i);
    } 
    else if (modo == 1) {
      sample = in.right.get(i);
    }
    else if (modo == 2) {
      sample = (in.left.get(i) + in.right.get(i)) /2.0f;
    }
    float sampleposxmc = map(sample, -1, 1, 0, mc.worlddim.x);
    float sampleposymc = mc.worlddim.y/2;
    float sampleposzmc = map(i, 0, in.bufferSize(), 0, mc.worlddim.z);
    XYZ samplepos = new XYZ(sampleposxmc, sampleposymc, sampleposzmc);
    float cd = map(mouseY, 0, height, 2, 500);
    XYZ sampledim = new XYZ(cd,cd,cd);
    
    // add point
    mc.addIsoPoint( 0.5, samplepos);
    // add cube
    // mc.addCube( 0.5, samplepos, sampledim);
  }
  // poligonizar a data
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
    mc.drawnormals(0.11);
  popMatrix();
  
  fill(255);
  text("modo<m> "+modo+"\nfps: "+frameRate, 5, 10);
}



void keyPressed() {

  if (key=='s') {
    mc.writeStl(""+frameCount+".stl");
  }

  if(key=='m'){
     modo = (modo+1)%3; 
  }

  if (key=='0') {
    mc.zeroData();
  }
}

