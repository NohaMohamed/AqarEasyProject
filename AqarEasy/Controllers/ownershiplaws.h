//
//  ownershiplaws.h
//  AqarEasy
//
//  Created by Atef on 5/9/15.
//  Copyright (c) 2015 Eng.Eman.Rezk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SDWebImage/UIImageView+WebCache.h>
@interface ownershiplaws : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *ArrData;
  __weak IBOutlet  UITableView *TBL_ownerShips;
}
@property (weak, nonatomic) IBOutlet UIBarButtonItem *menuButton;

@end
