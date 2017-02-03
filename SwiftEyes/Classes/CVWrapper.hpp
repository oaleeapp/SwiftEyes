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


@end
