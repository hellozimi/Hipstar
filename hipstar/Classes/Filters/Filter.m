//
//  Filter.m
//  hipstar
//
//  Created by Simon Andersson on 11/10/12.
//  Copyright (c) 2012 hiddencode.me. All rights reserved.
//

#import "Filter.h"
#import "NoFX.h"

@implementation Filter

+ (id)filter {
    return [[self alloc] init];
}

+ (NSString *)nameForFilter:(Filter *)filter effect:(Filter *)effect {
    
    NSString *name = nil;
    if ([filter isKindOfClass:[NoFX class]] && [effect isKindOfClass:[NoFX class]]) {
        name = @"None";
    }
    else {
        if (![filter isKindOfClass:[NoFX class]] && ![effect isKindOfClass:[NoFX class]]) {
            name = [NSString stringWithFormat:@"%@ ♥ %@", effect.name, filter.name];
        }
        else {
            if ([filter isKindOfClass:[NoFX class]]) {
                name = effect.name;
            }
            else {
                name = filter.name;
            }
        }
    }
    return name;
}

- (UIImage *)apply:(UIImage *)image {
    return image;
}

- (UIImage *)imageByApplyingAlpha:(UIImage *)image alpha:(CGFloat) alpha {
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0.0f);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect area = CGRectMake(0, 0, image.size.width, image.size.height);
    
    CGContextScaleCTM(ctx, 1, -1);
    CGContextTranslateCTM(ctx, 0, -area.size.height);
    
    CGContextSetBlendMode(ctx, kCGBlendModeMultiply);
    
    CGContextSetAlpha(ctx, alpha);
    
    CGContextDrawImage(ctx, area, image.CGImage);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}


#pragma mark - Coding
- (id)initWithCoder:(NSCoder *)aDecoder {
    return [super init];
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    
}

@end

