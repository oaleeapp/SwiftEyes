//
//  CVWrapper.m
//  Pods
//
//  Created by lee on 03/02/2017.
//
//


//Reference:
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

//objectTrackingTutorial.cpp

//Written by  Kyle Hounslow 2013

//Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software")
//, to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense,
//and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

//The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
//IN THE SOFTWARE.




#import "CVWrapper.hpp"
#import <opencv2/videoio/cap_ios.h>
#include <opencv2/core/core.hpp>
#include <opencv2/highgui/highgui.hpp>
#include <opencv2/imgproc/imgproc.hpp>
#include <stdio.h>


@interface CVWrapper () <CvVideoCameraDelegate>
{

}
@end

@implementation CVWrapper
{

    bool isMotionTracking;

    UIImageView * imageView;
    CvVideoCamera * videoCamera;
    cv::Mat previousFrame;

    UIImageView * testImagView;
    bool isFirst;



    //initial min and max HSV filter values.
    //these will be changed using trackbars
    int H_MIN;
    int H_MAX;
    int S_MIN;
    int S_MAX;
    int V_MIN;
    int V_MAX;

    int x;
    int y;


    //and keep track of its position.
    cv::Point objectPoint;
    //bounding rectangle of the object, we will use the center of this as its position.
    CvRect objectBoundingRectangle;


}

-(void) startCameraImageView:(UIImageView *) cameraImageView andDisplayImageView:(UIImageView *) displayImageView {

    //and keep track of its position.
    objectPoint = cv::Point(0,0);
    //bounding rectangle of the object, we will use the center of this as its position.
    objectBoundingRectangle = CvRect(0,0,0,0);


    imageView = cameraImageView;
    testImagView = displayImageView;
    videoCamera = [[CvVideoCamera alloc] initWithParentView:imageView];
    videoCamera.delegate = self;
    videoCamera.defaultAVCaptureDevicePosition = AVCaptureDevicePositionFront;
    videoCamera.defaultAVCaptureSessionPreset = AVCaptureSessionPreset352x288;
    videoCamera.defaultAVCaptureVideoOrientation = AVCaptureVideoOrientationPortrait;
    videoCamera.defaultFPS = 20;
    videoCamera.rotateVideo = true;
    [videoCamera start];
    isFirst = true;
    isMotionTracking = true;

}

-(void) startDisplayImageView:(UIImageView *) displayImageView andFilterImageView:(UIImageView *) filterImageView{

    imageView = displayImageView;
    videoCamera = [[CvVideoCamera alloc] initWithParentView:imageView];
    videoCamera.delegate = self;
    videoCamera.defaultAVCaptureDevicePosition = AVCaptureDevicePositionFront;
    videoCamera.defaultAVCaptureSessionPreset = AVCaptureSessionPreset352x288;
    videoCamera.defaultAVCaptureVideoOrientation = AVCaptureVideoOrientationPortrait;
    videoCamera.defaultFPS = 20;
    videoCamera.rotateVideo = true;
    [videoCamera start];
    isFirst = true;
    isMotionTracking = false;

    testImagView = filterImageView;
}

- (void)processImage:(cv::Mat &)image
{
    cv::Mat im_copy = image.clone();
    cv::Mat currentMat;

    if (isMotionTracking) {

        //our sensitivity value to be used in the absdiff() function
        const static int SENSITIVITY_VALUE = 20;
        //size of blur used to smooth the intensity image output from absdiff() function
        const static int BLUR_SIZE = 10;

        cv::Mat differenceImage;
        cv::cvtColor(image,currentMat,cv::COLOR_BGR2GRAY);

        if (!isFirst) {

            // Compare
            cv::absdiff(currentMat,previousFrame,differenceImage);
            //blur the image to get rid of the noise. This will output an intensity image
            blur(differenceImage,differenceImage,cv::Size(BLUR_SIZE,BLUR_SIZE));
            //			//threshold again to obtain binary image from blur output
            threshold(differenceImage,differenceImage,SENSITIVITY_VALUE,255,cv::THRESH_BINARY);
//            searchForMovement(differenceImage, image);

            [self searchForMovementForThreshold:differenceImage andCameraFeed:image];

            dispatch_async(dispatch_get_main_queue(), ^{
                // do work here
                if (testImagView != nil){
                    testImagView.image = [self UIImageFromCVMat:differenceImage];
                }
            });
            
        } else {
            isFirst = false;
        }
        

        previousFrame = currentMat;
    } else {
        cv::Mat hsvImage;
        cv::Mat threshold;

        cv::cvtColor(image,hsvImage,cv::COLOR_BGR2HSV);
        cv::inRange(hsvImage, cv::Scalar(H_MIN,S_MIN,V_MIN), cv::Scalar(H_MAX,S_MAX,V_MAX), threshold);

        [self morphOps:threshold];

            // do work here
        if (testImagView != nil){
            dispatch_async(dispatch_get_main_queue(), ^{
                testImagView.image = [self UIImageFromCVMat:threshold];
            });

            [self trackFilteredObject:x andY:y andThreshold:threshold andCameraFeed:image];
        }


    }
}


