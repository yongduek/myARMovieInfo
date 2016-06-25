# myARMovieInfo
Using ofxCv for iOS App with OpenFrameworks 0.9.3

Homography based very simple AR app. No 3D calculation is done; if it is needed, look at one of the examples of ofxCv.

* In Xcode, Assets.framework needs to be included
* Do not include ofxOpenCV because it will not be used and may cause compile/link errors. The app will use directly the library opencv2.framework for iOS downloaded from opencv.org. So, do not include ofxOpenCV.
* By setting deploy version > 0.6, much of the warnings will disappear.
* Two movie posters included in bin/data folder can be recognized at the same time by the app.
* The framerate was approx 3~4 fps in my iPhone6. If one of the ARMatch instance is not used, the framerate will be doubled.

1. Install openframeworks for ios.

2. Install ofxCv from https://github.com/kylemcdonald/ofxCv

3. Make a new app using projectGenerator-ios/projectGenerator
 - name it as myARMovieInfo
 - include ofxCv (no ofxOpenCV)
 - put all the source files in the src folder of the project
 - bin folder goes where its name indicates. It contains image data.

4. Download one of the following at opencv.org
  - opencv2.framework version 2.4.13, the most recent version 
  - opencv2.framework version 2.3.1
  - put it in the folder: myARMovieInfo

When the app is compiled, copied into the phone/ipad, and run, make it look at either of the two posters. It will display some red dots, a rectangle around the poster, and a few strings showing the title of the movie.

Comments & questions: yndk@sogang.ac.kr
