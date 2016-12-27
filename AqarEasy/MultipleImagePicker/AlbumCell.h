 //
 // AlbumCell.h
 //  MultipleImagePicker
 //
 //  Created by Eng. Eman Rezk on 12/19/14.
 //  Copyright (c) 2014 Eng.Eman.Rezk. All rights reserved.
 //

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>



@interface AlbumCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *subTitle;

- (void)bind:(ALAssetsGroup *)assetsGroup showNumberOfAssets:(BOOL)showNumberOfAssets;

@end