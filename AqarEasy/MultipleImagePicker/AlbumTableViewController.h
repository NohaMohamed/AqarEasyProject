//
//  AlbumTableViewController.h
//  MultipleImagePicker
//
//  Created by Eng. Eman Rezk on 12/19/14.
//  Copyright (c) 2014 Eng.Eman.Rezk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>


@interface AlbumTableViewController : UITableViewController

@property (strong,nonatomic)id delegate;
@property (nonatomic, strong) NSMutableArray *assetGroups;
@property (nonatomic, strong) ALAssetsFilter *assetsFilter;
//@property (nonatomic) int assetsGroupIndex;
@property (nonatomic) int numberOfGroups;

@property (nonatomic, strong) ALAssetsLibrary *assetsLibrary;

@property (strong,nonatomic)NSMutableArray * selectedAssets;
- (IBAction)dismissImagePicker:(id)sender;

@end
