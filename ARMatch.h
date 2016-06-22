//
//  ARMatch.h
//  myARmovieInfor
//
//  Created by Yongduek Seo on 2016. 6. 22..
//
//

#ifndef ARMatch_h
#define ARMatch_h

#include "ofxCv.h"

struct ARMatch {
    const bool dbgflag=false;
    const float KNN_MATCH_RATIO = 0.7;
    string MarkerImageName, movieName;
    
    cv::Mat QueryMat;
    ofImage QueryImage;
    
    cv::Mat DescriptQuery;
    cv::Ptr<cv::FeatureDetector> Feature;
    vector<cv::KeyPoint> KeyPtQuery;
    cv::Ptr<cv::DescriptorMatcher> Matcher;
    vector<vector<cv::DMatch> > MatchListKNN;
    
    vector<cv::Point2f> ImageCorners;
    
    void setup(string imagefilename, string _movieName) {
        movieName = _movieName;
        QueryImage.load(MarkerImageName=imagefilename);
        
        if (QueryImage.isAllocated()) {
            cerr << "Model Image loaded: " << MarkerImageName << endl;
        }
        QueryMat = ofxCv::toCv(QueryImage);
        
        Feature = cv::AKAZE::create();
        Feature->detectAndCompute (QueryMat, cv::noArray(), KeyPtQuery, DescriptQuery);
        //        Feature->detect(QueryMat, KeyPtQuery);
        //        Feature->compute(QueryMat, KeyPtQuery, DescriptQuery);
        
        fprintf (stderr, "ARMatch::setup(): query feature saved %lu\n", KeyPtQuery.size());
    }
    
    void KeyPoint2Point2f(vector<cv::KeyPoint> &InputKeypoint, vector<cv::Point2f> &OutputKeypoint) {
        if (!OutputKeypoint.empty()) OutputKeypoint.clear();
        for (int i = 0; i < InputKeypoint.size(); i++) {
            OutputKeypoint.push_back(InputKeypoint[i].pt);
        }
    }
    
    bool detectFlag = false;
    unsigned count=0;
    vector<cv::KeyPoint> KeyPtTrain, KeyPtTrainBest;
    vector<cv::Point2f> PointQuery, PointTrain;
    vector<uchar> inliersVec;
    //cv::Mat_<uchar> inliersVec;
    
    bool detect(cv::Mat& rview) {
        if (rview.empty()) return detectFlag = false;
        ++count;
        
        cv::Mat DescriptTrain;
        KeyPtTrain.clear();
        Feature->detectAndCompute (rview, cv::noArray(), KeyPtTrain, DescriptTrain);
        
        if (dbgflag) fprintf (stderr, "detect(%d): train feature [%d] \n", count, KeyPtTrain.size());
        
        if (KeyPtTrain.size()<150) return detectFlag = false;
        
        MatchListKNN.clear();
        Matcher = cv::DescriptorMatcher::create("BruteForce-Hamming");
        Matcher->knnMatch(DescriptQuery, DescriptTrain, MatchListKNN, 2);
        
        if (dbgflag) fprintf (stderr, "detect(%d): train feature [%u] -> knn [%u]\n",
                              count, KeyPtTrain.size(), MatchListKNN.size());
        
        KeyPtTrainBest.clear();
        vector<cv::KeyPoint> KeyPtQueryBest;
        vector<cv::DMatch> MatchListBest;
        for (size_t i = 0; i < MatchListKNN.size(); i++) {
            cv::DMatch first = MatchListKNN[i][0];
            float dist1 = MatchListKNN[i][0].distance;
            float dist2 = MatchListKNN[i][1].distance;
            
            if (dist1 < KNN_MATCH_RATIO*dist2) {
                KeyPtQueryBest.push_back(KeyPtQuery[first.queryIdx]);
                KeyPtTrainBest.push_back(KeyPtTrain[first.trainIdx]);
                MatchListBest.push_back(cv::DMatch(KeyPtQueryBest.size() - 1, KeyPtTrainBest.size() - 1, 0));
            }
        }
        
        PointQuery.clear();
        PointTrain.clear();
        KeyPoint2Point2f(KeyPtQueryBest, PointQuery);
        KeyPoint2Point2f(KeyPtTrainBest, PointTrain);
        
        if (MatchListBest.size() > 50) {
            inliersVec = cv::Mat_<uchar>();
            cv::Mat Homography = cv::findHomography(PointQuery, PointTrain, cv::RANSAC, 2.f, inliersVec);
            
            if (dbgflag) cerr << "inLiers = " << cv::countNonZero (inliersVec) << endl;
            //cerr << "inlierVec: " << inliersVec << endl;
            if (dbgflag) cerr << "Homography: " << Homography << endl;
            
            if (cv::countNonZero(inliersVec)<20) { KeyPtTrainBest.clear(); return detectFlag = false; }
            
            vector<cv::Point2f> QueryCorners(4);
            QueryCorners[0] = cv::Point2f(0, 0);
            QueryCorners[1] = cv::Point2f(QueryMat.cols, 0);
            QueryCorners[2] = cv::Point2f(QueryMat.cols, QueryMat.rows);
            QueryCorners[3] = cv::Point2f(0, QueryMat.rows);
            
            // allocate
            ImageCorners = QueryCorners;
            perspectiveTransform(QueryCorners, ImageCorners, Homography);
            // draw a quadrangle around the four points //
            return detectFlag = true;
        }
        KeyPtTrainBest.clear();
        return detectFlag = false;
    }
    
    void draw() {
        //vector<cv::Point2f> PointTrain;
        //cv::Mat inliersVec;
        for (int i=0; i<KeyPtTrain.size(); i++) {
            ofSetColor (ofRandom(0,255), ofRandom(0,255), 255);
            ofDrawCircle (KeyPtTrain[i].pt.x, KeyPtTrain[i].pt.y, 1);
        }
        
        if (detectFlag) {
            
            ofSetColor (255,255,0);
            ofSetLineWidth(3);
            for (int i=0; i<=4; i++)
                ofDrawLine(ImageCorners[i%4].x, ImageCorners[i%4].y,
                           ImageCorners[(i+1)%4].x, ImageCorners[(i+1)%4].y
                           );

            ofSetColor (255,0,0);
            for (int i=0; i<inliersVec.size(); i++) { //PointTrain.size(); i++) {
                if (inliersVec[i] > 0)
                    ofDrawCircle (PointTrain[i].x, PointTrain[i].y, 2 );
            }
            
            string str = movieName + "\n"
                       + string("Movie Time: 7:30pm\nMain Theater.\n");
            ofSetColor (255,0,0);
            const int yp = 500;
            ofDrawBitmapString(str, 20, yp);

        }
    } // draw()
};



#endif /* ARMatch_h */
