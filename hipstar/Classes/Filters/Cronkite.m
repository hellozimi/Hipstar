//
//  Cronkite.m
//  hipstar
//
//  Created by Simon Andersson on 11/16/12.
//  Copyright (c) 2012 hiddencode.me. All rights reserved.
//

#import "Cronkite.h"

@implementation Cronkite

- (UIImage *)apply:(UIImage *)image {
    return [self applyLookup:@"cronkite_lookup_filter_1" image:image];
}

- (NSString *)name {
    return @"Cronkite";
}

- (UIImage *)image {
    return [UIImage imageNamed:@"Cronkite"];
}

@end
