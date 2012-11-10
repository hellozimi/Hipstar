//
//  FilterViewController.m
//  hipstar
//
//  Created by Simon Andersson on 11/10/12.
//  Copyright (c) 2012 hiddencode.me. All rights reserved.
//

#import "FilterViewController.h"
#import "FilterGenerator.h"

#import "RedOverlay.h"
#import "TurqoiseOverlay.h"

@interface FilterViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout> {
    CGContextRef _previewContext;
    
    Filter *_currentFilter;
}

@property (weak, nonatomic) IBOutlet UIImageView *previewImageView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
- (void)update;

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
	// Do any additional setup after loading the view.
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
    
    CGContextRef context = BitmapContextCreateCopy(_previewContext);
    
    if (_currentFilter) {
        [_currentFilter apply:context];
    }
    
    CGImageRef imageRef = CGBitmapContextCreateImage(context);
    
    double end = [NSDate timeIntervalSinceReferenceDate];
    
    if (_currentFilter) {
        
        NSLog(@"Time to generate filter %@: %f", NSStringFromClass([_currentFilter class]), end-start);
        
    }
    
    
    UIImage *originalImage = [UIImage imageWithCGImage:imageRef scale:1 orientation:UIImageOrientationRight];
    CGImageRelease(imageRef);
    
    
    _previewImageView.image = originalImage;
    
    if (!_currentFilter) {
        BitmapContextRelease(context);
        CGContextRelease(context);
        return;
    }
    
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
}

- (void)viewDidAppear:(BOOL)animated {
    [self update];
}

#pragma mark - Actions

- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
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
            _currentFilter = nil;
            break;
    }
    
    [self update];
}


#pragma mark - UICollectionViewDataSource Implementation


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 12;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FilterItem" forIndexPath:indexPath];
    
    return cell;
}

@end
