/*

 WORKSHOP ESCULTURAS GENERATIVAS 
 André Sier @as1er
 s373.net/x art codex studios 
 
*/

/*
 starfield / um campo de estrelas, o som do pensamento 2009
 mouseX controla a velocidade
 mouseY controla a rotação
 */

import s373.marchingcubes.*;

Star s[]; // as estrelas
float speed = 5; // a velocidade
PVector rot=new PVector();

boolean carve = false;

// o cubo marchante
MarchingCubes mc;
// o valor iso
float isoval = 0.21;

boolean drawwireframe = false;
boolean drawnormals = true;


// stars limits
float starminx = 50;
float starmaxx = 1230;
float starminy = 50;
float starmaxy = 670;


void setup(){
  size(1280,720,P3D);

  // a perspectiva defeito do opengl alterada
//  float fov = PI/3.0;
//  float cameraZ = (height/2.0) / tan(PI * fov / 360.0);
//  perspective(fov, float(width)/float(height), 
//  0.001, 100000.0);//cameraZ/10.0, cameraZ*10.0);

  s = new Star[1000];

  for(int i=0; i<s.length;i++){
    s[i]=new Star();
  }
  
  
  int mcres = 32;//64;
  mc = new MarchingCubes(this, width, height, -width, mcres, mcres, mcres * 2);  
  mc.zeroData();
  mc.isolevel = 0.10;
  mc.polygoniseData();
  
}

void draw(){
  background(0);
  hint(DISABLE_DEPTH_TEST);
  
  if (mousePressed) {
    rot.x += -(mouseX-pmouseX)*0.05;
    rot.y += (mouseY-pmouseY)*0.05;
  }

  pushMatrix();
  translate(mc.worlddim.x/2, mc.worlddim.y/2, mc.worlddim.z/2);
  rotateX(rot.y);
  rotateY(rot.x);
  translate(-mc.worlddim.x/2, -mc.worlddim.y/2, -mc.worlddim.z/2);
  
  stroke(0,255, 0, 250);  
  fill(255, 20);
  mc.draw();
  if (drawnormals)
    mc.drawnormals(0.01);
  //popMatrix(); // tem de ser depois das estrelas para 
  // acumularem as transformações geométricas
  
  

  speed = map(mouseX, 0, width,0.,25.);


  
  stroke(255,250);
  //translate(width/2,height/2);
//  rotate(sin(rot)*TWO_PI);

  // aqui acumular para o mc
  for(int i=0; i<s.length;i++){
    s[i].render();
    if(carve){
       XYZ loc = new XYZ(s[i].x, s[i].y, s[i].z);
       mc.addIsoPoint( 0.25, loc); 
    }
  }
  mc.polygoniseData();
  
  popMatrix();
}




void keyPressed() {

  if (key==' ') {
    mc.zeroData();
  }
  if (key=='c') {
    carve = !carve; 
  }


  if (key=='s') {
    mc.writeStl(""+frameCount+".stl");
    saveFrame(""+frameCount+".jpg");
  }
}


