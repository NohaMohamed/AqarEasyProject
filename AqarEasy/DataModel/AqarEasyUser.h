//
//  AqarEasyUser.h
//  AqarEasy
//
//  Created by Atef on 4/26/15.
//  Copyright (c) 2015 Eng.Eman.Rezk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AqarEasyUser : NSObject

@property(nonatomic,assign)BOOL isUserLogged;


+(instancetype)sharedInstance;
-(void)setLoginData:(NSDictionary*)dic;
-(void)setUserUpdateData:(NSDictionary*)dic;

@property(nonatomic,strong)NSString* userImgUrl;
@property(nonatomic,strong)NSString* userProfileName;
@property(nonatomic,strong)NSString* userAddress;
@property(nonatomic,strong)NSString* userTelephone;
@property(nonatomic,strong)NSString* userCountryCode;

-(NSString*)getUserProfileName;
-(NSString*)getUserAddress;
-(NSString*)getUserTelephone;
-(NSString*)getUserCountryCode;
-(NSString*)getUserImgUrl;
-(NSString*)getUserLoginName;
-(NSString*)getUserLoginPass;
    
    
-(NSString*)getSessionId;
-(NSString*)getSessionName;
-(NSString*)getSessionToken;
-(NSString*)getUserMail;
-(NSString*)getUserName;
-(NSString*)getUserUid;
-(void)setUserLoginName:(NSString*)name;
-(void)setUserLoginPass:(NSString*)pass;

-(NSString*)getUnloggedToken;
-(void)setUnloggedToken:(NSString*)token;
-(void)Logout;

@end
