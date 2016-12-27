//
//  TaxonomyApi.m
//  AqarEasy
//
//  Created by Eng. Eman Rezk on 12/30/14.
//  Copyright (c) 2014 Eng.Eman.Rezk. All rights reserved.
//

#import "TaxonomyApi.h"
#import "APIControlManager.h"
//#import "DIOSNode.h"
//#import "DIOSSession.h"
#import "Constant.h"
#import <AFNetworking.h>
#import "AqarEasyUser.h"
@implementation TaxonomyApi

-(void)getTreewithVId:(int)vid  andParent:(NSString*)parent withCompletionBlock:(void(^)(NSMutableArray *))completion{
    

    
   NSDictionary *parameters = @{@"vid": @(vid),@"parent":parent,@"maxdepth":@"1"};
    
    //AFHTTPRequestOperationManager *manger= [DIOSSession manager];
   // [manger.requestSerializer setValue:@"SrKAdP1YNL6aYEOfjkbC0n5b3iluwWWeoG4KqLa1Zfc" forHTTPHeaderField:@"Authorization"];

    NSString *path = [NSString stringWithFormat:@"%@%@/%@/",BASE_URL, @"taxonomy",@"getTree"];

    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
  
    if ([[AqarEasyUser sharedInstance] isUserLogged]) {
        [manager.requestSerializer setValue:[[AqarEasyUser sharedInstance] getSessionId] forHTTPHeaderField:@"Cookie"];
           [manager.requestSerializer setValue:[[AqarEasyUser sharedInstance] getSessionToken] forHTTPHeaderField:@"X-CSRF-Token"];
        [manager.requestSerializer setValue:[[AqarEasyUser sharedInstance] getSessionName] forHTTPHeaderField:[[AqarEasyUser sharedInstance] getSessionId]];

        [manager.requestSerializer setValue:[[AqarEasyUser sharedInstance] getSessionId] forHTTPHeaderField:[[AqarEasyUser sharedInstance] getSessionName]];

        [manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        
        
        //[manager.requestSerializer setValue:[[AqarEasyUser sharedInstance] getSessionId] forKey:[[AqarEasyUser sharedInstance] getSessionName]];
        
    }else{
        
       // [manager.requestSerializer setValue:[[AqarEasyUser sharedInstance] getUnloggedToken] forHTTPHeaderField:@"Cookie"];
       // [manager.requestSerializer setValue:[[AqarEasyUser sharedInstance] getUnloggedToken] forHTTPHeaderField:@"X-CSRF-Token"];
        //[manager.requestSerializer setValue:[[AqarEasyUser sharedInstance] getSessionName] forHTTPHeaderField:[[AqarEasyUser sharedInstance] getSessionId]];
        
     //   [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
      //  [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        
        
    }
    
    
    
    
    
    [manager POST:path parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"######################################===========TAXSONOMY========############################");
        NSLog(@"Taxonomy DATA===============%@",  responseObject);
        NSLog(@"######################################===========TAXSONOMY========############################");
        
        if (responseObject &&[responseObject isKindOfClass:[NSArray class]]) {
            if ([responseObject count] >= 1) {
                id obj0=responseObject[0];
                if ([obj0 isKindOfClass:[NSString class]]) {
                    completion(nil);
                }else{
                    completion(responseObject);
                }
            } else {
                completion(nil);
            }
            
        }else{
            completion(nil);
        }
       
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
       
        NSLog(@"######################################===========TAXSONOMY========############################");
        NSLog(@"===============%@",  error);
        NSData *data=error.userInfo[@"com.alamofire.serialization.response.error.data"];
        if (data.length>0) {
            NSString* newStr = [NSString stringWithUTF8String:[data bytes]];
            NSLog(@"===============%@", newStr );
        }

        NSLog(@"######################################===========TAXSONOMY========############################");
        completion(nil);
    }];
}

@end
