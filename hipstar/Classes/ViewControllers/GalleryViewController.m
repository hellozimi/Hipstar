//
//  GalleryViewController.m
//  hipstar
//
//  Created by Simon Andersson on 11/11/12.
//  Copyright (c) 2012 hiddencode.me. All rights reserved.
//

#import "GalleryViewController.h"
#import "GalleryCollectionViewCell.h"
#import "ShareViewController.h"
#import "StorageManager.h"
#import "Photo.h"

@interface GalleryViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout> {
    NSMutableArray *_dataSet;
    int _selectedIndex;
}
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation GalleryViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    _dataSet = [[StorageManager instance] gallery];
    [self.collectionView reloadData];
}

#pragma mark - Actions

- (IBAction)close:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UICollectionViewFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(106, 115);
}

// 3
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsZero;
}

#pragma mark - UICollectionViewDelegate Implementation

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    _selectedIndex = indexPath.row;
    [self performSegueWithIdentifier:@"PushShareViewController" sender:self];
}

#pragma mark - UICollectionViewDataSource Implementation


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [_dataSet count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GalleryCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CellItem" forIndexPath:indexPath];
    
    Photo *photo = [_dataSet objectAtIndex:indexPath.row];
    
    [cell setPhoto:photo];
    
    return cell;
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"PushShareViewController"]) {
        
        Photo *photo = [_dataSet objectAtIndex:_selectedIndex];
        
        ShareViewController *vc = (ShareViewController *)segue.destinationViewController;
        vc.previewImage = [UIImage imageWithContentsOfFile:[[StorageManager instance] absoluteFilePath:photo.thumbnailPath]];
        vc.fullImage = [UIImage imageWithContentsOfFile:[[StorageManager instance] absoluteFilePath:photo.largePath]];
        vc.photo = photo;
    }
}


@end
