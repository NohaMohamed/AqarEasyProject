//
//  AqarClassificationViewController.h
//  AqarEasy
//
//  Created by Eng. Eman Rezk on 12/2/14.
//  Copyright (c) 2014 Eng.Eman.Rezk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PropertyModel.h"
#import "SWRevealViewController.h"
#import "SearchViewController.h"

typedef enum {
    favourite,
    sale,
    rent,
    searchResult,
    myaqars
}AqarClassification;

@interface AqarClassificationViewController : UIViewController <SWRevealViewControllerDelegate,SearchViewControllerDelegate>



@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *menuButton;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic) AqarClassification aqarClassification;

@property (nonatomic,strong)NSMutableArray * propertyArray;


//- (void)searchViewControllerDidSearch:(SearchViewController *)controller;

@end
