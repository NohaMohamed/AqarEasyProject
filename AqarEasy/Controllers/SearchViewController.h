//
//  SearchViewController.h
//  AqarEasy
//
//  Created by Eng. Eman Rezk on 12/2/14.
//  Copyright (c) 2014 Eng.Eman.Rezk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchView.h"
#import "UIKeyboardViewController.h"
#import "NearByPopupView.h"
#import "NearByViewController.h"

@class SearchViewController;

@protocol SearchViewControllerDelegate <NSObject>
- (void)searchViewControllerDidCancel:(SearchViewController *)controller;
- (void)searchViewControllerDidSearch:(SearchViewController *)controller;
@end

@interface SearchViewController : UIViewController <UIKeyboardViewControllerDelegate>
{
    UIKeyboardViewController *keyBoardController;
    NearByPopupView *nearByPopupView;
    
    
    IBOutletCollection(UIView) NSArray *VIEWS;
    
    __weak IBOutlet UILabel *LBL_region;
    __weak IBOutlet UILabel *LBL_countries;
    __weak IBOutlet UILabel *LBL_city;
    
    __weak IBOutlet UILabel *LBL_aqarType;
    __weak IBOutlet UILabel * LBL_price;
    
    __weak IBOutlet UILabel * LBL_street;

    
   __weak IBOutlet UIView *priceRangeSliderView;

}
@property(nonatomic,weak) IBOutlet UILabel *LBL_bedRoomCount;
@property(nonatomic,weak) IBOutlet UILabel *LBL_bathRoomCount;
//@property(nonatomic,strong)SearchView *searchView;
@property(nonatomic,strong)NSString *comefromController;
@property (strong,nonatomic) RangeSlider *priceSlider;
@property(nonatomic,strong)NSString *SRprice_from;
@property(nonatomic,strong)NSString *SRprice_to;
@property(weak,nonatomic) id<SearchViewControllerDelegate> delegate;
@property(nonatomic,strong)NSString *tid;
@property(nonatomic,strong)NSString *SRcontract_type;
@property(nonatomic,strong)NSString *SRtype;

@property(strong,nonatomic)NearByViewController *nearByViewController;
- (IBAction)search:(id)sender;
- (IBAction)cancel:(id)sender;


@end
