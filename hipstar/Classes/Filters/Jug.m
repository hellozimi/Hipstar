//
//  Jug.m
//  hipstar
//
//  Created by Simon Andersson on 11/15/12.
//  Copyright (c) 2012 hiddencode.me. All rights reserved.
//

#import "Jug.h"

@implementation Jug

- (UIImage *)apply:(UIImage *)image {
    
    UIImage *jug = [UIImage imageNamed:@"jug_filter"];
    
    GPUImagePicture *bottom = [[GPUImagePicture alloc] initWithImage:image];
    GPUImagePicture *top = [[GPUImagePicture alloc] initWithImage:jug];
    
    GPUImageMultiplyBlendFilter *muliply = [[GPUImageMultiplyBlendFilter alloc] init];
    [bottom addTarget:muliply];
    [top addTarget:muliply];
    
    [bottom processImage];
    [top processImage];
    
    return [muliply imageFromCurrentlyProcessedOutput];
}

- (NSString *)name {
    return @"Jug";
}

- (UIImage *)image {
    return [UIImage imageNamed:@"Jug"];
}

@end
