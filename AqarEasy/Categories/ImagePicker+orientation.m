//
//  ImagePicker+orientation.m
//  AqarEasy
//
//  Created by Atef on 8/3/15.
//  Copyright (c) 2015 Eng.Eman.Rezk. All rights reserved.
//

#import "ImagePicker+orientation.h"


@implementation UIImagePickerController(custom)
/*
 -(BOOL)shouldAutorotate
 {
 return NO;
 }*/
-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    
    if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone)
    {
        
        return  UIInterfaceOrientationPortrait;
    }else{
        return UIInterfaceOrientationLandscapeRight;
    }
    // return UIInterfaceOrientationMaskLandscapeRight;
    
    // return  UIInterfaceOrientation(UIInterfaceOrientationMaskLandscape);
}
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape|UIInterfaceOrientationMaskPortrait;
}

@end


