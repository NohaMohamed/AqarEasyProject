//
//  NearByViewController.m
//  AqarEasy
//
//  Created by Eng. Eman Rezk on 12/13/14.
//  Copyright (c) 2014 Eng.Eman.Rezk. All rights reserved.
//

#import "NearByViewController.h"
#import "NearByCell.h"

@interface NearByViewController ()

@end

@implementation NearByViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"NearBy" ofType:@"plist"];
    self.dataArray = [NSMutableArray arrayWithContentsOfFile:path];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)showAnimate
{
    self.view.transform = CGAffineTransformMakeScale(1.3, 1.3);
    self.view.alpha = 0;
    [UIView animateWithDuration:.25 animations:^{
        self.view.alpha = 1;
        self.view.transform = CGAffineTransformMakeScale(1, 1);
    }];
    
}

- (IBAction)closePopup:(id)sender {
    [self removeAnimate];
}

- (void)removeAnimate
{
    [UIView animateWithDuration:.25 animations:^{
        self.view.transform = CGAffineTransformMakeScale(1.3, 1.3);
        self.view.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self.view removeFromSuperview];
        }
    }];
}


- (void)showInView:(UIView *)aView animated:(BOOL)animated
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [aView addSubview:self.view];
        [self.tableView reloadData];
        if (animated) {
            [self showAnimate];
        }
    });
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.dataArray count] ;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NearByCell *cell ;
    if (cell == nil) {
        cell = (NearByCell*)[tableView dequeueReusableCellWithIdentifier:@"NearByCell" forIndexPath:indexPath];
    }
    
    NSDictionary *item = self.dataArray[(NSUInteger)indexPath.row];

    cell.titleLabel.text = item[@"title"];
    cell.iconImage.image = [UIImage imageNamed:item[@"icon"]];

    UIImage *checkBoxImage = [item[@"checked"] boolValue] ? [UIImage imageNamed:@"checkbox_light_checked"]:[UIImage imageNamed:@"checkbox_light"];
    
    [cell.checkBoxButton setBackgroundImage:checkBoxImage forState:UIControlStateNormal];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 44.0f;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
