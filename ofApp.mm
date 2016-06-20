#include "ofApp.h"

//--------------------------------------------------------------
void ofApp::setup() {
    ofSetVerticalSync(true);
    cam.setup(320,240);
    
    calibration.load("mbp-2011-isight.yml");
    patternSize = calibration.getPatternSize();
    objectPoints = ofxCv::Calibration::createObjectPoints(patternSize, 1., ofxCv::CHESSBOARD);
    found = false;
    
    light.enable();
    light.setPosition(200, 0, 0);
    ofDisableLighting();

}

std::vector<cv::Mat> vecrgb;
bool flag_vecrgb =false;
//--------------------------------------------------------------
void ofApp::update() {
    cam.update();
    if(cam.isFrameNew()) {
        cv::split (ofxCv::toCv(cam), vecrgb);
        flag_vecrgb = true;
        //found = calibration.findBoard(ofxCv::toCv(cam), imagePoints);
        found = calibration.findBoard(vecrgb[1], imagePoints);
        if(found) {
            cv::Mat cameraMatrix = calibration.getDistortedIntrinsics().getCameraMatrix();
            cv::Mat rvec, tvec;
            solvePnP(cv::Mat(objectPoints), cv::Mat(imagePoints), cameraMatrix, calibration.getDistCoeffs(), rvec, tvec);
            modelMatrix = ofxCv::makeMatrix(rvec, tvec);
        }

        char str[512];
        sprintf (str, "%.1fx%.1f\n", cam.getWidth(), cam.getHeight());
        ofDrawBitmapString(str, 30, 200);
    }
}

//--------------------------------------------------------------

void ofApp::draw(){
    ofSetColor(255);
    cam.draw(0, 0);
    if(found) {
        calibration.getDistortedIntrinsics().loadProjectionMatrix();
        ofxCv::applyMatrix(modelMatrix);
        
        ofMesh mesh;
        mesh.setMode(OF_PRIMITIVE_POINTS);
        for(int i = 0; i < objectPoints.size(); i++) {
            mesh.addVertex(ofxCv::toOf(objectPoints[i]));
        }
        glPointSize(3);
        ofSetColor(50,250,250);
        mesh.drawVertices();
        
        ofEnableLighting();
        ofSetColor(255);
        ofEnableDepthTest();
        ofDrawAxis(5);
        ofPushMatrix();
        // ---------
        ofTranslate(.5, .5, -.5);
        ofDrawBox (0,0, 0, 1);
//        for(int i = 0; i < patternSize.width / 2; i++) {
//            for(int j = 0; j < patternSize.height / 2; j++) {
//                for(int k = 0; k < 3; k++) {
//                    ofDrawBox(2 * i, 2 * j, -2 * k, 1);
//                }
//            }
//        }
        // ---------
        ofPopMatrix();
        ofDisableDepthTest();
        ofDisableLighting();
    }
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
