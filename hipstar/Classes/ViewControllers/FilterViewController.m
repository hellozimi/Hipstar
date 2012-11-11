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

// Filter
#import "NoFX.h"
#import "Midtown.h"
#import "Chipper.h"
#import "Sepia.h"
#import "Kale.h"

// Distort
#import "Mirror.h"
#import "Sonic.h"
#import "Target.h"

@interface FilterViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout> {
    UIImage *_previewImage;
    
    Filter *_currentFilter;
    Filter *_currentEffect;
    
    int _currentSelectedFilterIndex;
    int _currentSelectedEffectIndex;
    
    int _lastSelectedFilterIndex;
    int _lastSelectedEffectIndex;
    
    NSMutableArray *_filters;
    NSMutableArray *_effects;
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _filters = [NSMutableArray arrayWithArray:@[
                [NoFX filter],
                [Midtown filter],
                [Chipper filter],
                [Sepia filter],
                [Kale filter],
                ]];
    
    _effects = [NSMutableArray arrayWithArray:@[
                [NoFX filter],
                [Mirror filter],
                [Sonic filter],
                [Target filter]
                ]];
    
    _previewImageView.layer.cornerRadius = 4;
    _previewImageView.layer.masksToBounds = YES;
    
    _lastSelectedEffectIndex = _lastSelectedFilterIndex = -1;
    
    _border.top += 0.5;
    
    _currentSelectedEffectIndex = _currentSelectedFilterIndex = 0;
    [self update];
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
    _previewImage = [self resizeImage:_originalImage newSize:CGSizeMake(150, 150)];
    
}

- (void)update {
    
    double start = [NSDate timeIntervalSinceReferenceDate];
    
    UIImage *img = _previewImage;
    
    if (_currentFilter) {
        img = [_currentFilter apply:_previewImage];
    }
    
    
    if (_currentEffect) {
        img = [_currentEffect apply:img];
    }
    _previewImageView.image = img;
    
    double end = [NSDate timeIntervalSinceReferenceDate];
    
    NSLog(@"Time to generate filter %@ & effect %@ — %f", _currentFilter.name, _currentEffect.name, end-start);
    return;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self update];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
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
        _currentFilter = [_filters objectAtIndex:indexPath.row];
        
    }
    else {
        
        FilterCollectionViewCell *oldCell = (FilterCollectionViewCell *)[collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:_currentSelectedEffectIndex inSection:0]];
        oldCell.selected = NO;
        
        _currentSelectedEffectIndex = indexPath.row;
        
        
        FilterCollectionViewCell *newCell = (FilterCollectionViewCell *)[collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:_currentSelectedEffectIndex inSection:0]];
        newCell.selected = YES;
        
        _currentEffect = [_effects objectAtIndex:indexPath.row];
        
    }
    
    [self update];
}

#pragma mark - UICollectionViewDataSource Implementation


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return (collectionView == self.filterCollectionView) ? _filters.count : _effects.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FilterCollectionViewCell *cell = nil;
    
    if (collectionView == self.effectsCollectionView) {
        
        cell = (FilterCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"EffectItem" forIndexPath:indexPath];
        
        
        Filter *f = [_effects objectAtIndex:indexPath.row];
        cell.title = f.name;
        
        cell.selected = indexPath.row == _currentSelectedFilterIndex;
        cell.filterImage = f.image;
    }
    else if (collectionView == self.filterCollectionView) {
        
        cell = (FilterCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"FilterItem" forIndexPath:indexPath];
        // Midtown, Chipper, Cronkite, Clothesline, Frado, Deck, Frapp, Tassle
        
        Filter *f = [_filters objectAtIndex:indexPath.row];
        cell.title = f.name;
        
        cell.selected = indexPath.row == _currentSelectedFilterIndex;
        cell.filterImage = f.image;
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
        
        if (_currentEffect) {
            full = [_currentEffect apply:full];
        }
        
        vc.fullImage = full;
        vc.filter = _currentFilter;
        vc.effect = _currentEffect;
    }
}

@end

