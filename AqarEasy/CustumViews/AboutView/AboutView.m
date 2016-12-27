//
//  AboutView.m
//  AqarEasy
//
//  Created by Eng. Eman Rezk on 11/26/14.
//  Copyright (c) 2014 Eng.Eman.Rezk. All rights reserved.
//

#import "AboutView.h"
#import "iRate.h"
@implementation AboutView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        //Initialize code
        
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self){
        
        // 1.load the interface file from .xib
        [[NSBundle mainBundle] loadNibNamed:@"AboutView" owner:self options:nil];
        
        CGRect frame = self.view.frame;
        frame.size = self.frame.size;
        self.view.frame = frame;
        
        // 2.Add as a subview
        [self addSubview:self.view];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(IBAction)showRating:(id)sender{
    
    [[iRate sharedInstance] promptForRating];
}
- (IBAction)twitterButton:(id)sender {
     [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://twitter.com/ahmed"]];
}

- (IBAction)facebookButton:(id)sender {
       [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.facebook.com/ahmed"]];
}
@end
