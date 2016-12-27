//
//  ownershipDetails.m
//  AqarEasy
//
//  Created by Atef on 5/9/15.
//  Copyright (c) 2015 Eng.Eman.Rezk. All rights reserved.
//

#import "ownershipDetails.h"

@implementation ownershipDetails
-(void)viewDidLoad{
    [super viewDidLoad];
    UIImage *image = [[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self.navigationController action:@selector(popViewControllerAnimated:)];
    
    self.title=_dicPassed[@"title"];
     _TXT_details.text=_dicPassed[@"body"];
}
@end
