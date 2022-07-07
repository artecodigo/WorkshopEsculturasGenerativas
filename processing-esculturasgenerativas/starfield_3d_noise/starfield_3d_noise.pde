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

import processing.opengl.*;

star s[]; // as estrelas
float speed = 5; // a velocidade
float rotspeed = 1e-7; // a velocidade de rotação
float rot; //


void setup(){
  //  size(1280,720,OPENGL);
  size(914,514,OPENGL); // 720p / 1.4

  // a perspectiva defeito do opengl
  float fov = PI/3.0;
  float cameraZ = (height/2.0) / tan(PI * fov / 360.0);
  perspective(fov, float(width)/float(height), 
  0.001, 100000.0);//cameraZ/10.0, cameraZ*10.0);

  s = new star[1000];

  for(int i=0; i<s.length;i++)
    s[i]=new star();
}

void draw(){

  //  if(mousePressed)
  speed = map(mouseX, 0, width,0.,100.);
  rotspeed = map(mouseY, 0, height, -1e-2, 1e-2);
  rot = rot + rotspeed; //aculumar as rotações

  background(0);
  stroke(255,250);
  translate(width/2,height/2);
  rotate(sin(rot)*TWO_PI);

  for(int i=0; i<s.length;i++)
    s[i].render();
}


