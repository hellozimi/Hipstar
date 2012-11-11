//
//  ShareViewController.m
//  hipstar
//
//  Created by Simon Andersson on 11/10/12.
//  Copyright (c) 2012 hiddencode.me. All rights reserved.
//

#import "ShareViewController.h"
#import <Social/Social.h>
#include <sys/xattr.h>

@interface ShareViewController () <UIDocumentInteractionControllerDelegate>

@property (strong, nonatomic) UIDocumentInteractionController *dic;
@property (weak, nonatomic) IBOutlet UIImageView *previewImageView;
@property (weak, nonatomic) IBOutlet UIButton *twitterButton;
@property (weak, nonatomic) IBOutlet UIButton *instagramButton;
@property (weak, nonatomic) IBOutlet UIButton *facebookButton;

@end

@implementation ShareViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    _previewImageView.image = self.previewImage;
    
    [self updateSharingOptions];
}

- (void)setFullImage:(UIImage *)fullImage {
    _fullImage = fullImage;
    
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *basePath = [[[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject] URLByAppendingPathComponent:@"HipStar"] path];
    
    BOOL isDir;
    if (![fm fileExistsAtPath:basePath isDirectory:&isDir]) {
        [fm createDirectoryAtPath:basePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSString *filename = @"send_to_instagram.igo";
    NSString *fullPath = [basePath stringByAppendingPathComponent:filename];
    
    if ([fm fileExistsAtPath:fullPath]) {
        [fm removeItemAtPath:fullPath error:nil];
    }
    
    NSData *jpegData = UIImageJPEGRepresentation(_fullImage, 0.85);
    
    [fm createFileAtPath:fullPath contents:jpegData attributes:nil];
    
    [self addSkipBackupAttributeToRelativeFilePath:fullPath];
    
}

- (void)updateSharingOptions {
    
    if (![SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
        _twitterButton.enabled = NO;
    }
    
    if (![SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        _facebookButton.enabled = NO;
    }
    
    NSURL *instagramURL = [NSURL URLWithString:@"instagram://app"];
    if (![[UIApplication sharedApplication] canOpenURL:instagramURL]) {
        _instagramButton.enabled = NO;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Sharing
- (IBAction)shareOnTwitter:(id)sender {
    SLComposeViewController *share = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    [share addImage:self.fullImage];
    [share setInitialText:@" #hipstarapp"];
    [share setCompletionHandler:^(SLComposeViewControllerResult result) {
        NSLog(@"STatus: %u", result);
    }];
    
    [self presentViewController:share animated:YES completion:nil];
}

- (IBAction)shareOnInstagram:(id)sender {
    
    NSString *basePath = [[[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject] URLByAppendingPathComponent:@"HipStar"] path];
    NSString *filename = @"send_to_instagram.igo";
    NSString *fullPath = [basePath stringByAppendingPathComponent:filename];
    
    NSURL *url = [NSURL fileURLWithPath:fullPath];
    
    self.dic = [UIDocumentInteractionController interactionControllerWithURL:url];
    self.dic.UTI = @"com.instagram.exclusivegram";
    
    [self.dic presentOpenInMenuFromRect:self.view.frame inView:self.view animated:YES];
}

- (IBAction)shareOnFacebook:(id)sender {
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        SLComposeViewController *share = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        [share addImage:self.fullImage];
        [share setCompletionHandler:^(SLComposeViewControllerResult result) {
            NSLog(@"STatus: %u", result);
        }];
        
        [self presentViewController:share animated:YES completion:nil];
    }
}

#pragma mark - UIDocumentInteractionControllerDelegate Implementation



#pragma mark - iCloud

- (BOOL)addSkipBackupAttributeToRelativeFilePath:(NSString*)relativePath {
    NSURL *URL = [NSURL fileURLWithPath:relativePath];
    const char* filePath = [[URL path] fileSystemRepresentation];
    
    const char* attrName = "com.apple.MobileBackup";
    u_int8_t attrValue = 1;
    
    int result = setxattr(filePath, attrName, &attrValue, sizeof(attrValue), 0, 0);
    return result == 0;
}

@end
