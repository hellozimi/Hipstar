//
//  Sepia.m
//  hipstar
//
//  Created by Simon Andersson on 11/11/12.
//  Copyright (c) 2012 hiddencode.me. All rights reserved.
//

#import "Sepia.h"

@implementation Sepia

- (UIImage *)apply:(UIImage *)image {
    GPUImageSepiaFilter *sepia = [[GPUImageSepiaFilter alloc] init];
    sepia.intensity = 0.8;
    return [sepia imageByFilteringImage:image];
}

- (NSString *)name {
    return @"Bronson";
}

- (UIImage *)image {
    return [UIImage imageNamed:@"Bronson"];
}

@end
