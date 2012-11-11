//
//  Kale.m
//  hipstar
//
//  Created by Simon Andersson on 11/11/12.
//  Copyright (c) 2012 hiddencode.me. All rights reserved.
//

#import "Kale.h"

@implementation Kale

- (UIImage *)apply:(UIImage *)image {
    GPUImageGrayscaleFilter *grayscale = [[GPUImageGrayscaleFilter alloc] init];
    return [grayscale imageByFilteringImage:image];
}

- (NSString *)name {
    return @"Kale";
}


- (UIImage *)image {
    return [UIImage imageNamed:@"Kale"];
}
@end
