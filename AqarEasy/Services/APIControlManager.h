//
//  APIControlManager.h
//  AqarEasy
//
//  Created by Eng. Eman Rezk on 24/12/14.
//  Copyright (c) 2014 Eng.Eman.Rezk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"
@import UIKit;

@interface APIControlManager : NSString

@property(strong,nonatomic) Reachability * reachability;

+(APIControlManager*)sharedInstance;


-(void)getNearbyServicewithNodeID:(NSString*)nodeId withCompletionBlock:(void (^)(NSMutableArray *arr,NSString* errorMessage))completion;

-(void)getAllAdwithType:(NSString*)type withCompletionBlock:(void (^)(NSMutableArray *propertyArray,NSString* errorMessage))completion;

-(void)getPropertiesNearBywithLatitude:(NSString*)latitude Longitude:(NSString*)longitude Distance:(NSString*)distance andPath:(NSString*)path withCompletionBlock:(void (^)(NSMutableArray *propertyArray,NSString* errorMessage))completion;

-(void)getAqarInformationwithnNodeID:(NSString*)nodeId withCompletionBlock:(void (^)(NSMutableArray *propertyArray,NSString* errorMessage))completion;

-(void)getTreewithVId:(int)vid andParent:(NSString*)parent withCompletionBlock:(void (^)(NSMutableArray *resultArray,NSString* errorMessage))completion;

-(void)getData:(NSString*)path withCompletionBlock:(void (^)(NSMutableArray *propertyArray,NSString* errorMessage))completion;


//-(void)attachImagesToNode:(NSString*)nodeId withCompletionBlock:(void (^)(id ret))completion;

-(void)postData:(NSString*)path withParms:(NSDictionary*)postedParms withCompletionBlock:(void (^)(id ret))completion;
-(void)getDataWithPath:(NSString*)path withCompletionBlock:(void (^)(id ret))completion;

-(void)postData:(NSString *)path withParms:(NSDictionary *)postedParms andImgArray:(NSArray*)ArrImgs withCompletionBlock:(void (^)(id))completion;

-(void)postDataWithUrl:(NSString*)url withParms:(NSDictionary*)postedParms withCompletionBlock:(void (^)(id ret))completion;

-(void)postDataWithUrl:(NSString*)url withParms:(NSDictionary*)postedParms andToken:(NSString*)token withCompletionBlock:(void (^)(id ret))completion;

-(void)nativePostWithUrl:(NSString*)url withParms:(NSDictionary*)postedParms andImg:(UIImage*)img withImgKeyName:(NSString*)imgKeyName withCompletionBlock:(void (^)(id ret))completion;

-(void)nativePostWithUrl:(NSString*)url withParms:(NSDictionary*)postedParms withCompletionBlock:(void (^)(id ret))completion;

-(void)nativePostWithUrl2:(NSString*)url withParms:(NSDictionary*)postedParms withCompletionBlock:(void (^)(id ret))completion;

-(void)uploadImg:(UIImage*)img withImgKeyName:(NSString*)keyName andParms:(NSDictionary*)parms andUrl:(NSString*)url withCompletionBlock:(void (^)(id ret))completion;

- (NSString *)percentEscapeString:(NSString *)string;

-(void)nativePostWithUrl:(NSString*)url withParms:(NSDictionary*)postedParms andImgs:(NSArray*)imgs withCompletionBlock:(void (^)(id ret))completion;

@end
