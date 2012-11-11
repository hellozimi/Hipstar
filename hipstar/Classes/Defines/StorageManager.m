//
//  StorageManager.m
//  hipstar
//
//  Created by Simon Andersson on 11/11/12.
//  Copyright (c) 2012 hiddencode.me. All rights reserved.
//

#import "StorageManager.h"
#import "Photo.h"
#include <sys/xattr.h>

@interface StorageManager () {
    NSFileManager *_fileManager;
    NSMutableArray *_gallery;
}

- (NSString *)basePath;

@end

@implementation StorageManager

+ (StorageManager *)instance {
    static StorageManager *STORE_MANAGER_INSTANCE = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        STORE_MANAGER_INSTANCE = [[StorageManager alloc] init];
    });
    return STORE_MANAGER_INSTANCE;
}

- (NSString *)basePath {
    return [[[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject] URLByAppendingPathComponent:@"HipStar"] path];
}

- (id)init {
    self = [super init];
    if (self) {
        _fileManager = [NSFileManager defaultManager];
        BOOL isDir;
        if (![_fileManager fileExistsAtPath:[self basePath] isDirectory:&isDir]) {
            [_fileManager createDirectoryAtPath:[self basePath] withIntermediateDirectories:YES attributes:nil error:nil];
        }
        
        if ([_fileManager fileExistsAtPath:[self absoluteFilePath:@"gallery.array"]]) {
            NSData *arrayData = [NSData dataWithContentsOfFile:[self absoluteFilePath:@"/gallery.array"]];
            _gallery = [NSKeyedUnarchiver unarchiveObjectWithData:arrayData];
        }
        else {
            _gallery = [[NSMutableArray alloc] init];
        }
        
    }
    return self;
}

- (NSString *)generateRelativeFilePathWithExtension:(NSString *)extension {
    
    NSString *filepath = nil;
    
    do {
        NSString *tryPath = [NSString stringWithFormat:@"/%u_%u.%@",(u_int32_t)[NSDate timeIntervalSinceReferenceDate], (u_int32_t)arc4random(), extension];
        
        NSString *absolutePath = [self absoluteFilePath:tryPath];
        
        if (![_fileManager fileExistsAtPath:absolutePath]) {
            filepath = tryPath;
        }
        
    } while (!filepath);
    
    return filepath;
}

- (NSString *)storeData:(NSData *)data extension:(NSString *)ext {
    NSString *filepath = [self generateRelativeFilePathWithExtension:ext];
    NSString *absolutePath = [self absoluteFilePath:filepath];
    
    if ([_fileManager fileExistsAtPath:absolutePath]) {
        [_fileManager removeItemAtPath:absolutePath error:nil];
    }
    
    [_fileManager createFileAtPath:absolutePath contents:data attributes:nil];
    [StorageManager addSkipBackupAttributeToRelativeFilePath:filepath];
    
    return filepath;
}

- (NSString*)absoluteFilePath:(NSString*)relativeFilePath {
    return [[self basePath] stringByAppendingPathComponent:relativeFilePath];
}

+ (BOOL)addSkipBackupAttributeToRelativeFilePath:(NSString*)relativePath {
    NSURL *URL = [NSURL fileURLWithPath:relativePath];
    const char* filePath = [[URL path] fileSystemRepresentation];
    
    const char* attrName = "com.apple.MobileBackup";
    u_int8_t attrValue = 1;
    
    int result = setxattr(filePath, attrName, &attrValue, sizeof(attrValue), 0, 0);
    return result == 0;
}

#pragma mark - Gallery


- (NSMutableArray *)gallery {
    return [NSMutableArray arrayWithArray:_gallery];
}

- (void)savePhotoToGallery:(Photo *)photo {
    [_gallery insertObject:photo atIndex:0];
    
    NSData *arrayData = [NSKeyedArchiver archivedDataWithRootObject:_gallery];
    
    NSString *absolutePath = [self absoluteFilePath:@"/gallery.array"];
    
    if ([_fileManager fileExistsAtPath:absolutePath]) {
        [_fileManager removeItemAtPath:absolutePath error:nil];
    }
    
    [_fileManager createFileAtPath:absolutePath contents:arrayData attributes:nil];
    [StorageManager addSkipBackupAttributeToRelativeFilePath:@"/gallery.array"];
}

- (void)deletePhoto:(Photo *)photo {
    [_gallery removeObject:photo];
    
    NSData *arrayData = [NSKeyedArchiver archivedDataWithRootObject:_gallery];
    
    NSString *absolutePath = [self absoluteFilePath:@"/gallery.array"];
    
    if ([_fileManager fileExistsAtPath:absolutePath]) {
        [_fileManager removeItemAtPath:absolutePath error:nil];
    }
    
    if ([_fileManager fileExistsAtPath:[self absoluteFilePath:photo.thumbnailPath]]) {
        [_fileManager removeItemAtPath:[self absoluteFilePath:photo.thumbnailPath] error:nil];
    }
    
    if ([_fileManager fileExistsAtPath:[self absoluteFilePath:photo.largePath]]) {
        [_fileManager removeItemAtPath:[self absoluteFilePath:photo.largePath] error:nil];
    }
    
    [_fileManager createFileAtPath:absolutePath contents:arrayData attributes:nil];
    
    [StorageManager addSkipBackupAttributeToRelativeFilePath:@"/gallery.array"];
}

@end
