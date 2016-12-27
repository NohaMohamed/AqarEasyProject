//
//  NearByViewController.h
//  AqarEasy
//
//  Created by Eng. Eman Rezk on 12/13/14.
//  Copyright (c) 2014 Eng.Eman.Rezk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NearByViewController : UIViewController

@property(strong,nonatomic)NSMutableArray *dataArray;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)closePopup:(id)sender;

- (void)removeAnimate;
- (void)showAnimate;
- (void)showInView:(UIView *)aView animated:(BOOL)animated;

@end
