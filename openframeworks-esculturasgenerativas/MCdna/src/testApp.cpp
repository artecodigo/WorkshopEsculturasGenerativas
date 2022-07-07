#include "testApp.h"



//--------------------------------------------------------------
void testApp::setup(){
	
	ofSetFrameRate(60);		

	int mcres = 32;	
	mc.setup(ofGetWidth(),ofGetHeight(),-ofGetWidth(), mcres, mcres, mcres);
		
	cam.setTarget(mc.worldcenter);
	cam.setDistance(ofGetWidth());
	
//	ofEnableLighting();
	ofSetGlobalAmbientColor(ofColor(200,255,250));

	mc.isolevel = 0.02;
	
	
	layer.assign(mcres*mcres, 0.0f);
	layer[mcres] = 1;
	dna.setup(&layer);
	dna.setBoundsMode(1);//clamp
	
	
	ofPoint loc(5,15,0);
	ofPoint dim(150,20,0);
	
	panel.setup("mcdna", loc, dim);
	
	panel.addSlider("fps", 32, 0, 128);
	panel.addSlider("mcres", 32, 2, 128);
	panel.addSlider("mciso", 0.02, 0., 0.5);
	panel.addSlider("mczspeed", 0.02, 0., 0.5);
	panel.addSlider("dnamutationprob", 0.0002, 0., 0.5);
	panel.addSlider("dnamutationamount", 0.002, 0., 0.5);
	panel.addSlider("dnabound", 2, 0, 2);
	
	panel.dim.set(20,20,0);
	panel.addButton("mcinvertnormals", 1);
	panel.addButton("gomc", 1);
	panel.addButton("mutatedna", 1);
	panel.addButton("savestl", 0);
	
}

//--------------------------------------------------------------
void testApp::update(){
	
	panel.set("fps", ofGetFrameRate());
	
	panel.update();
	
	if(panel.isValsNew("mcres")){
		cout << "setting new res" << endl;
		int mcres = (int)panel.get("mcres");	
		mc.setup(ofGetWidth(),ofGetHeight(),-ofGetWidth(), mcres, mcres, mcres);
		layer.assign(mcres*mcres, 0.0f);
		layer[mcres] = 1;
		dna.setup(&layer);
		dna.setBoundsMode(1);//clamp
	}
	
	if(panel.isValsNew("mciso")){
		mc.isolevel = panel.get("mciso");
	}
	if(panel.isValsNew("mcinvertnormals")){
		mc.invertnormals = panel.get("mcinvertnormals");
	}
	if(panel.isValsNew("mczspeed")){
		mc.setDataZSpeed(panel.get("mczspeed"));
	}
	if(panel.isValsNew("dnabound")){
		dna.setBoundsMode((int)panel.get("dnabound"));
	}
	
	if(panel.getBool("mutatedna")){
//		dna.mutate(panel.get("dnamutationprob"));//, panel.get("dnamutationamount"));
		dna.mutate(panel.get("dnamutationprob"), panel.get("dnamutationamount"));
		vector<float> * dnadata = dna.getDna();
		for(int i=0; i<dnadata->size();i++){
			layer[i] = dnadata->at(i);
		}
	}
	
	if(panel.getBool("gomc")){		
		mc.setDataXY(layer);
//		mc.addDataXY(layer);
		mc.updateDataZspeed();
		mc.polygoniseData();		
	}
	
	
	if(panel.getBool("savestl")){		
		string fn = ofToString(mc.gx) +"x"+ofToString(mc.gy)+"x"+ofToString(mc.gz)+"-"+ofToString(ofGetFrameNum())+".stl";
		mc.saveStl(fn);
		panel.set("savestl",0);
	}
	
	
	
}

//--------------------------------------------------------------
void testApp::draw(){
	cam.begin();
	ofBackground(0);
	ofSetColor(255);
	
	mc.draw();

	
	ofSetColor(255,0,0);
	mc.drawnormals(0.021);
	cam.end();
	
	ofSetupScreen();
	ofSetColor(255);
	panel.draw();
	
}



//--------------------------------------------------------------
void testApp::keyPressed(int key){

	if(key=='s'){
		string fn = ofToString(mc.gx) +"x"+ofToString(mc.gy)+"x"+ofToString(mc.gz)+"-"+ofToString(ofGetFrameNum())+".stl";
		mc.saveStl(fn);
	}
	if(key=='c'){
		mc.clear();
		mc.polygoniseData();
	}
	if(key=='f'){
		mc.multData(0.9f);
		mc.polygoniseData();
	}
	if(key=='r'){
		dna.setRandomDNA();
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