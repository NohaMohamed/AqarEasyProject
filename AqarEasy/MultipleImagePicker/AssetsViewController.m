//
//  AssetsViewController.m
//  MultipleImagePicker
//
//  Created by Eng. Eman Rezk on 12/19/14.
//  Copyright (c) 2014 Eng.Eman.Rezk. All rights reserved.
//

#import "AssetsViewController.h"
#import "Utility.h"
#import "AssetsCell.h"

@interface AssetsViewController ()

@end

@implementation AssetsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    

    self.title = [self.assetsGroup valueForProperty:ALAssetsGroupPropertyName];
    
    [self.toolbar setBackgroundImage:[UIImage new]
                  forToolbarPosition:UIBarPositionAny
                          barMetrics:UIBarMetricsDefault];
    [self.toolbar setShadowImage:[UIImage new]
              forToolbarPosition:UIToolbarPositionAny];
    
    self.assets = [NSMutableArray array];
//    self.thumbnails = [NSMutableArray array];
    self.selectedAssets = [NSMutableArray arrayWithArray:[Utility sharedInstance].selectedAssets];
    
    [self preparePhotos];
    
    if ([Utility sharedInstance].pickerType == pickerTypeMovie) {
        UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(handleLongPressGesture:)];
        [self.collectionView addGestureRecognizer:longPressGesture];
        longPressGesture.delegate = (id)self;
        [self getAssetsDurations];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)handleLongPressGesture:(UILongPressGestureRecognizer *)gestureRecognizer
{
    self.collectionView.userInteractionEnabled = NO;
    CGPoint p = [gestureRecognizer locationInView:self.collectionView];
    
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:p];
    if (indexPath == nil)
        NSLog(@"Long press on collection view but not on a row");
    else{
        NSLog(@"long press on collection view at row %li", (long)indexPath.row);
        [self playAlAsset:self.assets[indexPath.row]];
    }
}

- (void)preparePhotos
{
    [self.assetsGroup enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
        if(result == nil) {
            return;
        }
        [self.assets addObject:result];
//        [self.thumbnails addObject:[UIImage imageWithCGImage:[result aspectRatioThumbnail]]];
        [self.collectionView reloadData];
    }];
    self.checkedAssetsNumbers = [NSMutableArray arrayWithCapacity:self.assets.count];
    for (int i = 0; i < self.assets.count; i++) {
        if([[Utility sharedInstance].selectedAssets containsObject:self.assets[i]])
            [self.checkedAssetsNumbers addObject:@1];
        else
            [self.checkedAssetsNumbers addObject:[NSNull null]];
    }
    [self.collectionView reloadData];
}



- (IBAction)doneBtnClicked:(id)sender {
    
    __weak __typeof(&*self)weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        __strong __typeof(&*weakSelf)strongSelf = weakSelf;
        BOOL isUserCheckAssets = NO;
        for (int i = 0; i < strongSelf.assets.count; i++) {
            if (![strongSelf.checkedAssetsNumbers[i] isEqual:[NSNull null]]) {
                isUserCheckAssets = YES;
                break;
            }
        }
        if (isUserCheckAssets) {
            strongSelf.selectedAssets = [NSMutableArray array];
            for (int i = 0; i < strongSelf.assets.count; i++)
            {
                if (strongSelf.checkedAssetsNumbers[i] != [NSNull null]) {
                    ALAsset *myAsset = (ALAsset *)(strongSelf.assets[i]);
                    [strongSelf.selectedAssets addObject:myAsset];
                }
            }
            [Utility sharedInstance].selectedAssets = [NSMutableArray arrayWithArray:strongSelf.selectedAssets];
        }
        [self.delegate assetsViewController:self didSelectImages:[NSMutableArray arrayWithArray:strongSelf.selectedAssets]];
        
        //[self.navigationController popToRootViewControllerAnimated:YES];
        [self.navigationController popViewControllerAnimated:YES];
        [self.navigationController popViewControllerAnimated:YES];
    });
}


