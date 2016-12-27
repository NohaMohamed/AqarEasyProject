//
//  ownershiplaws.m
//  AqarEasy
//
//  Created by Atef on 5/9/15.
//  Copyright (c) 2015 Eng.Eman.Rezk. All rights reserved.
//

#import "ownershiplaws.h"
#import "APIControlManager.h"
#import "Utility.h"
#import "ownershipCell.h"
#import "SWRevealViewController.h"
#import "ownershipDetails.h"
@implementation ownershiplaws
-(void)viewDidLoad{
    [super viewDidLoad];
    
    _menuButton.target = self.revealViewController;
    _menuButton.action = @selector(revealToggle:);
    
    // Add pan gesture to hide the sidebar
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];

    [Utility showLoading];
    
    [[APIControlManager sharedInstance] getDataWithPath:@"ownershipLaw" withCompletionBlock:^(id ret) {
       
        if ([ret isKindOfClass:[NSArray class]]) {
            ArrData=ret;
            [TBL_ownerShips reloadData];
            [Utility hideLoading];
        }
        
    }];
   
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return ArrData.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ownershipCell *cell=[tableView dequeueReusableCellWithIdentifier:@"ownershipCell"];
    cell.LBL_country.text=ArrData[indexPath.row][@"title"];
    [cell.IMG_flag sd_setImageWithURL:[NSURL URLWithString:ArrData[indexPath.row][@"flag"]] placeholderImage:nil];
    
    return  cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ownershipDetails *ctrl=(ownershipDetails*)[self.storyboard instantiateViewControllerWithIdentifier:@"ownershipDetails"];
    
    ctrl.dicPassed=ArrData[indexPath.row];
    [self.navigationController pushViewController:ctrl animated:YES];
}
@end
