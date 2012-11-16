//
//  Tassel.m
//  hipstar
//
//  Created by Simon Andersson on 11/16/12.
//  Copyright (c) 2012 hiddencode.me. All rights reserved.
//

#import "Tassel.h"

@implementation Tassel

- (UIImage *)apply:(UIImage *)image {
    return [self applyLookup:@"tassel_lookup_filter_1" image:image];
}

- (NSString *)name {
    return @"Tassel";
}

- (UIImage *)image {
    return [UIImage imageNamed:@"Tassel"];
}

@end
