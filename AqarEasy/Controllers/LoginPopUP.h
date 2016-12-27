//
//  LoginPopUP.h
//  AqarEasy
//
//  Created by Atef on 3/25/15.
//  Copyright (c) 2015 Eng.Eman.Rezk. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol LoginDelg <NSObject>

@optional
-(void)UserDidLogin;

@end
@interface LoginPopUP : UIViewController<UITextFieldDelegate>

@property(nonatomic,weak)id<LoginDelg> delg;
@end
