//
//  NearByPopupView.h
//  AqarEasy
//
//  Created by Eng. Eman Rezk on 12/12/14.
//  Copyright (c) 2014 Eng.Eman.Rezk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NearByPopupView : UIView
@property (strong, nonatomic) IBOutlet UIView *view;
@property (weak, nonatomic) IBOutlet UIView *popUpView;

- (IBAction)closePopup:(id)sender;

- (void)removeAnimate;
- (void)showAnimate;
- (void)showInView:(UIView *)aView animated:(BOOL)animated;
@end
