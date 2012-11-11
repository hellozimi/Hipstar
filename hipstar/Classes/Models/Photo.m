//
//  Photo.m
//  hipstar
//
//  Created by Simon Andersson on 11/11/12.
//  Copyright (c) 2012 hiddencode.me. All rights reserved.
//

#import "Photo.h"

@implementation Photo

+ (id)photo {
    return [[self alloc] init];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super init])) {
        self.filterName = [aDecoder decodeObjectForKey:@"filterName"];
        self.effectName = [aDecoder decodeObjectForKey:@"effectName"];
        self.thumbnailPath = [aDecoder decodeObjectForKey:@"thumbnailPath"];
        self.largePath = [aDecoder decodeObjectForKey:@"largePath"];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.filterName forKey:@"filterName"];
    [aCoder encodeObject:self.effectName forKey:@"effectName"];
    [aCoder encodeObject:self.thumbnailPath forKey:@"thumbnailPath"];
    [aCoder encodeObject:self.largePath forKey:@"largePath"];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"[{ Filter: %@, Effect: %@ }, { Thumbnail: %@, Large: %@ }]", self.filterName, self.effectName, self.thumbnailPath, self.largePath];
}

@end
