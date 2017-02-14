//
//  ObjectTracker.cpp
//  Pods
//
//  Created by lee on 12/02/2017.
//
//




//motionTracking.cpp

//Written by  Kyle Hounslow, December 2013

//Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software")
//, to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense,
//and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

//The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
//IN THE SOFTWARE.

#include <opencv2/highgui/highgui.hpp>
#include <opencv2/core/core.hpp>
#include <opencv2/imgproc/imgproc.hpp>
#include <iostream>
#include <iomanip>
#include <sstream>
#include <string>
#include <deque>
#include <vector>
#include "ObjectTracker.hpp"


using namespace std;
using namespace cv;

//our sensitivity value to be used in the absdiff() function
//const static int SENSITIVITY_VALUE = 20;
//size of blur used to smooth the intensity image output from absdiff() function
//const static int BLUR_SIZE = 10;
//we'll have just one object to search for
//and keep track of its position.
int theObject[2] = {0,0};
//bounding rectangle of the object, we will use the center of this as its position.
CvRect objectBoundingRectangle = CvRect(0,0,0,0);


//int to string helper function
string intToString(int number){

    //this function has a number input and string output
    std::stringstream ss;
    ss << number;
    return ss.str();
}

void searchForMovement(Mat thresholdImage, Mat &cameraFeed){
    //notice how we use the '&' operator for objectDetected and cameraFeed. This is because we wish
    //to take the values passed into the function and manipulate them, rather than just working with a copy.
    //eg. we draw to the cameraFeed to be displayed in the main() function.
    bool objectDetected = false;
    Mat temp;
    thresholdImage.copyTo(temp);
    //these two vectors needed for output of findContours
    vector< vector<cv::Point> > contours;
    vector<Vec4i> hierarchy;
    //find contours of filtered image using openCV findContours function
    //findContours(temp,contours,hierarchy,CV_RETR_CCOMP,CV_CHAIN_APPROX_SIMPLE );// retrieves all contours

    findContours(temp,contours,hierarchy,CV_RETR_EXTERNAL,CV_CHAIN_APPROX_SIMPLE );// retrieves external contours

    //if contours vector is not empty, we have found some objects
    if(contours.size()>0)objectDetected=true;
    else objectDetected = false;

    if(objectDetected){
        //the largest contour is found at the end of the contours vector
        //we will simply assume that the biggest contour is the object we are looking for.
        vector< vector<cv::Point> > largestContourVec;
        largestContourVec.push_back(contours.at(contours.size()-1));
        //make a bounding rectangle around the largest contour then find its centroid
        //this will be the object's final estimated position.
        objectBoundingRectangle = boundingRect(largestContourVec.at(0));
        int xpos = objectBoundingRectangle.x+objectBoundingRectangle.width/2;
        int ypos = objectBoundingRectangle.y+objectBoundingRectangle.height/2;

        //update the objects positions by changing the 'theObject' array values
        theObject[0] = xpos , theObject[1] = ypos;
    }
    //make some temp x and y variables so we dont have to type out so much
    int x = theObject[0];
    int y = theObject[1];

    //draw some crosshairs around the object
    circle(cameraFeed,cv::Point(x,y),20,Scalar(0,255,0),2);
    line(cameraFeed,cv::Point(x,y),cv::Point(x,y-25),Scalar(0,255,0),2);
    line(cameraFeed,cv::Point(x,y),cv::Point(x,y+25),Scalar(0,255,0),2);
    line(cameraFeed,cv::Point(x,y),cv::Point(x-25,y),Scalar(0,255,0),2);
    line(cameraFeed,cv::Point(x,y),cv::Point(x+25,y),Scalar(0,255,0),2);

    //write the position of the object to the screen
    putText(cameraFeed,"Tracking object at (" + intToString(x)+","+intToString(y)+")",cv::Point(x,y),1,1,Scalar(255,0,0),2);


}
