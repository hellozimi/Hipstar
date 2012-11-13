//
//  Photo.m
//  hipstar
//
//  Created by Simon Andersson on 11/11/12.
//  Copyright (c) 2012 hiddencode.me. All rights reserved.
//

#import "Photo.h"
#import "Filter.h"

@implementation Photo

+ (id)photo {
    return [[self alloc] init];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super init])) {
        self.filter = [aDecoder decodeObjectForKey:@"filter"];
        self.effect = [aDecoder decodeObjectForKey:@"effect"];
        self.thumbnailPath = [aDecoder decodeObjectForKey:@"thumbnailPath"];
        self.largePath = [aDecoder decodeObjectForKey:@"largePath"];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.filter forKey:@"filter"];
    [aCoder encodeObject:self.effect forKey:@"effect"];
    [aCoder encodeObject:self.thumbnailPath forKey:@"thumbnailPath"];
    [aCoder encodeObject:self.largePath forKey:@"largePath"];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"[{ Filter: %@, Effect: %@ }, { Thumbnail: %@, Large: %@ }]", self.filter.name, self.effect.name, self.thumbnailPath, self.largePath];
}

@end
