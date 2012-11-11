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
#import "FilterCollectionViewCell.h"

#import "RedOverlay.h"
#import "TurqoiseOverlay.h"
#import "TestFilter.h"

#import "Midtown.h"
#import "Chipper.h"

@interface FilterViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout> {
    UIImage *_previewImage;
    
    Filter *_currentFilter;
    
    int _currentSelectedFilterIndex;
    int _currentSelectedEffectIndex;
}

@property (weak, nonatomic) IBOutlet UIImageView *previewImageView;
@property (weak, nonatomic) IBOutlet UIImageView *arrow;
@property (weak, nonatomic) IBOutlet UIButton *filterButton;
@property (weak, nonatomic) IBOutlet UIButton *disortButton;

@property (weak, nonatomic) IBOutlet UICollectionView *effectsCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *filterCollectionView;

@property (weak, nonatomic) IBOutlet UIImageView *border;


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
    
    
    _previewImageView.layer.cornerRadius = 4;
    _previewImageView.layer.masksToBounds = YES;
    
    _border.top += 0.5;
    
    _currentSelectedEffectIndex = _currentSelectedFilterIndex = 0;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIImage *)resizeImage:(UIImage*)image newSize:(CGSize)newSize {
    CGRect newRect = CGRectIntegral(CGRectMake(0, 0, newSize.width, newSize.height));
    CGImageRef imageRef = image.CGImage;
    
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Set the quality level to use when rescaling
    CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
    CGAffineTransform flipVertical = CGAffineTransformMake(1, 0, 0, -1, 0, newSize.height);
    
    CGContextConcatCTM(context, flipVertical);
    // Draw into the context; this scales the image
    CGContextDrawImage(context, newRect, imageRef);
    
    // Get the resized image from the context and a UIImage
    CGImageRef newImageRef = CGBitmapContextCreateImage(context);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    
    CGImageRelease(newImageRef);
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (void)setOriginalImage:(UIImage *)originalImage {
    _originalImage = originalImage;
    _previewImage = [self resizeImage:_originalImage newSize:CGSizeMake(250, 250)];
    
}

- (void)update {
    
    double start = [NSDate timeIntervalSinceReferenceDate];
    
    UIImage *img = _previewImage;
    
    if (_currentFilter) {
        img = [_currentFilter apply:_previewImage];
    }
    
    _previewImageView.image = img;
    
    double end = [NSDate timeIntervalSinceReferenceDate];
    
    NSLog(@"Time to generate filter %@: %f", NSStringFromClass([_currentFilter class]), end-start);
    return;
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
    
    
    [UIView animateWithDuration:0.3 animations:^{
        self.effectsCollectionView.left = 0;
        self.filterCollectionView.left = 320;
    }];
}

- (IBAction)filterButtonPressed:(id)sender {
    
    [_disortButton setImage:[UIImage imageNamed:@"icon_disort"] forState:UIControlStateNormal];
    [sender setImage:[UIImage imageNamed:@"icon_filter_selected"] forState:UIControlStateNormal];
    
    [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        CGRect frame = self.arrow.frame;
        frame.origin.x = 179;
        self.arrow.frame = frame;
        
    } completion:nil];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.effectsCollectionView.left = -320;
        self.filterCollectionView.left = 0;
    }];
}

#pragma mark - UICollectionViewFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(67, 80);
}

// 3
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 10, 0, 10);
}

#pragma mark - UICollectionViewDelegate Implementation

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (collectionView == self.filterCollectionView) {
        
        FilterCollectionViewCell *oldCell = (FilterCollectionViewCell *)[collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:_currentSelectedFilterIndex inSection:0]];
        oldCell.selected = NO;
        
        _currentSelectedFilterIndex = indexPath.row;
        
        
        FilterCollectionViewCell *newCell = (FilterCollectionViewCell *)[collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:_currentSelectedFilterIndex inSection:0]];
        newCell.selected = YES;
        
        int i = indexPath.row % 3;
        switch (i) {
            case 0:
                _currentFilter = nil;
                break;
            case 1:
                _currentFilter = [Midtown filter];
                break;
            case 2:
                _currentFilter = [Chipper filter];
                break;
        }
        
    }
    else {
        
        FilterCollectionViewCell *oldCell = (FilterCollectionViewCell *)[collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:_currentSelectedEffectIndex inSection:0]];
        oldCell.selected = NO;
        
        _currentSelectedEffectIndex = indexPath.row;
        
        
        FilterCollectionViewCell *newCell = (FilterCollectionViewCell *)[collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:_currentSelectedEffectIndex inSection:0]];
        newCell.selected = YES;
        
    }
    
    [self update];
}

#pragma mark - UICollectionViewDataSource Implementation


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return (collectionView == self.filterCollectionView) ? 9 : 12;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FilterCollectionViewCell *cell = nil;
    
    if (collectionView == self.effectsCollectionView) {
        
        cell = (FilterCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"EffectItem" forIndexPath:indexPath];
        
        
        cell.filterImage = [UIImage imageNamed:@"no-fx.jpg"];
        cell.selected = indexPath.row == _currentSelectedEffectIndex;
    }
    else if (collectionView == self.filterCollectionView) {
        
        cell = (FilterCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"FilterItem" forIndexPath:indexPath];
        // Midtown, Chipper, Cronkite, Clothesline, Frado, Deck, Frapp, Tassle
        
        switch (indexPath.row) {
            case 0:
                cell.title = @"No fx";
                break;
            case 1:
                cell.title = @"Midtown";
                break;
            case 2:
                cell.title = @"Chipper";
                break;
            case 3:
                cell.title = @"Cronkite";
                break;
            case 4:
                cell.title = @"Clothesline";
                break;
            case 5:
                cell.title = @"Frado";
                break;
            case 6:
                cell.title = @"Deck";
                break;
            case 7:
                cell.title = @"Frapp";
                break;
            case 8:
                cell.title = @"Tassle";
                break;
                
            default:
                break;
        }
        
        cell.selected = indexPath.row == _currentSelectedFilterIndex;
        cell.filterImage = [UIImage imageNamed:@"no-fx.jpg"];
    }
    
    return cell;
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"PresentShareViewController"]) {
        
        UINavigationController *nc = segue.destinationViewController;
        ShareViewController *vc = (ShareViewController *)[nc.viewControllers objectAtIndex:0];
        vc.previewImage = _previewImageView.image;
        
        UIImage *full = _originalImage;
        
        if (_currentFilter) {
            full = [_currentFilter apply:_originalImage];
        }
        vc.fullImage = full;
        
    }
}

@end

