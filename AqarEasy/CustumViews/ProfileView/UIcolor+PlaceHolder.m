//
//  UIcolor+PlaceHolder.m
//  AqarEasy
//
//  Created by Atef on 7/25/15.
//  Copyright (c) 2015 Eng.Eman.Rezk. All rights reserved.
//

#import "UIcolor+PlaceHolder.h"



@implementation UITextField (PlaceHolderColor)

-(void)ChangePlaceHolederWithColor:(UIColor*)clr{
    if (self.placeholder) {
        
     self.attributedPlaceholder=[[NSAttributedString alloc] initWithString:self.placeholder attributes:@{NSForegroundColorAttributeName:clr}];    
    }
    
    //self.attributedPlaceholder=NSAttributedString(string: self.placeholder!, attributes: [NSForegroundColorAttributeName:color])

}

@end
