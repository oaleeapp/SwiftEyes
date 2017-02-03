//
//  CVWrapper.m
//  Pods
//
//  Created by lee on 03/02/2017.
//
//

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

    UIImageView * imageView;
    CvVideoCamera * videoCamera;


    cv::Mat previousFrame;

    UIImageView * testImagView;
    bool isFirst;
}

-(void) startCameraImageView:(UIImageView *) cameraImageView andDisplayImageView:(UIImageView *) displayImageView {

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

}

- (void)processImage:(cv::Mat &)image
{



    cv::Mat im_copy = image.clone();
    cv::Mat currentMat;
    cv::Mat differenceImage;
    cv::cvtColor(image,currentMat,cv::COLOR_BGR2GRAY);

    if (!isFirst) {

        // Compare
        cv::absdiff(currentMat,previousFrame,differenceImage);

        dispatch_async(dispatch_get_main_queue(), ^{
            // do work here
            testImagView.image = [self UIImageFromCVMat:differenceImage];
        });

    } else {
        isFirst = false;
    }

    previousFrame = currentMat;

    //do not confuse this with a threshold image, we will need to perform thresholding afterwards.
    //			cv::absdiff(grayImage1,grayImage2,differenceImage);
}



+ (NSString *)itWorks {
    return @"Hello World!";
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

