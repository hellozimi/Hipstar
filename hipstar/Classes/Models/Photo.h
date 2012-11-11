//
//  Photo.h
//  hipstar
//
//  Created by Simon Andersson on 11/11/12.
//  Copyright (c) 2012 hiddencode.me. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Photo : NSObject <NSCoding>

+ (id)photo;

@property (nonatomic, strong) NSString *filterName;
@property (nonatomic, strong) NSString *effectName;

@property (nonatomic, strong) NSString *thumbnailPath;
@property (nonatomic, strong) NSString *largePath;

@end
