//
//  NearByPopupView.m
//  AqarEasy
//
//  Created by Eng. Eman Rezk on 12/12/14.
//  Copyright (c) 2014 Eng.Eman.Rezk. All rights reserved.
//

#import "NearByPopupView.h"

@implementation NearByPopupView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        //Initialize code
        // 1.load the interface file from .xib
        [[NSBundle mainBundle] loadNibNamed:@"NearByPopupView" owner:self options:nil];
        
        self.view.frame = frame;
        
        // 2.Add as a subview
        [self addSubview:self.view];
    }
    return self;
}

-(id)init{
    self = [super init];
    if(self){
        
        // 1.load the interface file from .xib
        [[NSBundle mainBundle] loadNibNamed:@"NearByPopupView" owner:self options:nil];
        
        CGRect frame = self.view.frame;
        frame.size = self.frame.size;
        self.view.frame = frame;
        
        // 2.Add as a subview
        [self addSubview:self.view];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self){
    }
    return self;
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
        if (animated) {
            [self showAnimate];
        }
    });
}

@end
