//
//  CVWrapper.h
//  Pods
//
//  Created by lee on 03/02/2017.
//
//

#import <Foundation/Foundation.h>

@interface CVWrapper : NSObject

-(UIImage *)turnToGray:(UIImage *) image;
-(UIImage *)outlineOf:(UIImage *) image;
-(void) startCameraImageView:(UIImageView *) cameraImageView andDisplayImageView:(UIImageView *) displayImageView;
//-(void) startDisplayImageView:(UIImageView *) displayImageView;
-(void) startDisplayImageView:(UIImageView *) displayImageView andFilterImageView:(UIImageView *) filterImageView;
- (void)setHMin: (int)hMin andHMax: (int)hMax andSMin: (int)sMin andSMax: (int)sMax andVMin: (int)vMin andVMax: (int)vMax;
- (void)reset;


@end
