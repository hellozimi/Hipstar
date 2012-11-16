//
//  ShareViewController.m
//  hipstar
//
//  Created by Simon Andersson on 11/10/12.
//  Copyright (c) 2012 hiddencode.me. All rights reserved.
//

#import "ShareViewController.h"
#import "Photo.h"
#import "StorageManager.h"
#import "Filter.h"
#import <Social/Social.h>

@interface ShareViewController () <UIDocumentInteractionControllerDelegate, UIActionSheetDelegate>

@property (strong, nonatomic) UIDocumentInteractionController *dic;
@property (weak, nonatomic) IBOutlet UIImageView *previewImageView;
@property (weak, nonatomic) IBOutlet UIButton *twitterButton;
@property (weak, nonatomic) IBOutlet UIButton *instagramButton;
@property (weak, nonatomic) IBOutlet UIButton *facebookButton;
@property (weak, nonatomic) IBOutlet UILabel *twitterLabel;
@property (weak, nonatomic) IBOutlet UILabel *instagramLabel;
@property (weak, nonatomic) IBOutlet UILabel *facebookLabel;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;
@property (weak, nonatomic) IBOutlet UIView *indicator;
@property (weak, nonatomic) IBOutlet UILabel *filterLabel;

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
    _previewImageView.layer.masksToBounds = YES;
    _previewImageView.layer.cornerRadius = 4;
    
    self.view.backgroundColor = [UIColor colorWithHue:0.000 saturation:0.000 brightness:0.859 alpha:1];
    
    [self updateSharingOptions];
    
    _indicator.layer.cornerRadius = 4;
    
    if (self.photo) {
        _doneButton.hidden = YES;
    }
    else {
        self.navigationItem.rightBarButtonItem = nil;
    }
    
    self.navigationItem.leftBarButtonItem.customView.exclusiveTouch = YES;
    self.navigationItem.rightBarButtonItem.customView.exclusiveTouch = YES;
    
    self.twitterButton.exclusiveTouch = self.instagramButton.exclusiveTouch = self.facebookButton.exclusiveTouch = self.doneButton.exclusiveTouch = YES;
    
    
    NSString *string = [Filter nameForFilter:self.filter effect:self.effect];
    
    NSRange heartRange = [string rangeOfString:@"♥"];
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:string];
    [attrString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:.392156863 green:.392156863 blue:.392156863 alpha:1.0] range:NSMakeRange(0, string.length)];
    [attrString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue" size:22] range:NSMakeRange(0, string.length)];
    
    if (heartRange.length > 0) {
        [attrString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HiraKakuProN-W6" size:22] range:heartRange];
    }
    
    self.filterLabel.attributedText = attrString;
    self.filterLabel.textAlignment = 1;
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
    
    [StorageManager addSkipBackupAttributeToRelativeFilePath:fullPath];
    
}

- (void)updateSharingOptions {
    
    if (![SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
        _twitterButton.enabled = NO;
        _twitterLabel.alpha = .5;
    }
    
    if (![SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        _facebookButton.enabled = NO;
        _facebookLabel.alpha = .5;
    }
    
    NSURL *instagramURL = [NSURL URLWithString:@"instagram://app"];
    if (![[UIApplication sharedApplication] canOpenURL:instagramURL]) {
        _instagramButton.enabled = NO;
        _instagramLabel.alpha = .5;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)delete:(id)sender {
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Do you really want to delete this photo?" delegate:self cancelButtonTitle:@"No" destructiveButtonTitle:@"Yes" otherButtonTitles:nil];
    
    [actionSheet showInView:[UIApplication sharedApplication].keyWindow];
}

- (IBAction)close:(id)sender {
    if (self.photo) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - UIActionSheetDelegate Implementation

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [[StorageManager instance] deletePhoto:self.photo];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - Sharing
- (IBAction)shareOnTwitter:(id)sender {
    SLComposeViewController *share = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    [share addImage:self.fullImage];
    [share setInitialText:[NSString stringWithFormat:@" - %@ with #hipstarapp", [Filter nameForFilter:self.filter effect:self.effect]]];
    
    SLComposeViewControllerCompletionHandler completeHandler = ^(SLComposeViewControllerResult result) {
        [share dismissViewControllerAnimated:YES completion:nil];
        if (result == SLComposeViewControllerResultDone) {
            _twitterButton.enabled = NO;
            _twitterLabel.alpha = .5;
        }
    };
    
    [share setCompletionHandler:completeHandler];
    
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
        [share setInitialText:[NSString stringWithFormat:@" - %@ with hipstarapp", [Filter nameForFilter:self.filter effect:self.effect]]];
        
        
        SLComposeViewControllerCompletionHandler completeHandler = ^(SLComposeViewControllerResult result) {
            [share dismissViewControllerAnimated:YES completion:nil];
            if (result == SLComposeViewControllerResultDone) {
                _facebookButton.enabled = NO;
                _facebookLabel.alpha = 0.5;
            }
        };
        
        [share setCompletionHandler:completeHandler];
        
        [self presentViewController:share animated:YES completion:nil];
    }
}

- (IBAction)done:(id)sender {
    
    _indicator.hidden = NO;
    
    NSString *thumbnailPath = [[StorageManager instance] storeData:UIImageJPEGRepresentation(_previewImage, 0.6) extension:@"jpg"];
    NSString *largePath = [[StorageManager instance] storeData:UIImageJPEGRepresentation(_fullImage, 0.6) extension:@"jpg"];;
    
    Photo *photo = [Photo photo];
    photo.thumbnailPath = thumbnailPath;
    photo.largePath = largePath;
    photo.filter = self.filter;
    photo.effect = self.effect;
    
    [[StorageManager instance] savePhotoToGallery:photo];
    
    self.navigationController.view.userInteractionEnabled = NO;
    
    UIImageWriteToSavedPhotosAlbum(_fullImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo: (void *) contextInfo {
    [[UIApplication sharedApplication] keyWindow].rootViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CameraViewController"];
}
#pragma mark - UIDocumentInteractionControllerDelegate Implementation



#pragma mark - iCloud


@end
