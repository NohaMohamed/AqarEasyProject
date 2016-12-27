//
//  AboutAqarEasyViewController.h
//  AqarEasy
//
//  Created by Eng. Eman Rezk on 11/26/14.
//  Copyright (c) 2014 Eng.Eman.Rezk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AboutAqarEasyViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIBarButtonItem *menuButton;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

-(void) setNavigationImage;
- (void) loadContentInWebView;
@end
