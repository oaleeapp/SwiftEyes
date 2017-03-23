//
//  OCVAbstractCamera+Private.h
//  Pods
//
//  Created by lee on 02/03/2017.
//
//

#import "OCVAbstractCamera.h"

#import <opencv2/videoio/cap_ios.h>

@interface OCVAbstractCamera(OpenCV)

@property (nonatomic, strong) CvAbstractCamera *source;

@end

