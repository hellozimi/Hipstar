//
//  RedOverlay.m
//  hipstar
//
//  Created by Simon Andersson on 11/10/12.
//  Copyright (c) 2012 hiddencode.me. All rights reserved.
//

#import "RedOverlay.h"
#import "FilterGenerator.h"

@implementation RedOverlay

- (UIImage *)apply:(UIImage *)image {
    
    GPUImagePicture *stillImageSource = [[GPUImagePicture alloc] initWithImage:image];
    
    GPUImageLevelsFilter *levels = [[GPUImageLevelsFilter alloc] init];
    [levels setMin:.145098039 gamma:1.0 max:.847058824];
    
    [stillImageSource addTarget:levels];
    [stillImageSource processImage];
    
    image = [levels imageFromCurrentlyProcessedOutput];
    
    GPUImageSaturationFilter *saturation = [[GPUImageSaturationFilter alloc] init];
    saturation.saturation = 0.77;
    
    image = [saturation imageByFilteringImage:image];
    
    
    GPUImageContrastFilter *contrast = [[GPUImageContrastFilter alloc] init];
    contrast.contrast = 0.78;
    
    image = [contrast imageByFilteringImage:image];
    
    GPUImageBrightnessFilter *brightness = [[GPUImageBrightnessFilter alloc] init];
    brightness.brightness = 0.32;
    
    image = [brightness imageByFilteringImage:image];
    
    GPUImageToneCurveFilter *curves = [[GPUImageToneCurveFilter alloc] init];
    [curves setBlueControlPoints:@[
     [NSValue valueWithCGPoint:CGPointMake(0, .17254902)],
     [NSValue valueWithCGPoint:CGPointMake(1, .874509804)],
     ]];
    [curves setGreenControlPoints:@[
     [NSValue valueWithCGPoint:CGPointMake(0, 0)],
     [NSValue valueWithCGPoint:CGPointMake(.329411765, .22745098)],
     [NSValue valueWithCGPoint:CGPointMake(.694117647, .756862745)],
     [NSValue valueWithCGPoint:CGPointMake(1, 1)],
     ]];
    [curves setRedControlPoints:@[
     [NSValue valueWithCGPoint:CGPointMake(0, 0)],
     [NSValue valueWithCGPoint:CGPointMake(.266666667, .223529412)],
     [NSValue valueWithCGPoint:CGPointMake(.639215686, .733333333)],
     [NSValue valueWithCGPoint:CGPointMake(1, 1)],
     ]];
    
    
    image = [curves imageByFilteringImage:image];
    return image;
}

@end
