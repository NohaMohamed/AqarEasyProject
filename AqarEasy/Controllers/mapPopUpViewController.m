//
//  mapPopUpViewController.m
//  AqarEasy
//
//  Created by Atef on 6/14/15.
//  Copyright (c) 2015 Eng.Eman.Rezk. All rights reserved.
//

#import "mapPopUpViewController.h"
#import "PropertyInfoViewController.h"

@interface mapPopUpViewController ()

@end

@implementation mapPopUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.View_summeryIphone setDataFromModel:self.model];
    
    // Do any additional setup after loading the view.
}



- (IBAction)GoTODetails:(id)sender {
    if (self.delg) {
        if ([self.delg respondsToSelector:@selector(ButtonClickedWithModel:)]) {
            [self.delg ButtonClickedWithModel:self.model];
        }
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