-(void) morphOps:(cv::Mat)threshold {

    //create structuring element that will be used to "dilate" and "erode"
    //the element chosen here is a 3px by 3px rectangle
    cv::Mat erodeElement = cv::getStructuringElement(cv::MORPH_RECT, cv::Size(3,3));

    //dilate with larger element so make sure object is nicely visible
    cv::Mat dilateElement = cv::getStructuringElement(cv::MORPH_RECT, cv::Size(8,8));


    cv::erode(threshold,threshold,erodeElement);
    cv::erode(threshold,threshold,erodeElement);

    cv::dilate(threshold,threshold,erodeElement);
    cv::dilate(threshold,threshold,erodeElement);
}

-(void) trackFilteredObject:(int)trackX andY: (int) trackY andThreshold: (cv::Mat ) threshold andCameraFeed: (cv::Mat &) cameraFeed {

    //default capture width and height
    const int FRAME_WIDTH = videoCamera.imageWidth;
    const int FRAME_HEIGHT = videoCamera.imageHeight;
    //max number of objects to be detected in frame
    const int MAX_NUM_OBJECTS=50;
    //minimum and maximum object area
    const int MIN_OBJECT_AREA = 20*20;
    const int MAX_OBJECT_AREA = FRAME_HEIGHT*FRAME_WIDTH/1.5;

    cv::Mat temp;
    threshold.copyTo(temp);
    //these two vectors needed for output of findContours
    std::vector< std::vector<cv::Point> > contours;
    std::vector<cv::Vec4i> hierarchy;
    //find contours of filtered image using openCV findContours function
    cv::findContours(temp,contours,hierarchy,CV_RETR_CCOMP,CV_CHAIN_APPROX_SIMPLE );
    //use moments method to find our filtered object
    double refArea = 0;
    bool objectFound = false;
    if (hierarchy.size() > 0) {
        long numObjects = hierarchy.size();
        //if number of objects greater than MAX_NUM_OBJECTS we have a noisy filter
        if(numObjects < MAX_NUM_OBJECTS){
            for (int index = 0; index >= 0; index = hierarchy[index][0]) {

                cv::Moments moment = moments((cv::Mat)contours[index]);
                double area = moment.m00;

                //if the area is less than 20 px by 20px then it is probably just noise
                //if the area is the same as the 3/2 of the image size, probably just a bad filter
                //we only want the object with the largest area so we safe a reference area each
                //iteration and compare it to the area in the next iteration.
                if(area>MIN_OBJECT_AREA && area<MAX_OBJECT_AREA && area>refArea){
                    trackX = moment.m10/area;
                    trackY = moment.m01/area;
                    objectFound = true;
                    refArea = area;
                }else objectFound = false;


            }
            //let user know you found an object
            if(objectFound ==true){
                cv::putText(cameraFeed,"Tracking Object",cv::Point(0,50),2,1,cv::Scalar(0,255,0),2);
                //draw object location on screen

                [self drawObject:trackX andY:trackY andFrameMat:cameraFeed];
            }


        }else {
            cv::putText(cameraFeed,"TOO MUCH NOISE! ADJUST FILTER",cv::Point(0,50),1,2,cv::Scalar(0,0,255),2);
        }
    }
}

