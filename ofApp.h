#pragma once

#include "ofxiOS.h"
#include "ofxiOS.h"
//#include "ofxiOSVideoWriter.h"

#include "ARMatch.h"

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
    

    // -- AR --
    ofVideoGrabber cam;

    ofxCv::Calibration calibration;
    vector<cv::Point3f> objectPoints;
    vector<cv::Point2f> imagePoints;
    cv::Size patternSize;
    ofMatrix4x4 modelMatrix;
    ofLight light;
 
    //
    
    bool found1, found2;
    ARMatch arMatch1, arMatch2;
    
    //
//    ofxiOSVideoWriter videoWriter;
};


