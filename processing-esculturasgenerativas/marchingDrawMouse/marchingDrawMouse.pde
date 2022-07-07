/*

 WORKSHOP ESCULTURAS GENERATIVAS 
 André Sier @as1er
 s373.net/x art codex studios 
 
*/


import s373.marchingcubes.*;

MarchingCubes mc;

int mcres = 64;
float isoval = 0.21;
float mcforce = 0.1;
float mczdrawpos = 0;
int mcdrawmode = 1; // 0 - nada/rotate, 1 - add, 2 - remove
int mcdrawaxis = 0; // 0-xy, 1-xz, 2, yz
float mcdrawdim = 10.0f; // dimensões do pincel 3D
boolean drawwireframe = false;
boolean drawnormals = true;
PVector rot = new PVector();


void setup() {
  size(1024, 768, P3D); 
  mc = new MarchingCubes(this, 1024, 768, -1024, mcres, mcres, mcres);    
  mc.isolevel = isoval;
  mc.zeroData();
  mc.polygoniseData();
  textFont(createFont("Monospace",16));
}

void draw() {
  background(0);
  lights();
  
  XYZ loc = new XYZ(mouseX, mouseY, mczdrawpos);
  XYZ dim = new XYZ(mcdrawdim,mcdrawdim,mcdrawdim);
  
  if(mcdrawaxis!=0){
     if(mcdrawaxis==1){
        loc = new XYZ(mouseX, mczdrawpos, mouseY);
     } 
     else if(mcdrawaxis==2){
        loc = new XYZ(mczdrawpos,mouseX, mouseY);
     } 
  }
  
  
  if (mousePressed) {
    // rotação apenas
    if (mcdrawmode==0) {
      rot.x += -(mouseX-pmouseX)*0.005;
      rot.y += (mouseY-pmouseY)*0.005;
    }
    
    // adicionar data para os voxeis
    else if( mcdrawmode==1 ) {     
      mc.addCube(mcforce, loc, dim); 
      mc.polygoniseData();
    }

    // remover data dos voxeis
    else if( mcdrawmode==2 ) {     
      mc.addCube(-1*mcforce, loc, dim); 
      mc.polygoniseData();
    }

  }



  // draw
  pushMatrix();
  translate(mc.worlddim.x/2, mc.worlddim.y/2, mc.worlddim.z/2);
  rotateX(rot.y);
  rotateY(rot.x);
  translate(-mc.worlddim.x/2, -mc.worlddim.y/2, -mc.worlddim.z/2);


  if (drawwireframe) {
    stroke(255, 200);
    noFill();
  } 
  else {
    fill(255, 255);
    noStroke();
  }

  stroke(255, 0, 0, 150);
  mc.draw();
  if (drawnormals)
    mc.drawnormals(0.12);
  popMatrix();


  fill(random(255), random(200), 0);
  pushMatrix();
//    rotateX(rot.y);
//  rotateY(rot.x);
  translate(loc.x, loc.y, loc.z);
    rotateX(rot.y);
  rotateY(rot.x);
  box(dim.x);
  popMatrix();


  fill(200);

  String info = "s373.marchingDrawMouse\n";
  info += "fps: "+frameRate+"\n";
  info += "iso <i/I>: "+isoval+"\n";
  info += "mcforce <f/F>: "+mcforce+"\n";
  info += "mczdrawpos <z/Z>: "+mczdrawpos+"\n";
  info += "mcdrawmode <m,0,1,2>: "+mcdrawmode+"\n";
  info += "mcdrawdim <d/D>: "+mcdrawdim+"\n";
  info += "<s> saveStl\n";
  info += "< > clear\n";
  info += mc.getinfo();

  text(info, 5, 25);
}

void keyPressed() {

  if (key=='i') {
    isoval -= 0.1;
    mc.isolevel = isoval;
    mc.polygoniseData();
  }
  if (key=='I') {
    isoval += 0.1;
    mc.isolevel = isoval;
    mc.polygoniseData();
  }

  if (key=='f') {
    mcforce -= 0.05;
  }
  if (key=='F') {
    mcforce += 0.05;
  }


  if (key=='z') {
    mczdrawpos -= 25;
  }
  if (key=='Z') {
    mczdrawpos += 25;
  }


  if (key=='m') {
    mcdrawmode=(mcdrawmode+1)%3;
  }
  if (key=='0') {
    mcdrawmode=0;
  }
  if (key=='1') {
    mcdrawmode=1;
  }
  if (key=='2') {
    mcdrawmode=2;
  }


  if (key=='d') {
    mcdrawdim -= 2;
  }
  if (key=='D') {
    mcdrawdim += 2;
  }


  if (key==' ') {
    mc.zeroData();
    mc.polygoniseData();
  }

  if (key=='n') {
    mc.invertnormals^=true;
  }

  if (key=='s') {
    String filename = "s373.marchingDrawMouse-"+frameCount+".stl";
    saveFrame(filename+".png");
    mc.writeStl(filename);
  }
}

