//
//  UIView_DrawRect.m
//
//  Created by Simon Andersson on 2/15/12.
//  Copyright (c) 2012 Hiddencode.me. All rights reserved.
//

#import "UIView_DrawRect.h"

@implementation HCView

- (void)setDrawRectBlock:(DrawRectBlock)b {
    block = [b copy];
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    if (block) {
        block(rect);
    }
}

@end

@implementation UIView (DrawRect)

+ (__weak UIView *)viewWithFrame:(CGRect)frame drawRect:(DrawRectBlock)block {
    HCView *view = [[HCView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor clearColor];
    [view setDrawRectBlock:block];
    return view;
}

@end