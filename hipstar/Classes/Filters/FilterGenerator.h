//
//  FilterGenerator.h
//  hipstar
//
//  Created by Simon Andersson on 11/9/12.
//  Copyright (c) 2012 hiddencode.me. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FilterGenerator : NSObject

CGContextRef BitmapContextCreateCopy(CGContextRef bitmapContext);
CGContextRef BitmapContextCreateWithImage(UIImage *image, CGSize size);
CGContextRef BitmapContextCreateWithSize(CGSize size);

void BitmapContextRelease(CGContextRef context);
void BitmapContextComposite(CGContextRef baseContext, CGContextRef overlayContext, float alpha, CGBlendMode blendMode);
void BitmapContextCompositeImageNamed(CGContextRef context, NSString *imageName, float alpha, CGBlendMode blendMode);
void BitmapContextCompositeWithCGImage(CGContextRef context, CGImageRef overlayImage, float alpha, CGBlendMode blendMode);
UIImage *BitmapImageCreateFromContext(CGContextRef context);
@end