- (void)getAssetsDurations
{
    self.assetsDurations = [NSMutableArray arrayWithCapacity:self.assets.count];
    for (ALAsset *alAsset in self.assets) {
        if ([alAsset valueForProperty:ALAssetPropertyType] == ALAssetTypeVideo) {
            if ([alAsset valueForProperty:ALAssetPropertyDuration] != ALErrorInvalidProperty) {
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"mm:ss"];
                [self.assetsDurations addObject:[formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[[alAsset valueForProperty:ALAssetPropertyDuration] doubleValue]]]];
            }
        }
    }
}

#pragma mark - UICollectionViewDataSource methods

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.assets.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
//    UIImage *thumbnail = self.thumbnails[indexPath.row];
    ALAsset * ass = self.assets[indexPath.row];
//    UIImage *image = [UIImage imageWithCGImage:ass];
    
    UIImage *image =[UIImage imageWithCGImage:[ass aspectRatioThumbnail]];
    AssetsCell *cell = (AssetsCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"AssetsCell" forIndexPath:indexPath];
    cell.imageView.image = image;
    if ([Utility sharedInstance].pickerType == pickerTypeMovie) {
        cell.duration.hidden = NO;
        cell.duration.text =  self.assetsDurations[indexPath.row];
    }else{
        cell.duration.hidden = YES;
    }
    if ([self.checkedAssetsNumbers[indexPath.row] isEqual:[NSNull null]]) {
        cell.check.hidden = YES;
    }
    else {
        cell.check.hidden = NO;
    }
    return cell;
}

#pragma mark - UICollectionViewDelegate methods

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    AssetsCell *cell = (AssetsCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if (cell.check.hidden)
    {
        [self.checkedAssetsNumbers replaceObjectAtIndex:indexPath.row withObject:@1];
        cell.check.hidden = NO;
    }
    else{
        [self.checkedAssetsNumbers replaceObjectAtIndex:indexPath.row withObject:[NSNull null]];
        cell.check.hidden = YES;
    }
}

#pragma mark - Play Movie

-(void)playAlAsset:(ALAsset *)asset
{
    if (!self.isPlayerPlaying)
    {
        self.isPlayerPlaying = YES;
        NSURL *url = [asset valueForProperty:ALAssetPropertyAssetURL];
        self.playerVC = [[MPMoviePlayerViewController alloc] initWithContentURL:url];
        
        [[NSNotificationCenter defaultCenter] removeObserver:self.playerVC
                                                        name:MPMoviePlayerPlaybackDidFinishNotification
                                                      object:self.playerVC.moviePlayer];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(movieFinishedCallback:)
                                                     name:MPMoviePlayerPlaybackDidFinishNotification
                                                   object:self.playerVC.moviePlayer];
        
        self.playerVC.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        self.playerVC.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:self.playerVC animated:YES completion:^{
            NSLog(@"done present player");
        }];
        [self.playerVC.moviePlayer setFullscreen:NO];
        [self.playerVC.moviePlayer prepareToPlay];
        [self.playerVC.moviePlayer play];
    }
}

- (void)movieFinishedCallback:(NSNotification*)aNotification
{
    if ([aNotification.name isEqualToString: MPMoviePlayerPlaybackDidFinishNotification]) {
        NSNumber *finishReason = [[aNotification userInfo] objectForKey:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey];
        
        if ([finishReason intValue] != MPMovieFinishReasonPlaybackEnded)
        {
            MPMoviePlayerController *moviePlayer = [aNotification object];
            
            
            [[NSNotificationCenter defaultCenter] removeObserver:self
                                                            name:MPMoviePlayerPlaybackDidFinishNotification
                                                          object:moviePlayer];
            [self dismissViewControllerAnimated:YES completion:^{  }];
        }
        self.collectionView.userInteractionEnabled = YES;
        self.isPlayerPlaying = NO;
    }
}



@end
