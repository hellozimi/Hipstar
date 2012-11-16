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

- (UIImage *)applyLookup:(NSString *)lookupName image:(UIImage *)image {
    
    UIImage *topImage = [UIImage imageNamed:lookupName];
    GPUImagePicture *bottom = [[GPUImagePicture alloc] initWithImage:image];
    GPUImagePicture *top = [[GPUImagePicture alloc] initWithImage:topImage];
    
    GPUImageLookupFilter *lookup = [[GPUImageLookupFilter alloc] init];
    [bottom addTarget:lookup];
    [top addTarget:lookup];
    
    [bottom processImage];
    [top processImage];
    
    return [lookup imageFromCurrentlyProcessedOutput];
}

- (UIImage *)imageName:(NSString *)imageName alpha:(float)alpha {
    
    GPUImagePicture *image = [[GPUImagePicture alloc] initWithImage:[UIImage imageNamed:imageName] smoothlyScaleOutput:YES];
    
    GPUImageOpacityFilter *opacity = [[GPUImageOpacityFilter alloc] init];
    opacity.opacity = alpha;
    
    [image addTarget:opacity];
    [image processImage];
    
    return [opacity imageFromCurrentlyProcessedOutput];
}

- (UIImage *)imageWithAlphaBlendingBottom:(UIImage *)bottomImage top:(UIImage *)topImage alpha:(float)alpha {
    GPUImagePicture *bottom = [[GPUImagePicture alloc] initWithImage:bottomImage];
    GPUImagePicture *top = [[GPUImagePicture alloc] initWithImage:topImage];
    
    GPUImageAlphaBlendFilter *alphaBlend = [[GPUImageAlphaBlendFilter alloc] init];
    alphaBlend.mix = alpha;
    
    [bottom addTarget:alphaBlend];
    [top addTarget:alphaBlend];
    
    [bottom processImage];
    [top processImage];
    
    return [alphaBlend imageFromCurrentlyProcessedOutput];
}
- (UIImage *)imageWithOverlayBlendingBottom:(UIImage *)bottomImage top:(UIImage *)topImage {
    GPUImagePicture *bottom = [[GPUImagePicture alloc] initWithImage:bottomImage];
    GPUImagePicture *top = [[GPUImagePicture alloc] initWithImage:topImage];
    
    GPUImageOverlayBlendFilter *overlay = [[GPUImageOverlayBlendFilter alloc] init];
    
    [bottom addTarget:overlay];
    [top addTarget:overlay];
    
    [bottom processImage];
    [top processImage];
    
    return [overlay imageFromCurrentlyProcessedOutput];
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

