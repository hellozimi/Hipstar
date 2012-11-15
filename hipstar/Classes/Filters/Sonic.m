//
//  Sonic.m
//  hipstar
//
//  Created by Simon Andersson on 11/11/12.
//  Copyright (c) 2012 hiddencode.me. All rights reserved.
//

#import "Sonic.h"

@implementation Sonic

- (UIImage *)apply:(UIImage *)image {
    
    GPUImageAlphaBlendFilter *alpha = [[GPUImageAlphaBlendFilter alloc] init];
    alpha.mix = 0.6;
    UIImage *sonicOverlay = [UIImage imageNamed:@"sonic_overlay"];
    
    GPUImagePicture *bottom = [[GPUImagePicture alloc] initWithImage:image];
    GPUImagePicture *top = [[GPUImagePicture alloc] initWithImage:sonicOverlay smoothlyScaleOutput:YES];
    
    [bottom addTarget:alpha];
    [top addTarget:alpha];
    
    [bottom processImage];
    [top processImage];
    
    image = [alpha imageFromCurrentlyProcessedOutput];
    
    return image;
}

- (NSString *)name {
    return @"Sonic";
}

- (UIImage *)image {
    return [UIImage imageNamed:@"Sonic"];
}

@end
