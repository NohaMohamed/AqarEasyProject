//
//  AqarInfoView.m
//  AqarEasy
//
//  Created by Eng. Eman Rezk on 11/23/14.
//  Copyright (c) 2014 Eng.Eman.Rezk. All rights reserved.
//

#import "AqarInfoView.h"
@implementation AqarInfoView


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
        [[NSBundle mainBundle] loadNibNamed:@"AqarInfoView" owner:self options:nil];
        
        CGRect frame = self.view.frame;
        frame.size = self.frame.size;
        self.view.frame = frame;
      //  if ([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPad) {
        //    [self.assetsView setHidden:YES];
           // self.assetsViewIpad= [[AssetsView alloc] initWithFrame:CGRectMake(30, -4, 5, 37)];
            
           // [self.assetsViewIpad setHidden:YES];
            
            //[self addSubview:self.assetsViewIpad];
       // }
    
        //[self.assetsView setNeedsDisplay];
        //[self.assetsView layoutIfNeeded];
        
      
        
        /*
        [self.assetsView layoutIfNeeded];
        
        NSLog(@"===============%@",  NSStringFromCGRect(self.assetsView.frame));
        
        CGRect fr=self.assetsView.frame;
        fr.size.width *=2;
        fr.size.height *=2;
        
        self.assetsView.frame=fr;
        [self.assetsView setNeedsDisplay];
       // [self.assetsView layoutIfNeeded];
        NSLog(@"===============%@",  NSStringFromCGRect(self.assetsView.frame));
        */
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

@end
