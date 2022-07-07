#include "testApp.h"

//--------------------------------------------------------------
void testApp::setup(){

	
	ofSetFrameRate(60);
	
	panel.setup(300, 500 );
	panel.addPanel("Settings");
	panel.addSlider("x", 32, 0, 100, true);
	panel.addSlider("y", 32, 0, 100, true);
	panel.addSlider("z", 32, 0, 100, true);
	panel.addSlider("rx",360, 0, 720, false);
	panel.addSlider("ry",360, 0, 720, false);
	panel.addSlider("rz",360, 0, 720, false);
	panel.addSlider("ryspeed",0, -1, 1, false);
	panel.addSlider("lightspeed", 0.1, -1, 1, false);
	panel.addSlider("lightrad", 250, 50, 2500, false);
	
	panel.addPanel("MarchingCube");
	panel.addSlider("ballforce",0.05, -1, 1, false);
	panel.addSlider("balldim",0.05, 0, 1, false);
	panel.addSlider("iso",0.05, 0, 1, false);
	panel.addSlider("zspeed",10.05, 0, 2, false);
	panel.addSlider("zpos", 0, -1600, 0, false);
	panel.addToggle("go", true);
	panel.addToggle("saveStl", false);
	panel.addToggle("autosaveStl", false);
	panel.addToggle("invertnormals", true);
	panel.addToggle("mcdatasubs", false);
	panel.addToggle("mczero", false);
	
	imgdimx = imgdimy = 10;
	
	mc.setup(1000,600,-1000, imgdimx, imgdimy, imgdimx);
	
	light.enable();
	light.setPosition(+500, 0, 0);

	lightangle = 0.0f;
	
//	mc.polygoniseData();
}

//--------------------------------------------------------------
void testApp::update(){

	
	lightangle+=panel.getValueF("lightspeed");
	light.setPosition(cosf(lightangle)*panel.getValueF("lightrad"), 0, sinf(lightangle)*panel.getValueF("lightrad"));
	
	int tx = panel.getValueI("x");
	int ty = panel.getValueI("y");
	bool dirty = false;
	
	if(tx!=imgdimx||ty!=imgdimy){
		imgdimx = tx;
		imgdimy = ty;
			
		mc.clear();
		
		int nz = panel.getValueI("z");
		mc.setup(1000,600,-1000, imgdimx, imgdimy, nz);

//		mc.polygoniseData();

	}
	
	
	//mc calcs from gray
	//vector<float>	mcdata;
	//mcdata.clear();
//	for(int i=0; i<imgdimx*imgdimx*imgdimy; i++){
//		mcdata.push_back(0.0f);
//	}
	
	mc.isolevel = panel.getValueF("iso");
	mc.invertnormals = panel.getValueB("invertnormals");

	if(panel.getValueB("go") && ofGetMousePressed()){
		
		float zpos = fmodf( ofGetFrameNum()*panel.getValueF("zspeed"), mc.worlddim.z );
		zpos*=-1;
		ofPoint mp( ofGetMouseX(), ofGetMouseY(), zpos);
		ofPoint md( 1000, 600, -1000);
		md *= panel.getValueF("balldim");
		mc.addBall(mp, md, panel.getValueF("ballforce"));
		mc.polygoniseData();
	}
	
//	mc.setData(mcdata);
	

	if(panel.getValueB("go")){

	}
	
	if(panel.getValueB("saveStl")){
		panel.setValueB("saveStl", false);
		string fn = ofToString(mc.gx) +"x"+ofToString(mc.gy)+"x"+ofToString(mc.gz)+"-"+ofToString(ofGetFrameNum())+".stl";
		mc.saveStl(fn);
	}
	
	if(panel.getValueB("mczero")){
		panel.setValueB("mczero", false);		
		mc.clear();
	}		
	
}

//--------------------------------------------------------------
void testApp::draw(){
	ofBackground(0);
	ofSetColor(255);
	
	glPushMatrix();
	glEnable(GL_DEPTH_TEST);
	ofEnableLighting();
	light.enable();
	
	glTranslatef(mc.worldcenter.x, mc.worldcenter.y, mc.worldcenter.z);
	glRotatef(panel.getValueF("rz"), 0, 0, 1);
	glRotatef(panel.getValueF("ry"), 0, 1, 0);
	glRotatef(panel.getValueF("rx"), 1, 0, 0);
	glTranslatef(-mc.worldcenter.x, -mc.worldcenter.y, -mc.worldcenter.z);

	
	if(ofGetFrameNum()>100)
		mc.draw();
	glDisable(GL_DEPTH_TEST);
	ofDisableLighting();
	light.disable();

	
	float zpos = fmodf( ofGetFrameNum()*panel.getValueF("zspeed"), mc.worlddim.z );
	zpos*=-1;
	
	panel.setValueF("zpos",zpos);
	
	ofPoint mp( ofGetMouseX(), ofGetMouseY(), zpos);
	ofPoint md( 1000, 600, -1000);
	ofPushMatrix();
	ofTranslate(mp);
	
	if(ofGetMousePressed())
		ofSetColor(255,0,0);
	
	ofBox(10);
	ofNoFill();
	ofSphere(0,0,0, 1000 * panel.getValueF("balldim"));
	ofFill();
	ofPopMatrix();
	
	glPopMatrix();
}



//--------------------------------------------------------------
void testApp::keyPressed(int key){

	if(key==' '){
		bool state = panel.getValueB("go");
		panel.setValueB("go", !state);
	}
	if(key=='s'){
		panel.setValueB("saveStl", true);
	}
	if(key=='p'){
		mc.post();
	}
}

//--------------------------------------------------------------
void testApp::keyReleased(int key){

}

//--------------------------------------------------------------
void testApp::mouseMoved(int x, int y ){

}

//--------------------------------------------------------------
void testApp::mouseDragged(int x, int y, int button){

}

//--------------------------------------------------------------
void testApp::mousePressed(int x, int y, int button){

}

//--------------------------------------------------------------
void testApp::mouseReleased(int x, int y, int button){

}

//--------------------------------------------------------------
void testApp::windowResized(int w, int h){

}

//--------------------------------------------------------------
void testApp::gotMessage(ofMessage msg){

}

//--------------------------------------------------------------
void testApp::dragEvent(ofDragInfo dragInfo){ 

}