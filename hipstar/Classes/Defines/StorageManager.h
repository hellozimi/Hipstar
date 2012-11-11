//
//  StorageManager.h
//  hipstar
//
//  Created by Simon Andersson on 11/11/12.
//  Copyright (c) 2012 hiddencode.me. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Photo;

@interface StorageManager : NSObject

+ (StorageManager *)instance;

- (NSString *)storeData:(NSData *)data extension:(NSString *)ext;
- (NSString*)absoluteFilePath:(NSString*)relativeFilePath;
+ (BOOL)addSkipBackupAttributeToRelativeFilePath:(NSString*)relativePath;

- (NSMutableArray *)gallery;
- (void)savePhotoToGallery:(Photo *)photo;
- (void)deletePhoto:(Photo *)photo;

@end
