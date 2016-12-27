//
//  AssetsViewController.h
//  MultipleImagePicker
//
//  Created by Eng. Eman Rezk on 12/19/14.
//  Copyright (c) 2014 Eng.Eman.Rezk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AssetsLibrary/AssetsLibrary.h>

@class AssetsViewController;
@protocol AssetsViewControllerDelegate <NSObject>

-(void)assetsViewController:(AssetsViewController*)controller didSelectImages:(NSMutableArray*)selectedImages;
@end

@interface AssetsViewController : UIViewController

@property (weak,nonatomic) id <AssetsViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) ALAssetsGroup *assetsGroup;
@property (strong, nonatomic) NSMutableArray *assets;
@property (strong, nonatomic) NSMutableArray *checkedAssetsNumbers;
//@property (strong, nonatomic) NSMutableArray *thumbnails;
@property (strong, nonatomic) NSMutableArray *assetsDurations;
@property (nonatomic) BOOL isPlayerPlaying;
@property (strong, nonatomic) MPMoviePlayerViewController *playerVC;


@property (strong, nonatomic) NSMutableArray *selectedAssets;

- (IBAction)doneBtnClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;

@end
