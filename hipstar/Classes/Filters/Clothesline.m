//
//  Clothesline.m
//  hipstar
//
//  Created by Simon Andersson on 11/16/12.
//  Copyright (c) 2012 hiddencode.me. All rights reserved.
//

#import "Clothesline.h"

@implementation Clothesline

- (UIImage *)apply:(UIImage *)image {
    return [self applyLookup:@"clothesline_lookup_filter_1" image:image];
}

- (NSString *)name {
    return @"Clothesline";
}

- (UIImage *)image {
    return [UIImage imageNamed:@"Clothesline"];
}

@end
