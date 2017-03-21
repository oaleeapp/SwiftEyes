//
//  OCVAbstractCamera.m
//  Pods
//
//  Created by lee on 01/03/2017.
//
//

#import "OCVAbstractCamera.h"
#import "OCVAbstractCamera+Private.h"
#import <opencv2/videoio/cap_ios.h>


@implementation OCVAbstractCamera

- (CvAbstractCamera *)source{
    return (CvAbstractCamera *)self.object;
}


//@property (nonatomic, strong) AVCaptureSession* captureSession;
- (AVCaptureSession *)captureSession{
    return self.source.captureSession;
}

- (void)setCaptureSession:(AVCaptureSession *)captureSession{
    self.source.captureSession = captureSession;
}

//@property (nonatomic, strong) AVCaptureConnection* videoCaptureConnection;
- (AVCaptureConnection *)videoCaptureConnection{
    return self.source.videoCaptureConnection;
}

- (void)setVideoCaptureConnection:(AVCaptureConnection *)videoCaptureConnection{
    self.source.videoCaptureConnection = videoCaptureConnection;
}

//@property (nonatomic, readonly) BOOL running;
- (BOOL)running{
    return self.source.running;
}

//@property (nonatomic, readonly) BOOL captureSessionLoaded;
- (BOOL)captureSessionLoaded{
    return self.source.captureSessionLoaded;
}

//@property (nonatomic, assign) int defaultFPS;
- (int)defaultFPS{
    return self.source.defaultFPS;
}

- (void)setDefaultFPS:(int)defaultFPS{
    self.source.defaultFPS = defaultFPS;
}

//@property (nonatomic, readonly) AVCaptureVideoPreviewLayer *captureVideoPreviewLayer;
- (AVCaptureVideoPreviewLayer *)captureVideoPreviewLayer{
    return self.source.captureVideoPreviewLayer;
}

//@property (nonatomic, assign) AVCaptureDevicePosition defaultAVCaptureDevicePosition;
- (AVCaptureDevicePosition)defaultAVCaptureDevicePosition{
    return self.source.defaultAVCaptureDevicePosition;
}

- (void)setDefaultAVCaptureDevicePosition:(AVCaptureDevicePosition)defaultAVCaptureDevicePosition{
    self.source.defaultAVCaptureDevicePosition = defaultAVCaptureDevicePosition;
}

//@property (nonatomic, assign) AVCaptureVideoOrientation defaultAVCaptureVideoOrientation;
- (AVCaptureVideoOrientation)defaultAVCaptureVideoOrientation{
    return self.source.defaultAVCaptureVideoOrientation;
}

- (void)setDefaultAVCaptureVideoOrientation:(AVCaptureVideoOrientation)defaultAVCaptureVideoOrientation{
    self.source.defaultAVCaptureVideoOrientation = defaultAVCaptureVideoOrientation;
}

//@property (nonatomic, assign) BOOL useAVCaptureVideoPreviewLayer;
- (BOOL)useAVCaptureVideoPreviewLayer{
    return self.source.useAVCaptureVideoPreviewLayer;
}

- (void)setUseAVCaptureVideoPreviewLayer:(BOOL)useAVCaptureVideoPreviewLayer{
    self.source.useAVCaptureVideoPreviewLayer = useAVCaptureVideoPreviewLayer;
}

//@property (nonatomic, strong) NSString *const defaultAVCaptureSessionPreset;
- (NSString *)defaultAVCaptureSessionPreset{
    return self.source.defaultAVCaptureSessionPreset;
}

- (void)setDefaultAVCaptureSessionPreset:(NSString *)defaultAVCaptureSessionPreset{
    self.source.defaultAVCaptureSessionPreset = defaultAVCaptureSessionPreset;
}


//@property (nonatomic, assign) int imageWidth;
- (int)imageWidth{
    return self.source.imageWidth;
}

- (void)setImageWidth:(int)imageWidth{
    self.source.imageWidth = imageWidth;
}

//@property (nonatomic, assign) int imageHeight;
- (int)imageHeight{
    return self.source.imageHeight;
}

- (void)setimageHeight:(int)imageHeight{
    self.source.imageHeight = imageHeight;
}


//@property (nonatomic, strong) UIView* parentView;
- (UIView *)parentView{
    return self.source.parentView;
}

- (void)setParentView:(UIView *)parentView{
    self.source.parentView = parentView;
}


// Methods

- (void)start{
    [self.source start];
}

- (void)stop{
    [self.source stop];
}

- (void)switchCameras{
    [self.source switchCameras];
}

- (instancetype)initWithParentView:(UIView*)parent{
    [NSException raise:@"InitNotImplemented" format:@"This method is abstract and is not implemented."];

    return nil;
}

- (void)createCaptureOutput{
    [self.source createCaptureOutput];
}

- (void)createVideoPreviewLayer{
    [self.source createVideoPreviewLayer];
}

- (void)updateOrientation{
    [self.source updateOrientation];
}

- (void)lockFocus{
    [self.source lockFocus];
}
- (void)unlockFocus{
    [self.source unlockFocus];
}
- (void)lockExposure{
    [self.source lockExposure];
}
- (void)unlockExposure{
    [self.source unlockExposure];
}
- (void)lockBalance{
    [self.source lockBalance];
}
- (void)unlockBalance{
    [self.source unlockBalance];
}


@end
