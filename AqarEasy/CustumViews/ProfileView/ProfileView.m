//
//  ProfileView.m
//  AqarEasy
//
//  Created by Eng. Eman Rezk on 12/1/14.
//  Copyright (c) 2014 Eng.Eman.Rezk. All rights reserved.
//

#import "ProfileView.h"
#import "UIcolor+PlaceHolder.h"
@implementation ProfileView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        //Initialize code
       // NSDictionary *user = @{@"name":TXT_username.text,@"mail":TXT_email.text,@"pass":TXT_pass.text,@"field_address":@{@"und":@[@{@"value":TXT_address.text}]},@"field_telephone":@{@"und":@[@{@"number":TXT_mobile.text,@"country_codes":@"sa"}]},@"field_check_test":@{@"und":@[@{@"value":@"1"}]}};
        
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self){
        
        // 1.load the interface file from .xib
        [[NSBundle mainBundle] loadNibNamed:@"ProfileView" owner:self options:nil];
        
        CGRect frame = self.view.frame;
        frame.size = self.frame.size;
        self.view.frame = frame;
        
        // 2.Add as a subview
        [self addSubview:self.view];
        
        // Set Border to userPasswardView
        self.userPasswardView.layer.borderWidth = 1.0;
        self.userPasswardView.layer.borderColor = [UIColor brownColor].CGColor;
           
        //self.BTN_userImg.layer.cornerRadius=40;
        //[self.BTN_userImg.layer setMasksToBounds:YES];

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

@end
