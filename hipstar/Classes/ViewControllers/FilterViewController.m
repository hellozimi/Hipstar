//
//  FilterViewController.m
//  hipstar
//
//  Created by Simon Andersson on 11/10/12.
//  Copyright (c) 2012 hiddencode.me. All rights reserved.
//

#import "FilterViewController.h"
#import "FilterGenerator.h"
#import "ShareViewController.h"
#import "RedOverlay.h"
#import "TurqoiseOverlay.h"
#import "TestFilter.h"

@interface FilterViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout> {
    CGContextRef _previewContext;
    
    Filter *_currentFilter;
}

@property (weak, nonatomic) IBOutlet UIImageView *previewImageView;
@property (weak, nonatomic) IBOutlet UIImageView *arrow;
@property (weak, nonatomic) IBOutlet UIButton *filterButton;
@property (weak, nonatomic) IBOutlet UIButton *disortButton;

@property (weak, nonatomic) IBOutlet UICollectionView *effectsCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *filterCollectionView;



- (void)update;

- (IBAction)back:(id)sender;
- (IBAction)done:(id)sender;
- (IBAction)disortButtonPressed:(id)sender;
- (IBAction)filterButtonPressed:(id)sender;

@end

@implementation FilterViewController

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
    //[self.arrow setTranslatesAutoresizingMaskIntoConstraints:YES];
    
    
    UIImageView *grayFilter = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_gray_filter"]];
    CGRect frame;
    
    frame = grayFilter.frame;
    frame.origin.y = 10;
    frame.origin.x = 60;
    self.filterCollectionView.clipsToBounds = NO;
    [self.filterCollectionView addSubview:grayFilter];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setOriginalImage:(UIImage *)originalImage {
    _originalImage = originalImage;
    
    _previewContext = BitmapContextCreateWithImage(originalImage, CGSizeMake(250, 250));
}

- (void)update {
    
    double start = [NSDate timeIntervalSinceReferenceDate];
    
    UIImage *img = [UIImage imageWithCGImage:CGBitmapContextCreateImage(_previewContext)];
    
    if (_currentFilter) {
        img = [_currentFilter apply:img];
    }
    
    _previewImageView.image = img;
    
    double end = [NSDate timeIntervalSinceReferenceDate];
    
    NSLog(@"Time to generate filter %@: %f", NSStringFromClass([_currentFilter class]), end-start);
    return;
    /*
     CGImageRef imageRef = CGBitmapContextCreateImage(context);
     
     
     if (_currentFilter) {
     
     NSLog(@"Time to generate filter %@: %f", NSStringFromClass([_currentFilter class]), end-start);
     
     }
     
     UIImage *originalImage = [UIImage imageWithCGImage:imageRef scale:1 orientation:_originalImage.imageOrientation];
     CGImageRelease(imageRef);
     
     
     _previewImageView.image = originalImage;
     
     if (!_currentFilter) {
     BitmapContextRelease(context);
     CGContextRelease(context);
     return;
     }
     
     BitmapContextRelease(context);
     CGContextRelease(context);
     */
    /*
     CGContextRef exportContext = BitmapContextCreateWithImage(_originalImage, CGSizeMake(_originalImage.size.width, _originalImage.size.height));
     
     if (_currentFilter) {
     [_currentFilter apply:exportContext];
     }
     CGImageRef o = CGBitmapContextCreateImage(exportContext);
     BitmapContextRelease(context);
     CGContextRelease(context);
     
     UIImage *eo = [UIImage imageWithCGImage:o scale:1 orientation:UIImageOrientationRight];
     
     UIImageWriteToSavedPhotosAlbum(eo, nil, nil, 0);
     
     CGImageRelease(o);
     CGContextRelease(exportContext);
     */
}

- (void)viewDidAppear:(BOOL)animated {
    [self update];
}

#pragma mark - Actions

- (IBAction)done:(id)sender {
    [self performSegueWithIdentifier:@"PresentShareViewController" sender:self];
}

- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (IBAction)disortButtonPressed:(id)sender {
    
    [sender setImage:[UIImage imageNamed:@"icon_disort_selected"] forState:UIControlStateNormal];
    
    [_filterButton setImage:[UIImage imageNamed:@"icon_filter"] forState:UIControlStateNormal];
    
    [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        CGRect frame = self.arrow.frame;
        frame.origin.x = 127;
        self.arrow.frame = frame;
    } completion:nil];
}

- (IBAction)filterButtonPressed:(id)sender {
    
    [_disortButton setImage:[UIImage imageNamed:@"icon_disort"] forState:UIControlStateNormal];
    [sender setImage:[UIImage imageNamed:@"icon_filter_selected"] forState:UIControlStateNormal];
    
    [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        CGRect frame = self.arrow.frame;
        frame.origin.x = 179;
        self.arrow.frame = frame;
    } completion:nil];
}

#pragma mark - UICollectionViewFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(57, 70);
}

// 3
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 10, 0, 10);
}

#pragma mark - UICollectionViewDelegate Implementation

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    int i = indexPath.row % 3;
    switch (i) {
        case 0:
            _currentFilter = [RedOverlay filter];
            break;
        case 1:
            _currentFilter = [TurqoiseOverlay filter];
            break;
        case 2:
            _currentFilter = [TestFilter filter];
            break;
    }
    
    [self update];
}

#pragma mark - UICollectionViewDataSource Implementation


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 12;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = nil;
    
    if (collectionView == self.filterCollectionView) {
        
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FilterItem" forIndexPath:indexPath];
    }
    else if (collectionView == self.effectsCollectionView) {
        
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"EffectItem" forIndexPath:indexPath];
    }
    
    return cell;
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"PresentShareViewController"]) {
        /*
         UINavigationController *nc = segue.destinationViewController;
         ShareViewController *vc = (ShareViewController *)[nc.viewControllers objectAtIndex:0];
         vc.previewImage = _previewImageView.image;
         
         
         CGContextRef context = BitmapContextCreateCopy(_previewContext);
         
         if (_currentFilter) {
         [_currentFilter apply:context];
         }
         
         CGImageRef imageRef = CGBitmapContextCreateImage(context);
         
         
         UIImage *originalImage = [UIImage imageWithCGImage:imageRef scale:1 orientation:_originalImage.imageOrientation];
         CGImageRelease(imageRef);
         
         
         _previewImageView.image = originalImage;
         
         
         CGContextRef exportContext = BitmapContextCreateWithImage(_originalImage, CGSizeMake(_originalImage.size.width, _originalImage.size.height));
         
         if (_currentFilter) {
         [_currentFilter apply:exportContext];
         }
         CGImageRef o = CGBitmapContextCreateImage(exportContext);
         BitmapContextRelease(context);
         CGContextRelease(context);
         
         UIImage *full = [UIImage imageWithCGImage:o scale:1 orientation:UIImageOrientationRight];
         
         //UIImageWriteToSavedPhotosAlbum(eo, nil, nil, 0);
         
         CGImageRelease(o);
         CGContextRelease(exportContext);
         
         vc.fullImage = full;
         */
    }
}

@end
