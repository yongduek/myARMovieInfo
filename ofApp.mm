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

//--------------------------------------------------------------
void ofApp::setup(){
    
    arMatch.setup();
    
    ofSetVerticalSync(true);
    cam.setup(320,240); // (320x240) -> 360x480
    // (640,480) -> (480,640)
    
    calibration.load("calibInfo.yml");
    patternSize = calibration.getPatternSize();
    objectPoints = ofxCv::Calibration::createObjectPoints(patternSize, 1., ofxCv::CHESSBOARD);
    found = false;
    
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
        
        found = arMatch.detect(rview);
    }

}

static float yp = 500;
//--------------------------------------------------------------
void ofApp::draw(){
    fps.count();
    ofSetColor(255);
    cam.draw(0,0);
    arMatch.draw();
    
    if (found) {
        ofSetColor (255,0,0);
        ofSetLineWidth(3);
        for (int i=0; i<=4; i++)
            ofDrawLine(arMatch.ImageCorners[i%4].x, arMatch.ImageCorners[i%4].y,
                       arMatch.ImageCorners[(i+1)%4].x, arMatch.ImageCorners[(i+1)%4].y
                       );
//        printf("arMatch.ImageCorners[0],[1]= (%.1f, %.1f), (%.1f, %.1f)\n",
//               arMatch.ImageCorners[0].x, arMatch.ImageCorners[0].y,
//               arMatch.ImageCorners[1].x, arMatch.ImageCorners[10].y);
        
    }
    
    string str =  string("Movie Time: 7:30pm\nMain Theater.\n") + "\nFPS: " + to_string (fps.fps()) ;
    ofSetColor (255,0,0);
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
