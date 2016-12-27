//
//  AqarEasyUser.m
//  AqarEasy
//
//  Created by Atef on 4/26/15.
//  Copyright (c) 2015 Eng.Eman.Rezk. All rights reserved.
//

#import "AqarEasyUser.h"

@implementation AqarEasyUser
+(instancetype)sharedInstance{
   
    static AqarEasyUser *user = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        user =[[AqarEasyUser alloc] init];
    });
 
    return user;
    
}

-(void)setLoginData:(NSDictionary*)dic{
    
    _isUserLogged=YES;
   [self setSessionId:dic[@"sessid"]];
    
    [self setSessionName:dic[@"session_name"]];
    [self setSessionToken:dic[@"token"]];
    [self setUserMail:dic[@"user"][@"mail"]];
    [self setUserName:dic[@"user"][@"name"]];
    [self setUserUid:dic[@"user"][@"uid"]];
    
    if (![dic[@"user"][@"picture"] isKindOfClass:[NSNull class]]) {
        
        if (dic[@"user"][@"picture"][@"url"]) {
            _userImgUrl=dic[@"user"][@"picture"][@"url"];
        }
    }
    
    if (![dic[@"user"][@"name"] isKindOfClass:[NSNull class]]) {
        _userProfileName=dic[@"user"][@"name"];
    }
    if (![dic[@"user"][@"field_address"] isKindOfClass:[NSNull class]]
        &&![dic[@"user"][@"field_address"] isKindOfClass:[NSArray class]]
        ) {
        if (![dic[@"user"][@"field_address"][@"und"] isKindOfClass:[NSNull class]]) {
            NSArray *arr=dic[@"user"][@"field_address"][@"und"];
            if (arr.count>0) {
                _userAddress=arr[0][@"value"];
                
            }
        }
    }
    if (![dic[@"user"][@"field_telephone"] isKindOfClass:[NSNull class]]
        &&![dic[@"user"][@"field_telephone"] isKindOfClass:[NSArray class]]) {
        
        if (![dic[@"user"][@"field_telephone"][@"und"] isKindOfClass:[NSNull class]]) {
            NSArray *arr=dic[@"user"][@"field_telephone"][@"und"];
            if (arr.count>0) {
                _userTelephone=arr[0][@"number"];
                _userCountryCode=arr[0][@"country_codes"];
            }
        }
    }
    
}

-(void)setUserUpdateData:(NSDictionary*)dic{
   
    if (![dic[@"field_address"][@"und"] isKindOfClass:[NSNull class]]) {
        NSArray *arr=dic[@"field_address"][@"und"];
        if (arr.count>0) {
            _userAddress=arr[0][@"value"];
            
        }
    }
    
    if (![dic[@"field_telephone"] isKindOfClass:[NSNull class]]
        &&![dic[@"field_telephone"] isKindOfClass:[NSArray class]]) {
        
        if (![dic[@"field_telephone"][@"und"] isKindOfClass:[NSNull class]]) {
            NSArray *arr=dic[@"field_telephone"][@"und"];
            if (arr.count>0) {
                _userTelephone=arr[0][@"number"];
                _userCountryCode=arr[0][@"country_codes"];
            }
        }
    }

    [self setUserMail:dic[@"mail"]];
    [self setUserName:dic[@"name"]];

}

-(NSString*)getUserProfileName{
    return _userProfileName;
}
-(NSString*)getUserAddress{
    return _userAddress;
}
-(NSString*)getUserTelephone{
    return _userTelephone;
}
-(NSString*)getUserCountryCode{
    return _userCountryCode;
}

-(NSString*)getUserImgUrl{
    return _userImgUrl;
}

-(NSString*)getSessionId{
    return [[NSUserDefaults standardUserDefaults] valueForKey:@"sessid"];
    //return [AqarEasyUser sharedInstance].sessid;
}
-(NSString*)getSessionName{
    
    return [[NSUserDefaults standardUserDefaults] valueForKey:@"session_name"];
    
  //  return [AqarEasyUser sharedInstance].session_name;
}
-(NSString*)getSessionToken{
    return [[NSUserDefaults standardUserDefaults] valueForKey:@"token"];
    //return [AqarEasyUser sharedInstance].token;
}

-(NSString*)getUnloggedToken{
     return [[NSUserDefaults standardUserDefaults] valueForKey:@"UnLoggedtoken"];
}
-(void)setUnloggedToken:(NSString*)token{
   
    [[NSUserDefaults standardUserDefaults] setValue:token forKey:@"UnLoggedtoken"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(NSString*)getUserMail{
    return [[NSUserDefaults standardUserDefaults] valueForKey:@"mail"];
   // return [AqarEasyUser sharedInstance].mail;
}
-(NSString*)getUserName{
    return [[NSUserDefaults standardUserDefaults] valueForKey:@"name"];
    //return [AqarEasyUser sharedInstance].name;
}
-(NSString*)getUserUid{
     return [[NSUserDefaults standardUserDefaults] valueForKey:@"uid"];
   // return [AqarEasyUser sharedInstance].uid;
}


-(void)setSessionId:(NSString*)ssid{
     [[NSUserDefaults standardUserDefaults] setValue:ssid forKey:@"sessid"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}
-(void)setSessionName:(NSString*)sname{
    
     [[NSUserDefaults standardUserDefaults] setValue:sname forKey:@"session_name"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    //  return [AqarEasyUser sharedInstance].session_name;
}
-(void)setSessionToken:(NSString*)token{
     [[NSUserDefaults standardUserDefaults] setValue:token forKey:@"token"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    //return [AqarEasyUser sharedInstance].token;
}
-(void)setUserMail:(NSString*)mail{
     [[NSUserDefaults standardUserDefaults] setValue:mail forKey:@"mail"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    // return [AqarEasyUser sharedInstance].mail;
}
-(void)setUserName:(NSString*)name{
     [[NSUserDefaults standardUserDefaults] setValue:name forKey:@"name"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    //return [AqarEasyUser sharedInstance].name;
}
-(void)setUserUid:(NSString*)uid{
     [[NSUserDefaults standardUserDefaults] setValue:uid forKey:@"uid"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    // return [AqarEasyUser sharedInstance].uid;
}

-(void)setUserLoginName:(NSString*)name{
    [[NSUserDefaults standardUserDefaults] setValue:name forKey:@"loginName"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    // return [AqarEasyUser sharedInstance].uid;
}
-(void)setUserLoginPass:(NSString*)pass{
    [[NSUserDefaults standardUserDefaults] setValue:pass forKey:@"pass"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    // return [AqarEasyUser sharedInstance].uid;
}
-(NSString*)getUserLoginName{
    return [[NSUserDefaults standardUserDefaults] valueForKey:@"loginName"];
    // return [AqarEasyUser sharedInstance].uid;
}


-(NSString*)getUserLoginPass{
    return [[NSUserDefaults standardUserDefaults] valueForKey:@"pass"];
    // return [AqarEasyUser sharedInstance].uid;
}

-(void)Logout{
    _isUserLogged=NO;
   // [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"loginName"];
   // [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"pass"];
   // [[NSUserDefaults standardUserDefaults] synchronize];

}

@end
