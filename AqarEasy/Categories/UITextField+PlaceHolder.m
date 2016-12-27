//
//  UITextField+PlaceHolder.m
//  AqarEasy
//
//  Created by Eng. Eman Rezk on 12/1/14.
//  Copyright (c) 2014 Eng.Eman.Rezk. All rights reserved.
//

#import "UITextField+PlaceHolder.h"

@implementation UITextField (PlaceHolder)

/*
-(void)drawPlaceholderInRect:(CGRect)rect {
    
    UIColor *colour = [UIColor colorWithRed:(179/255) green:(179/255) blue:(179/255) alpha:1]; // #B3B3B3   rgb(179,179,179)
    if ([self.placeholder respondsToSelector:@selector(drawInRect:withAttributes:)])
    {
        // iOS7 and later
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.alignment = self.textAlignment;
        
        NSDictionary *attributes = @{NSForegroundColorAttributeName: colour, NSFontAttributeName: self.font , NSParagraphStyleAttributeName: paragraphStyle};
        
//        CGRect boundingRect = [self.placeholder boundingRectWithSize:rect.size options:0 attributes:attributes context:nil];
//        [self.placeholder drawAtPoint:CGPointMake(0, (rect.size.height/2)-boundingRect.size.height/2) withAttributes:attributes];
        CGRect placeholderRect = CGRectMake(rect.origin.x, (rect.size.height- self.font.lineHeight)/2, rect.size.width, self.font.lineHeight);
         [self.placeholder drawInRect:placeholderRect withAttributes:attributes];
       
    }
    else
    {
        // iOS 6
        [colour setFill];
        [self.placeholder drawInRect:rect withFont:self.font lineBreakMode:NSLineBreakByTruncatingTail alignment:self.textAlignment];
    }
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
