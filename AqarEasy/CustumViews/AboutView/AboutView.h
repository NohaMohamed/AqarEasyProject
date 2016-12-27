//
//  AboutView.h
//  AqarEasy
//
//  Created by Eng. Eman Rezk on 11/26/14.
//  Copyright (c) 2014 Eng.Eman.Rezk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AboutView : UIView
@property (strong, nonatomic) IBOutlet UIView *view;

- (IBAction)twitterButton:(id)sender;
- (IBAction)facebookButton:(id)sender;
- (IBAction)showRating:(id)sender;



@end
