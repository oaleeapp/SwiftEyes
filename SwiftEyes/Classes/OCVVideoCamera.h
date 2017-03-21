//
//  OCVVideoCamera.h
//  Pods
//
//  Created by lee on 01/03/2017.
//
//

#import "OCVAbstractCamera.h"
#import "OCVMat.h"

@protocol OCVVideoCameraDelegate <NSObject>

// delegate method for processing image frames
- (void)processImage:(OCVMat *)image;

@end

@interface OCVVideoCamera : OCVAbstractCamera

@property (nonatomic, weak) id<OCVVideoCameraDelegate> delegate;
@property (nonatomic, assign) BOOL grayscaleMode;

@property (nonatomic, assign) BOOL recordVideo;
@property (nonatomic, assign) BOOL rotateVideo;
@property (nonatomic, strong) AVAssetWriterInput* recordAssetWriterInput;
@property (nonatomic, strong) AVAssetWriterInputPixelBufferAdaptor* recordPixelBufferAdaptor;
@property (nonatomic, strong) AVAssetWriter* recordAssetWriter;

- (void)adjustLayoutToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation;
- (void)layoutPreviewLayer;
- (void)saveVideo;
- (NSURL *)videoFileURL;
- (NSString *)videoFileString;

@end
