//
//  ownershipDetails.h
//  AqarEasy
//
//  Created by Atef on 5/9/15.
//  Copyright (c) 2015 Eng.Eman.Rezk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ownershipDetails : UIViewController
@property(nonatomic,strong) NSDictionary *dicPassed;
@property (weak, nonatomic) IBOutlet UITextView *TXT_details;
@end
