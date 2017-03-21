//
//  OCVOperation.h
//  LegoCV
//
//  Created by Dal Rupnik on 23/01/2017.
//  Copyright © 2017 Unified Sense. All rights reserved.
//

#import "OCVObject.h"
#import "OCVInputArrayable.h"
#import "OCVOutputArrayable.h"
#import "OCVInputOutputArrayable.h"

#import "OCVGeometry.h"

#import "OCVColorConversionType.h"
#import "OCVInterpolationType.h"


// blur

typedef NS_ENUM(NSInteger, OCVBorderType) {
    OCVBorderConstant       = 0,
    OCVBorderReplicate      = 1,
    OCVBorderReflect        = 2,
    OCVBorderWrap           = 3,
    OCVBorderReflect_101    = 4,
    OCVBorderTransparent    = 5,

    OCVBorderReflect101     = OCVBorderReflect_101,
    OCVBorderDefault        = OCVBorderReflect_101,
    OCVBorderIsolated       = 16
    
};

// threshold

typedef NS_ENUM(NSInteger, OCVThresholdType) {
    OCVThresholdBinary     = 0,
    OCVThresholdBinaryInv         = 1,
    OCVThresholdTrunC        = 2,
    OCVThresholdToZero         = 3,
    OCVThresholdToZeroInv    = 4,
    OCVThresholdMask = 7,
    OCVThresholdOTsu = 8,
    OCVThresholdTriangle = 16
};


// find Contours
typedef NS_ENUM(NSInteger, OCVContourRetrievalMode) {
    OCVContourRetrievalExternal     = 0,
    OCVContourRetrievalList         = 1,
    OCVContourRetrievalCcomp        = 2,
    OCVContourRetrievalTree         = 3,
    OCVContourRetrievalFloodFill    = 4
};

typedef NS_ENUM(NSInteger, OCVContourApproximationMethod) {
    OCVContourChainApproximationCode        = 0,
    OCVContourChainApproximationNone        = 1,
    OCVContourChainApproximationSimple      = 2,
    OCVContourChainApproximationTC89L1      = 3,
    OCVContourChainApproximationTC89KCOS    = 4,
    OCVContourChainApproximationLinkRuns    = 5
};

@interface OCVOperation : OCVObject

//+ (id<OCVOutputArrayable>)convertColorFromSource:(id<OCVInputArrayable>)source withType:(OCVColorConversionType)type withDestinationCn:(NSInteger)destinationCn;

+ (void)convertColorFromSource:(id<OCVInputArrayable>)source toDestination:(id<OCVOutputArrayable>)destination withType:(OCVColorConversionType)type;
+ (void)convertColorFromSource:(id<OCVInputArrayable>)source toDestination:(id<OCVOutputArrayable>)destination withType:(OCVColorConversionType)type withDestinationCn:(NSInteger)destinationCn;

+ (void)resizeFromSource:(id<OCVInputArrayable>)source toDestination:(id<OCVOutputArrayable>)destination size:(OCVSize)size fx:(double)fx fy:(double)fy interpolation:(OCVInterpolationType)interpolation;

+ (void)equalizeHistogramFromSource:(id<OCVInputArrayable>)source toDestination:(id<OCVOutputArrayable>)destination;

#pragma mark - Drawing

+ (void)rectangleOnSource:(id<OCVInputOutputArrayable>)source fromPoint:(OCVPoint)point1 toPoint:(OCVPoint)point2 withColor:(OCVScalar)color thickness:(NSInteger)thickness lineType:(NSInteger)lineType shift:(NSInteger)shift;

+ (void)rectangleOnSource:(id<OCVInputOutputArrayable>)source fromRect:(OCVRect)rect withColor:(OCVScalar)color thickness:(NSInteger)thickness lineType:(NSInteger)lineType shift:(NSInteger)shift;

#pragma mark - Core

+ (void)absoluteDifferenceOnFirstSource:(id<OCVInputArrayable>)firstSource andSecondSource:(id<OCVInputArrayable>)secondSource toDestination:(id<OCVOutputArrayable>)destination;

#pragma mark - Image Processing

+ (void)blurOnSource:(id<OCVInputArrayable>)source toDestination:(id<OCVOutputArrayable>)destination withSize:(OCVSize)size;

+ (void)thresholdOnSource:(id<OCVInputArrayable>)source toDestination:(id<OCVOutputArrayable>)destination withThresh:(double)thresh withMaxValue:(double)maxval withType:(OCVThresholdType)type;

+ (void)findContoursOnSource:(id<OCVInputOutputArrayable>)source toContours:(id<OCVOutputArrayable>)contours withHierarchy:(id<OCVOutputArrayable>)hierarchy withMode:(OCVContourRetrievalMode)mode withMethod:(OCVContourApproximationMethod)method;



@end