-(void) drawObject: (int) drawX andY: (int) drawY andFrameMat: (cv::Mat &) frame {

    //use some of the openCV drawing functions to draw crosshairs
    //on your tracked image!

    //UPDATE:JUNE 18TH, 2013
    //added 'if' and 'else' statements to prevent
    //memory errors from writing off the screen (ie. (-25,-25) is not within the window!)

    //default capture width and height
    const int FRAME_WIDTH = videoCamera.imageWidth;
    const int FRAME_HEIGHT = videoCamera.imageHeight;

    circle(frame,cv::Point(drawX,drawY),20,cv::Scalar(0,255,0),2);
    if(drawY-25>0)
        line(frame,cv::Point(drawX,drawY),cv::Point(drawX,drawY-25),cv::Scalar(0,255,0),2);
    else line(frame,cv::Point(drawX,drawY),cv::Point(drawX,0),cv::Scalar(0,255,0),2);
    if(drawY+25<FRAME_HEIGHT)
        line(frame,cv::Point(drawX,drawY),cv::Point(drawX,drawY+25),cv::Scalar(0,255,0),2);
    else line(frame,cv::Point(drawX,drawY),cv::Point(drawX,FRAME_HEIGHT),cv::Scalar(0,255,0),2);
    if(drawX-25>0)
        line(frame,cv::Point(drawX,drawY),cv::Point(drawX-25,drawY),cv::Scalar(0,255,0),2);
    else line(frame,cv::Point(drawX,drawY),cv::Point(0,drawY),cv::Scalar(0,255,0),2);
    if(drawX+25<FRAME_WIDTH)
        line(frame,cv::Point(drawX,drawY),cv::Point(drawX+25,drawY),cv::Scalar(0,255,0),2);
    else line(frame,cv::Point(drawX,drawY),cv::Point(FRAME_WIDTH,drawY),cv::Scalar(0,255,0),2);
    
}


-(void) searchForMovementForThreshold: (cv::Mat) thresholdImage andCameraFeed: (cv::Mat)cameraFeed {
    //notice how we use the '&' operator for objectDetected and cameraFeed. This is because we wish
    //to take the values passed into the function and manipulate them, rather than just working with a copy.
    //eg. we draw to the cameraFeed to be displayed in the main() function.
    bool objectDetected = false;
    cv::Mat temp;
    thresholdImage.copyTo(temp);
    //these two vectors needed for output of findContours
    std::vector< std::vector<cv::Point> > contours;
    std::vector<cv::Vec4i> hierarchy;
    //find contours of filtered image using openCV findContours function
    //findContours(temp,contours,hierarchy,CV_RETR_CCOMP,CV_CHAIN_APPROX_SIMPLE );// retrieves all contours

    findContours(temp,contours,hierarchy,CV_RETR_EXTERNAL,CV_CHAIN_APPROX_SIMPLE );// retrieves external contours

    //if contours vector is not empty, we have found some objects
    if(contours.size()>0)objectDetected=true;
    else objectDetected = false;

    if(objectDetected){
        //the largest contour is found at the end of the contours vector
        //we will simply assume that the biggest contour is the object we are looking for.
        std::vector< std::vector<cv::Point> > largestContourVec;
        largestContourVec.push_back(contours.at(contours.size()-1));
        //make a bounding rectangle around the largest contour then find its centroid
        //this will be the object's final estimated position.

        objectBoundingRectangle = boundingRect(largestContourVec.at(0));
        int xpos = objectBoundingRectangle.x+objectBoundingRectangle.width/2;
        int ypos = objectBoundingRectangle.y+objectBoundingRectangle.height/2;

        //update the objects positions by changing the 'theObject' array values
        objectPoint.x = xpos , objectPoint.y = ypos;
    }
    //make some temp x and y variables so we dont have to type out so much

    [self drawObject:objectPoint.x andY:objectPoint.y andFrameMat:cameraFeed];

}




-(void) reset{
    [videoCamera stop];
    isFirst = true;
}


- (void)setHMin: (int)hMin andHMax: (int)hMax andSMin: (int)sMin andSMax: (int)sMax andVMin: (int)vMin andVMax: (int)vMax{
    H_MIN = hMin;
    H_MAX = hMax;
    S_MIN = sMin;
    S_MAX = sMax;
    V_MIN = vMin;
    V_MAX = vMax;
}

-(UIImage *)turnToGray:(UIImage *) image{

    int threshold_value = 1;
//    int threshold_type = 3;
//    int const max_value = 255;
//    int const max_type = 4;
    int const max_BINARY_value = 2147483647; // 2147483647;
    cv::Mat src_gray=[self cvMatFromUIImage:image];
    cv::Mat dst;
    dst=src_gray;
    cv::cvtColor(src_gray, dst, cv::COLOR_RGB2GRAY);
    cv::threshold( dst, dst, threshold_value, max_BINARY_value,cv::THRESH_OTSU );

    return [self UIImageFromCVMat:dst];
}

