//
//  AllAdApi.h
//  AqarEasy
//
//  Created by Eng. Eman Rezk on 12/24/14.
//  Copyright (c) 2014 Eng.Eman.Rezk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AllAdApi : NSObject
-(void)getAllAdwithType:(NSString*)type withCompletionBlock:(void(^)(NSArray *))completion;
-(void)getData:(NSString*)path withCompletionBlock:(void (^)(NSArray *))completion;
-(void)postData:(NSString*)path withParms:(NSDictionary*)parms andCompletionBlock:(void (^)(id  res))completion;
-(void)postDataWithUrl:(NSString*)url withParms:(NSDictionary*)parms andCompletionBlock:(void (^)(id res))completion;
-(void)postData:(NSString*)path withParms:(NSDictionary*)parms andImgArray:(NSArray*)ArrImgs andCompletionBlock:(void (^)(id res))completion;


-(void)postDataWithUrl:(NSString*)url withParms:(NSDictionary*)parms andToken:(NSString*)token andCompletionBlock:(void (^)(id res))completion;

//-(void)attachImagesToNode1:(NSString*)nodeId withCompletionBlock:(void (^)(id ret))completion;
@end
