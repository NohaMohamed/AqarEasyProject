//
//  SelectViewController.h
//  AqarEasy
//
//  Created by ITS Mobile Banking on 10/14/15.
//  Copyright (c) 2015 Eng.Eman.Rezk. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol selectViewControllerDelegate <NSObject>

-(void)tableSelctedWithResult:(NSDictionary*)dic;
-(void)userCancelSelect;

@end
@interface SelectViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    __weak IBOutlet UITableView *TBL_select;

}
@property(nonatomic,weak)id<selectViewControllerDelegate>delgate;
@property(nonatomic,strong)NSArray *arrData;
@end

