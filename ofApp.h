#pragma once

#include "ofxiOS.h"
#include "ofxCv.h"

class ofApp : public ofxiOSApp {
    
public:
    void setup();
    void update();
    void draw();
    void exit();
    
    void touchDown(ofTouchEventArgs & touch);
    void touchMoved(ofTouchEventArgs & touch);
    void touchUp(ofTouchEventArgs & touch);
    void touchDoubleTap(ofTouchEventArgs & touch);
    void touchCancelled(ofTouchEventArgs & touch);
    
    void lostFocus();
    void gotFocus();
    void gotMemoryWarning();
    void deviceOrientationChanged(int newOrientation);
    
    ofVideoGrabber cam;
    ofxCv::Calibration calibration;
    vector<cv::Point3f> objectPoints;
    vector<cv::Point2f> imagePoints;
    ofMatrix4x4 modelMatrix;
    bool found;
    cv::Size patternSize;
    ofLight light;
    
};


