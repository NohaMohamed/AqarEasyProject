//
//  NewsViewController.h
//  AqarEasy
//
//  Created by Assem Imam on 10/28/16.
//  Copyright © 2016 Eng.Eman.Rezk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    __weak IBOutlet UIBarButtonItem *menuButton;
    __weak IBOutlet UITableView *newsTableView;
}
- (IBAction)backButtonAction:(UIButton *)sender;
- (IBAction)readMoreButtonAction:(UIButton *)sender;
@end
        