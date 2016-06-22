#include "ofApp.h"

struct FPS {
    float elapsedTime;
    unsigned long frameCount;
    FPS () : elapsedTime(0), frameCount(0) {}
    void count() { ++frameCount; }
    float fps() {
        float f = frameCount*1000. / (ofGetElapsedTimeMillis() - elapsedTime);
        if (frameCount>300) {
            elapsedTime = ofGetElapsedTimeMillis();
            frameCount = 0;
        }
        return f;
    }
} fps;

const string MarkerImageName1 = "query240x344.png";
const string MarkerImageName2 = "abird200x296.png";

//--------------------------------------------------------------
void ofApp::setup(){
    
    arMatch1.setup(MarkerImageName1, string("Hymalaya"));
    arMatch2.setup(MarkerImageName2, string("Angry Birds"));
    
    ofSetVerticalSync(true);
    cam.setup(320,240); // (320x240) -> 360x480
    // (640,480) -> (480,640)
    
//    calibration.load("calibInfo.yml");
//    patternSize = calibration.getPatternSize();
//    objectPoints = ofxCv::Calibration::createObjectPoints(patternSize, 1., ofxCv::CHESSBOARD);
    found1 = found2 = false;
    
    light.enable();
    light.setPosition(200, 0, 0);
    ofDisableLighting();
    
    // with retina, screensize = 640x1136
    printf("setup(): ScreenSize=%dx%d\n", ofGetScreenWidth(), ofGetScreenHeight());
    printf("setup(): CameraSize=%.0fx%.0f\n", cam.getWidth(), cam.getHeight());
}

//--------------------------------------------------------------
bool flag_vecrgb =false;

void ofApp::update(){
    cam.update();
    if(cam.isFrameNew()) {
        flag_vecrgb = true;
        static cv::Mat rview;
        cv::cvtColor(ofxCv::toCv(cam), rview, CV_BGR2GRAY);
        
        found1 = arMatch1.detect(rview);
        found2 = arMatch2.detect(rview);
    }

}

//--------------------------------------------------------------
void ofApp::draw(){
    fps.count();
    ofSetColor(255);
    cam.draw(0,0);
    if (found1)
        arMatch1.draw();
    if (found2)
        arMatch2.draw();        
    
    string str =  "FPS: " + to_string (fps.fps()) ;
    ofSetColor (255,0,255);
    static float yp = 550;
    ofDrawBitmapString(str, 20, yp);
    
//    if (yp >= ofGetScreenHeight()) yp=10;
//    printf("ofGetScreenHeight=%d ofGetHeight=%d\n", ofGetScreenHeight(), ofGetHeight());
}

//--------------------------------------------------------------
void ofApp::exit(){

}

//--------------------------------------------------------------
void ofApp::touchDown(ofTouchEventArgs & touch){

}

//--------------------------------------------------------------
void ofApp::touchMoved(ofTouchEventArgs & touch){

}

//--------------------------------------------------------------
void ofApp::touchUp(ofTouchEventArgs & touch){

}

//--------------------------------------------------------------
void ofApp::touchDoubleTap(ofTouchEventArgs & touch){

}

//--------------------------------------------------------------
void ofApp::touchCancelled(ofTouchEventArgs & touch){
    
}

//--------------------------------------------------------------
void ofApp::lostFocus(){

}

//--------------------------------------------------------------
void ofApp::gotFocus(){

}

//--------------------------------------------------------------
void ofApp::gotMemoryWarning(){

}

//--------------------------------------------------------------
void ofApp::deviceOrientationChanged(int newOrientation){

}
