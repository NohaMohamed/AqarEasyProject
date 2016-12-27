//
//  AlbumTableViewController.m
//  MultipleImagePicker
//
//  Created by Eng. Eman Rezk on 12/19/14.
//  Copyright (c) 2014 Eng.Eman.Rezk. All rights reserved.
//

#import "AlbumTableViewController.h"
#import "AlbumCell.h"
#import "Utility.h"
#import "AssetsViewController.h"

@interface AlbumTableViewController ()

@end

@implementation AlbumTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.assetGroups = [[NSMutableArray alloc]init];
    self.assetsLibrary = [self.class defaultAssetsLibrary];
    self.selectedAssets = [[NSMutableArray alloc]init];
    
    if([Utility sharedInstance].pickerType == pickerTypePhoto)
        self.assetsFilter  = [ALAssetsFilter allPhotos];
    else if([Utility sharedInstance].pickerType == pickerTypeMovie)
        self.assetsFilter  = [ALAssetsFilter allVideos];
    else
        self.assetsFilter  = [ALAssetsFilter allAssets];

    
    [self setupAlbumsGroup];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setSelectedAssets:) name:@"DeviceTokenNotification" object:nil];
}

- (void)setupAlbumsGroup
{
    
    // Load Albums into assetGroups
    dispatch_async(dispatch_get_main_queue(), ^{
        // Group enumerator Block
        void (^assetGroupEnumerator)(ALAssetsGroup *, BOOL *) = ^(ALAssetsGroup *group, BOOL *stop)
        {
            if (group == nil) {
                return;
            }
            NSString *sGroupPropertyName = (NSString *)[group valueForProperty:ALAssetsGroupPropertyName];
            NSUInteger nType = [[group valueForProperty:ALAssetsGroupPropertyType] intValue];
            [group setAssetsFilter:self.assetsFilter];

            // Insert Camera roll first
            if ([[sGroupPropertyName lowercaseString] isEqualToString:@"camera roll"] && nType == ALAssetsGroupSavedPhotos) {
                [self.assetGroups insertObject:group atIndex:0];
            }
            else {
                if (group.numberOfAssets != 0) {
                    [self.assetGroups addObject:group];
                }
            }
            [self performSelectorOnMainThread:@selector(reloadTableView) withObject:nil waitUntilDone:YES];
        };
        // Group Enumerator Failure Block
        void (^assetGroupEnumberatorFailure)(NSError *) = ^(NSError *error) {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"Album Error: %@ - %@", [error localizedDescription], [error localizedRecoverySuggestion]] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert show];
            
            if ([[error localizedDescription] isEqualToString:@"User denied access" ]) {
                [self performSelector:@selector(dismissImagePicker) withObject:nil afterDelay:2];
            }
        };
        
//        // Enumerate Camera roll first
//        [self.assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos
//                                                 usingBlock:assetGroupEnumerator
//                                               failureBlock:assetGroupEnumberatorFailure];
        
        // Enumerate all groups
        NSUInteger type =
        ALAssetsGroupLibrary | ALAssetsGroupAlbum | ALAssetsGroupEvent |
        ALAssetsGroupFaces | ALAssetsGroupPhotoStream | ALAssetsGroupSavedPhotos;
        
        [self.assetsLibrary enumerateGroupsWithTypes:type
                                                 usingBlock:assetGroupEnumerator
                                               failureBlock:assetGroupEnumberatorFailure];
    });
    
}

- (void)reloadTableView
{
    [self.tableView reloadData];
}

- (void)dismissImagePicker
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - ALAssetsLibrary

+ (ALAssetsLibrary *)defaultAssetsLibrary
{
    static dispatch_once_t pred = 0;
    static ALAssetsLibrary *library = nil;
    dispatch_once(&pred,^
                  {
                      library = [[ALAssetsLibrary alloc] init];
                  });
    return library;
}

//Lazy load assetsLibrary. User will be able to set his custom assetsLibrary
- (ALAssetsLibrary *)assetsLibrary
{
    if (nil == _assetsLibrary)
    {
        _assetsLibrary = [self.class defaultAssetsLibrary];
    }
    
    return _assetsLibrary;
}
//
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)dismissImagePicker:(id)sender {
    [self dismissImagePicker];
}

#pragma mark - TableView data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.assetGroups count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AlbumCell *cell ;
    if (cell == nil) {
        cell = (AlbumCell*)[tableView dequeueReusableCellWithIdentifier:@"AlbumCell" forIndexPath:indexPath];
    }
    ALAssetsGroup *group = (ALAssetsGroup*)[self.assetGroups objectAtIndex:indexPath.row];
    [group setAssetsFilter:self.assetsFilter];

    NSInteger groupCount = [group numberOfAssets];

    cell.title.text = [group valueForProperty:ALAssetsGroupPropertyName];
    cell.subTitle.text = [@(groupCount) stringValue];
    cell.image.image = [UIImage imageWithCGImage:[(ALAssetsGroup*)[self.assetGroups objectAtIndex:indexPath.row] posterImage]];
    return cell;
}

//#pragma mark - Table view delegate methods
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    self.assetsGroupIndex = indexPath.row;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 80;
}

#pragma mark - Prepare segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"AssetsSegue"]){
        AssetsViewController *assetsVC = [segue destinationViewController];
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        assetsVC.assetsGroup = [self.assetGroups objectAtIndex:indexPath.row];
        assetsVC.delegate = _delegate;
    }
}


@end
