//
//  AdvertiserView.m
//  AqarEasy
//
//  Created by Eng. Eman Rezk on 11/23/14.
//  Copyright (c) 2014 Eng.Eman.Rezk. All rights reserved.
//

#import "AdvertiserView.h"

@implementation AdvertiserView

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
        [[NSBundle mainBundle] loadNibNamed:@"AdvertiserView" owner:self options:nil];
        
        CGRect frame = self.view.frame;
        frame.size = self.frame.size;
        self.view.frame = frame;
        
        // 2.Add as a subview
        [self addSubview:self.view];
        
    }
    return self;
}

/*
- (id)awakeAfterUsingCoder:(NSCoder *)aDecoder
{
    
    if (![self.subviews count])
    {
        NSBundle *mainBundle = [NSBundle mainBundle];
        NSString *nibName=[NSString stringWithFormat:@"%@",NSStringFromClass([self class])];
        
        NSArray *loadedViews = [mainBundle loadNibNamed:nibName owner:nil options:nil];
        AdvertiserView *loadedView = [loadedViews firstObject];
        
        loadedView.frame = self.frame;
        loadedView.autoresizingMask = self.autoresizingMask;
        loadedView.translatesAutoresizingMaskIntoConstraints =
        self.translatesAutoresizingMaskIntoConstraints;
        
        for (NSLayoutConstraint *constraint in self.constraints)
        {
            id firstItem = constraint.firstItem;
            if (firstItem == self)
            {
                firstItem = loadedView;
            }
            id secondItem = constraint.secondItem;
            if (secondItem == self)
            {
                secondItem = loadedView;
            }
            [loadedView addConstraint:
             [NSLayoutConstraint constraintWithItem:firstItem
                                          attribute:constraint.firstAttribute
                                          relatedBy:constraint.relation
                                             toItem:secondItem
                                          attribute:constraint.secondAttribute
                                         multiplier:constraint.multiplier
                                           constant:constraint.constant]];
        }
        
        return loadedView;
    }
    return self;
}
*/
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
