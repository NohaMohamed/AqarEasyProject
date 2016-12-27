//
//  SDK_API_Controller.h
//  AqarEasy
//
//  Created by Atef on 5/15/15.
//  Copyright (c) 2015 Eng.Eman.Rezk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"
@interface SDK_API_Controller : NSObject
@property(strong,nonatomic) Reachability * reachability;


+ (instancetype)sharedInstance;
-(void)getTreewithVId:(int)vid andParent:(NSString*)parent withCompletionBlock:(void (^)(NSMutableArray *resultArray,NSString* errorMessage))completion;
-(void)sendrequestWithPath:(NSString *)path andHttpMethod:(NSString*)method andParms:(NSDictionary*)parms withCompletion:(void (^)(id result,NSError *error))completion;
-(void)sendrequestWithPath:(NSString *)path andHttpMethod:(NSString*)method andParms:(NSDictionary*)parms andImgArrays:(NSArray*)ImgArr withCompletion:(void (^)(id result,NSError *error))completion;

@end
