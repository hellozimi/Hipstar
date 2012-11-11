//
//  Midtown.m
//  hipstar
//
//  Created by Simon Andersson on 11/11/12.
//  Copyright (c) 2012 hiddencode.me. All rights reserved.
//

#import "Midtown.h"

@implementation Midtown

- (UIImage *)apply:(UIImage *)image {
    
    
    // Contrast 27
    GPUImageContrastFilter *contrast = [[GPUImageContrastFilter alloc] init];
    contrast.contrast = 1.27;
    
    image = [contrast imageByFilteringImage:image];
    
    // Brightness 3
    GPUImageBrightnessFilter *brightness = [[GPUImageBrightnessFilter alloc] init];
    brightness.brightness = .02;
    
    image = [brightness imageByFilteringImage:image];
    
    
    // Saturation +10
    GPUImageSaturationFilter *saturation = [[GPUImageSaturationFilter alloc] init];
    saturation.saturation = 1.1;
    
    image = [saturation imageByFilteringImage:image];
    
    
    // Levels
    GPUImageLevelsFilter *levels = [[GPUImageLevelsFilter alloc] init];
    [levels setBlueMin:.02745098 gamma:1.0 max:.956862745 minOut:0 maxOut:1];
    
    image = [levels imageByFilteringImage:image];
    
    GPUImageColorBalanceFilter *colorBalance = [[GPUImageColorBalanceFilter alloc] init];
    GPUVector3 midtones;
    midtones.one = 0.04;
    midtones.two = 0;
    midtones.three = -0.04;
    [colorBalance setMidtones:midtones];
    
    image = [colorBalance imageByFilteringImage:image];
    
    
    GPUImageOverlayBlendFilter *overlay = [[GPUImageOverlayBlendFilter alloc] init];
    GPUImagePicture *base = [[GPUImagePicture alloc] initWithImage:image smoothlyScaleOutput:NO];
    
    GPUImagePicture *gradient = [[GPUImagePicture alloc] initWithImage:[UIImage imageNamed:@"midtown_overlay.jpg"] smoothlyScaleOutput:YES];

    [base addTarget:overlay];
    [gradient addTarget:overlay];
    
    [base processImage];
    [gradient processImage];
    
    UIImage *gradientBlended = [overlay imageFromCurrentlyProcessedOutput];
    
    GPUImageOpacityFilter *opacity = [[GPUImageOpacityFilter alloc] init];
    opacity.opacity = 0.5;
    
    gradientBlended = [opacity imageByFilteringImage:gradientBlended];
    
    
    GPUImageAlphaBlendFilter *alpha = [[GPUImageAlphaBlendFilter alloc] init];
    alpha.mix = 1.0;
    
    GPUImagePicture *bottom = [[GPUImagePicture alloc] initWithImage:image];
    GPUImagePicture *top = [[GPUImagePicture alloc] initWithImage:gradientBlended];
    
    [bottom addTarget:alpha];
    [top addTarget:alpha];
    
    [bottom processImage];
    [top processImage];
    
    image = [alpha imageFromCurrentlyProcessedOutput];
    
    
    //image = [overlay imageFromCurrentlyProcessedOutput];
    
    return image;
}

- (NSString *)name {
    return @"Midtown";
}


- (UIImage *)image {
    return [UIImage imageNamed:@"Midtown"];
}

@end
