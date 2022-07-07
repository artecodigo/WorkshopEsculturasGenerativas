/*

 WORKSHOP ESCULTURAS GENERATIVAS 
 André Sier @as1er
 s373.net/x art codex studios 
 
*/


/*

código esqueleto da aplicação Autómato Universal
http://s373.net/folio/uunniivveerrssee/automatouniversal/

*/


import processing.opengl.*;
import s373.marchingcubes.*;
import javax.media.opengl.*;
import java.nio.*; 

PGraphicsOpenGL pgl;
GL gl;

MarchingCubes mc;
float isoval = 0.01;
PVector rot=new PVector();
boolean drawwireframe = false;


int ng = 16;//16; //50;//16;//6;//8;//16;//64;//82;//100;  // 128;//64;//32;//16;//32;//64;//12;//8;//128;//256;//64;//16;//10;//20;
int zoff = 10;//100;//10;//20;//20;//10;//16;//20;//16;//10;//2;//10;//2;//10;//1;//10;//100;
//10;//2;//1;//7;

//int zoff1 = zoff*2;//+1

CellularGrid cg = new CellularGrid(ng);
CubeVol cv = new CubeVol(ng, ng, ng*zoff, ng*zoff, 7.0, 2.0);//(ng, 16.0);

boolean goAutomata = true;

boolean recordStlStream = false;
boolean recordStlHistory = true;//false;
int     numZSlicesHistory = 0;
int stlIdx = 0;
int stlGen = 0;
boolean dosaveframe = false;


void setup() {
  size(1280, 720, OPENGL); 

  mc = new MarchingCubes(this,250.0f, 250.0f, -250.0f*zoff, ng, ng, ng*zoff);  

  pgl = ((PGraphicsOpenGL)g);
  gl = ((PGraphicsOpenGL)g).gl;

  mc.zeroData();
  mc.isolevel = 0.01;

  cg.setcelrule();
}


void draw() {

  if (goAutomata) {
    cg.go(); 
    while(mc.isEmpty()){
        restartCellularStl();
        mc.addIsoPoint(isoval, mc.getCenter()); 
    } 
    cv.setMatrix(cg.getArray());
    calcSurface();
  }



  perspective(radians(60),(float)width/(float)height, 0.1, 1e10);
  background(0);

  lights();


  XYZ loc = new XYZ(mouseX, mouseY, map(sin(frameCount*0.021), -1., 1., 1., width-1 ));
  XYZ dim = new XYZ(10, 10, 10);
  if (mousePressed) {
    if (mouseButton==LEFT) {

      rot.x += -(mouseX-pmouseX)*0.005;
      rot.y += (mouseY-pmouseY)*0.005;
    } 
    else {

      mc.addCube(isoval, loc, dim); 
      //     mc.addIsoPoint(isoval, loc); 
      mc.polygoniseData();
    }
  }


  if (drawwireframe) {
    stroke(255, 200);
    noFill();
  } 
  else {

    fill(255, 255);
    noStroke();
  }


  pushMatrix();
  translate(width/2, height/2, mc.worlddim.z/2.0f);
  rotateX(rot.y);
  rotateY(rot.x);
  translate(-width/2, -height/2, -mc.worlddim.z/2.0f);
  mc.draw();
  stroke(100, 0, 0, 100);
  mc.drawnormals(0.025);
  popMatrix();
 
  fill(255);
  text(mc.getinfo()+"\n"+frameRate, 5, height-20);
  
 
  
}


void calcSurface(){
  mc.setData(cv.getData());
  mc.polygoniseData();
}



void keyPressed() {
  if (key=='w') {
    drawwireframe^=true;
    return;
  }

  if (key=='s') {
    saveFrame("cellular-3d-"+frameCount+".png");
    mc.writeStl("cellular-3d-"+frameCount+".stl"); 
    return;
  }

  if (key=='n') {
    mc.invertnormals^=true;
  }

  if (key=='i') {
    mc.isolevel-=0.005;
  }

  if (key=='I') {
    mc.isolevel+=0.005;
  }

  if (key=='a')
    isoval*=-1;
  if (key=='g')
    isoval*=0.9;
  if (key=='G')
    isoval*=1.1;
  if (key=='R') {
    cg.setcelrule();
    mc.setRndData(0.001, 0.5);
  }
  
  if(key=='r'){
     restartCellularStl(); 
  }
  
  mc.polygoniseData();
}

void restartCellularStl(){
    cg.setcelrule();
    cv.clearVals();
    cv.currentZ = 0;
    cv.end = false;
    
    stlGen = stlGen + 1;
    numZSlicesHistory  = 0;  
}


String getTimeStamp(){
  String ts = ""+nf(year(),4)+""+nf(month(),2)+nf(day(),2);
  ts+=nf(hour(),2)+nf(minute(),2);
  println(ts);
  return ts;
}


String getDayStamp(){
  String ts =nf(hour(),2)+nf(minute(),2)+nf(second(),2);
  println(ts);
  return ts;
}

