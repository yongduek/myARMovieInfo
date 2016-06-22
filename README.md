# myARMovieInfo
Using ofxCv for iOS App with OpenFrameworks 0.9.3

* In Xcode, Assets.framework needs to be included.
* By setting deploy version > 0.6, much of the warning will disappear.
* Two movie posters included in bin/data folder can be recognized at the same time by the app.
* The framerate is approx 3~4 fps.

Install openframeworks for ios.

Install ofxCv from https://github.com/kylemcdonald/ofxCv

Make a new app using projectGenerator-ios/projectGenerator
 - name it as myARMovieInfo
 - include ofxCv
 - put all the source files in the src folder of the project
 - bin folder goes where its name indicates

Download one of the following at opencv.org
  - opencv2.framework version 2.4.13, the most recent version 
  - opencv2.framework version 2.3.1
  - put it in the folder: myARMovieInfo

When the app is compiled, copied into the phone/ipad, and run, make it look at the either of the two posters. It will display some points, boxes, and a few strings including the title of the movie.

Comments & questions: yndk@sogang.ac.kr
