//
//  OCVVideoCamera.m
//  Pods
//
//  Created by lee on 01/03/2017.
//
//

#import "OCVVideoCamera.h"
#import "OCVAbstractCamera+Private.h"
#import "OCVMat.h"
#import "OCVMatDataAllocator+Private.h"
#import <opencv2/videoio/cap_ios.h>

@interface OCVVideoCamera() <CvVideoCameraDelegate>

@property (nonatomic, readonly) CvVideoCamera *cameraSource;

@end

@implementation OCVVideoCamera

- (CvVideoCamera *)cameraSource {

    return (CvVideoCamera *)self.source;
}

// Getter and Setter
//@property (nonatomic, weak) id<OCVVideoCameraDelegate> delegate;
- (void)setDelegate:(id<OCVVideoCameraDelegate>)delegate{

    _delegate = delegate;
    self.cameraSource.delegate = self;
    
}

//@property (nonatomic, assign) BOOL grayscaleMode;
- (BOOL)grayscaleMode{
    return self.cameraSource.grayscaleMode;
}

- (void)setGrayscaleMode:(BOOL)grayscaleMode{
    self.cameraSource.grayscaleMode = grayscaleMode;
}

//@property (nonatomic, assign) BOOL recordVideo;
- (BOOL)recordVideo{
    return self.cameraSource.recordVideo;
}

- (void)setRecordVideo:(BOOL)recordVideo{
    self.cameraSource.recordVideo = recordVideo;
}

//@property (nonatomic, assign) BOOL rotateVideo;
- (BOOL)rotateVideo{
    return self.cameraSource.rotateVideo;
}

- (void)setRotateVideo:(BOOL)rotateVideo{
    self.cameraSource.rotateVideo = rotateVideo;
}

//@property (nonatomic, strong) AVAssetWriterInput* recordAssetWriterInput;
- (AVAssetWriterInput *)recordAssetWriterInput{
    return self.cameraSource.recordAssetWriterInput;
}

- (void)setRecordAssetWriterInput:(AVAssetWriterInput *)recordAssetWriterInput{
    self.cameraSource.recordAssetWriterInput = recordAssetWriterInput;
}

//@property (nonatomic, strong) AVAssetWriterInputPixelBufferAdaptor* recordPixelBufferAdaptor;
- (AVAssetWriterInputPixelBufferAdaptor *)recordPixelBufferAdaptor{
    return self.cameraSource.recordPixelBufferAdaptor;
}

- (void)setRecordPixelBufferAdaptor:(AVAssetWriterInputPixelBufferAdaptor *)recordPixelBufferAdaptor{
    self.cameraSource.recordPixelBufferAdaptor = recordPixelBufferAdaptor;
}

//@property (nonatomic, strong) AVAssetWriter* recordAssetWriter;
- (AVAssetWriter *)recordAssetWriter{
    return self.cameraSource.recordAssetWriter;
}

- (void)setRecordAssetWriter:(AVAssetWriter *)recordAssetWriter{
    self.cameraSource.recordAssetWriter = recordAssetWriter;
}


// Init
- (instancetype)initWithParentView:(UIView *)parent {
    self = [super initWithObject:[[CvVideoCamera alloc] initWithParentView:parent]];

    return self;
}


// Method
- (void)adjustLayoutToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    [self.cameraSource adjustLayoutToInterfaceOrientation:interfaceOrientation];
}

- (void)layoutPreviewLayer{
    [self.cameraSource layoutPreviewLayer];
}

- (void)saveVideo{
    [self.cameraSource saveVideo];
}
- (NSURL *)videoFileURL{
    return [self.cameraSource videoFileURL];
}

- (NSString *)videoFileString{
    return [self.cameraSource videoFileString];
}

- (void)processImage:(cv::Mat &)image{
    OCVMat * matImage = [[OCVMat alloc] initWithMatInstance:&image];
     [self.delegate processImage:matImage];
}

@end