-(UIImage *)outlineOf:(UIImage *) image {

    int threshold_value = 1;
//    int threshold_type = 3;
//    int const max_value = 255;
//    int const max_type = 4;
    int const max_BINARY_value = 2147483647; // 2147483647;
    cv::Mat src_gray=[self cvMatFromUIImage:image];
    cv::Mat dst;
    dst=src_gray;
    cv::cvtColor(src_gray, dst, cv::COLOR_RGB2GRAY);
    cv::threshold( dst, dst, threshold_value, max_BINARY_value,cv::THRESH_OTSU );

    //    return [self UIImageFromCVMat:dst];

    cv::Mat canny_output;
    std::vector<std::vector<cv::Point> > contours;
    std::vector<cv::Vec4i> hierarchy;

    cv::RNG rng(12345);

    cv::threshold( dst, dst, threshold_value, max_BINARY_value,cv::THRESH_OTSU );

    cv::Mat contourOutput = dst.clone();
    cv::findContours( contourOutput, contours, cv::RETR_LIST, cv::CHAIN_APPROX_NONE );

    //Draw the contours
    cv::Mat contourImage(dst.size(), CV_8UC3, cv::Scalar(0,0,0));
    cv::Scalar colors[3];
    colors[0] = cv::Scalar(255, 0, 0);
    colors[1] = cv::Scalar(0, 255, 0);
    colors[2] = cv::Scalar(0, 0, 255);
    for (int idx = 0; idx < contours.size(); idx++) {
        cv::drawContours(contourImage, contours, idx, colors[idx % 3]);
    }

    return [self UIImageFromCVMat:contourOutput];
}


- (cv::Mat)cvMatFromUIImage:(UIImage *)image
{
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(image.CGImage);
    CGFloat cols = image.size.width;
    CGFloat rows = image.size.height;

    cv::Mat cvMat(rows, cols, CV_8UC4); // 8 bits per component, 4 channels (color channels + alpha)

    CGContextRef contextRef = CGBitmapContextCreate(cvMat.data,                 // Pointer to  data
                                                    cols,                       // Width of bitmap
                                                    rows,                       // Height of bitmap
                                                    8,                          // Bits per component
                                                    cvMat.step[0],              // Bytes per row
                                                    colorSpace,                 // Colorspace
                                                    kCGImageAlphaNoneSkipLast |
                                                    kCGBitmapByteOrderDefault); // Bitmap info flags

    CGContextDrawImage(contextRef, CGRectMake(0, 0, cols, rows), image.CGImage);
    CGContextRelease(contextRef);

    return cvMat;
}
- (cv::Mat)cvMatGrayFromUIImage:(UIImage *)image
{
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(image.CGImage);
    CGFloat cols = image.size.width;
    CGFloat rows = image.size.height;
    cv::Mat cvMat(rows, cols, CV_8UC1); // 8 bits per component, 1 channels

    CGContextRef contextRef = CGBitmapContextCreate(cvMat.data,                 // Pointer to data
                                                    cols,                       // Width of bitmap
                                                    rows,                       // Height of bitmap
                                                    8,                          // Bits per component
                                                    cvMat.step[0],              // Bytes per row
                                                    colorSpace,                 // Colorspace
                                                    kCGImageAlphaNoneSkipLast |
                                                    kCGBitmapByteOrderDefault); // Bitmap info flags

    CGContextDrawImage(contextRef, CGRectMake(0, 0, cols, rows), image.CGImage);
    CGContextRelease(contextRef);

    return cvMat;
}


-(UIImage *)UIImageFromCVMat:(cv::Mat)cvMat
{
    NSData *data = [NSData dataWithBytes:cvMat.data length:cvMat.elemSize()*cvMat.total()];
    CGColorSpaceRef colorSpace;

    if (cvMat.elemSize() == 1) {
        colorSpace = CGColorSpaceCreateDeviceGray();
    } else {
        colorSpace = CGColorSpaceCreateDeviceRGB();
    }

    CGDataProviderRef provider = CGDataProviderCreateWithCFData((__bridge CFDataRef)data);

    // Creating CGImage from cv::Mat
    CGImageRef imageRef = CGImageCreate(cvMat.cols,                                 //width
                                        cvMat.rows,                                 //height
                                        8,                                          //bits per component
                                        8 * cvMat.elemSize(),                       //bits per pixel
                                        cvMat.step[0],                            //bytesPerRow
                                        colorSpace,                                 //colorspace
                                        kCGImageAlphaNone|kCGBitmapByteOrderDefault,// bitmap info
                                        provider,                                   //CGDataProviderRef
                                        NULL,                                       //decode
                                        false,                                      //should interpolate
                                        kCGRenderingIntentDefault                   //intent
                                        );


    // Getting UIImage from CGImage
    UIImage *finalImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    CGDataProviderRelease(provider);
    CGColorSpaceRelease(colorSpace);
    
    return finalImage;
}


@end

