//
//  AllAdApi.m
//  AqarEasy
//
//  Created by Eng. Eman Rezk on 12/24/14.
//  Copyright (c) 2014 Eng.Eman.Rezk. All rights reserved.
//

#import "AllAdApi.h"
#import "APIControlManager.h"
#import <AFNetworking.h>
#import "Constant.h"
#import "AqarEasyUser.h"
#import <DIOSSession.h>
//#import "DIOSNode.h"
//#import "DIOSSession.h"
@implementation AllAdApi

-(void)getAllAdwithType:(NSString*)type withCompletionBlock:(void (^)(NSArray *))completion{
    
    
    NSDictionary *parameters;
    if(type == nil)
    {
        parameters = nil;
    }
    else{
        parameters = @{@"type":type};
    }
    
     NSString *path = [NSString stringWithFormat:@"%@%@/",BASE_URL, @"adall"];
    
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:path parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
       
        completion(responseObject);

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
       completion(nil);
    }];
    
}



-(void)getData:(NSString*)path withCompletionBlock:(void (^)(NSArray *))completion{
   
    //path=[NSString stringWithFormat:@"%@%@",BASE_URL,path];
   
    
    [[DIOSSession sharedSession] sendRequestWithPath:path method:@"GET" params:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        completion(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(nil);
    }];
    
    /*
    return;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    
    
    if ([[AqarEasyUser sharedInstance] isUserLogged]) {
        [manager.requestSerializer setValue:[[AqarEasyUser sharedInstance] getSessionId] forHTTPHeaderField:@"Cookie"];
        [manager.requestSerializer setValue:[[AqarEasyUser sharedInstance] getSessionToken] forHTTPHeaderField:@"X-CSRF-Token"];
        [manager.requestSerializer setValue:[[AqarEasyUser sharedInstance] getSessionName] forHTTPHeaderField:[[AqarEasyUser sharedInstance] getSessionId]];
        
        [manager.requestSerializer setValue:[[AqarEasyUser sharedInstance] getSessionId] forHTTPHeaderField:[[AqarEasyUser sharedInstance] getSessionName]];
        
        [manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        
        
        //[manager.requestSerializer setValue:[[AqarEasyUser sharedInstance] getSessionId] forKey:[[AqarEasyUser sharedInstance] getSessionName]];
        
    }
    
    //[manager.requestSerializer setCachePolicy:NSURLRequestReturnCacheDataElseLoad];
    
    
    [manager GET:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        completion(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(nil);
    }];

    
    
    */
    
}

-(void)postData:(NSString*)path withParms:(NSDictionary*)parms andImgArray:(NSArray*)ArrImgs andCompletionBlock:(void (^)(id res))completion{
    
    
    
    
    path=[NSString stringWithFormat:@"%@%@",BASE_URL,path];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    if ([[AqarEasyUser sharedInstance] isUserLogged]) {
        
        
        [manager.requestSerializer setValue:[[AqarEasyUser sharedInstance] getSessionToken] forHTTPHeaderField:@"X-CSRF-Token"];
        [manager.requestSerializer setValue:[[AqarEasyUser sharedInstance] getSessionToken] forHTTPHeaderField:@"Set-Cookie"];
        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
        
        manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [manager.requestSerializer setTimeoutInterval:90];
       // [manager.requestSerializer setCachePolicy:NSURLRequestReloadIgnoringCacheData];
        
    }
    //manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager POST:path parameters:parms constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        for (int i; i<ArrImgs.count; i++) {
            
           // [formData appendPartWithFileData:[] name:[NSString stringWithFormat:@"img%d",i] fileName:@"field_image[]" mimeType:@"image/png"];
            [formData appendPartWithFormData:UIImagePNGRepresentation(ArrImgs[i]) name:@"field_image[]"];
        }
        
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        completion(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSData *data=error.userInfo[@"com.alamofire.serialization.response.error.data"];
        if (data.length>0) {
            NSString* newStr = [NSString stringWithUTF8String:[data bytes]];
            NSLog(@"===============%@", newStr );
        }
        completion(nil);
    }];
    
    
    
}


-(void)postData:(NSString*)path withParms:(NSDictionary*)parms andCompletionBlock:(void (^)(id res))completion{
    
    
    
    
    path=[NSString stringWithFormat:@"%@%@",BASE_URL,path];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    
    if ([[AqarEasyUser sharedInstance] isUserLogged]) {
        [manager.requestSerializer setValue:[[AqarEasyUser sharedInstance] getSessionId] forHTTPHeaderField:@"Cookie"];
        [manager.requestSerializer setValue:[[AqarEasyUser sharedInstance] getSessionToken] forHTTPHeaderField:@"X-CSRF-Token"];
        [manager.requestSerializer setValue:[[AqarEasyUser sharedInstance] getSessionName] forHTTPHeaderField:[[AqarEasyUser sharedInstance] getSessionId]];
        
        [manager.requestSerializer setValue:[[AqarEasyUser sharedInstance] getSessionId] forHTTPHeaderField:[[AqarEasyUser sharedInstance] getSessionName]];
        
        [manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        
        
        //[manager.requestSerializer setValue:[[AqarEasyUser sharedInstance] getSessionId] forKey:[[AqarEasyUser sharedInstance] getSessionName]];
        
    }
    
   // [manager.requestSerializer setCachePolicy:NSURLRequestReturnCacheDataElseLoad];
    
    
    [manager POST:path parameters:parms success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"===============%@",  responseObject);
         completion(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
       //
        NSData *data=error.userInfo[@"com.alamofire.serialization.response.error.data"];
        if (data.length>0) {
            NSString* newStr = [NSString stringWithUTF8String:[data bytes]];
            NSLog(@"===============%@", newStr );
        }
       completion(nil);
    }];
    
    
}

/*
-(void)attachImagesToNode1:(NSString*)nodeId withCompletionBlock:(void (^)(id ret))completion{

    NSString *url=[NSString stringWithFormat:@"%@node/%@/attach_file",BASE_URL,nodeId];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    if ([[AqarEasyUser sharedInstance] isUserLogged]) {
        [manager.requestSerializer setValue:[[AqarEasyUser sharedInstance] getSessionId] forHTTPHeaderField:@"Cookie"];
        [manager.requestSerializer setValue:[[AqarEasyUser sharedInstance] getSessionToken] forHTTPHeaderField:@"X-CSRF-Token"];
        [manager.requestSerializer setValue:[[AqarEasyUser sharedInstance] getSessionName] forHTTPHeaderField:[[AqarEasyUser sharedInstance] getSessionId]];
        
        [manager.requestSerializer setValue:[[AqarEasyUser sharedInstance] getSessionId] forHTTPHeaderField:[[AqarEasyUser sharedInstance] getSessionName]];
        
        [manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        
        //[manager.requestSerializer setValue:[[AqarEasyUser sharedInstance] getSessionId] forKey:[[AqarEasyUser sharedInstance] getSessionName]];
    }
    //,
    
    NSDictionary *parameters = @{@"name": @"temp",@"fileName":@"temp.jpg",@"mimetype":@"image/png",@"field_name":@"field_image",@"nid":nodeId};
    //  NSURL *filePath = [NSURL fileURLWithPath:@"file://path/to/image.png"];
    [manager POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        NSData *imageData = UIImagePNGRepresentation([UIImage imageNamed:@"test.png"]);
        //  [formData appendPartWithFileURL:filePath name:@"image" error:nil];
        [formData appendPartWithFormData:imageData name:@"files[anything]"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Success: %@", responseObject);
        completion(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        NSData *data=error.userInfo[@"com.alamofire.serialization.response.error.data"];
        if (data.length>0) {
            NSString* newStr = [NSString stringWithUTF8String:[data bytes]];
            NSLog(@"===============%@", newStr );
        }
        completion(nil);
    }];
}
*/
-(void)postDataWithUrl:(NSString*)url withParms:(NSDictionary*)parms andCompletionBlock:(void (^)(id res))completion{
    
    
    //url=[NSString stringWithFormat:@"%@%@",BASE_URL,path];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
   // [manager.requestSerializer setCachePolicy:NSURLRequestReturnCacheDataElseLoad];
    
    [manager POST:url parameters:parms success:^(AFHTTPRequestOperation *operation, id responseObject) {
        completion(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"===============%@",  error);
        completion(nil);
    }];
    
    
    
}


-(void)postDataWithUrl:(NSString*)url withParms:(NSDictionary*)parms andToken:(NSString*)token andCompletionBlock:(void (^)(id res))completion{
    
    
    //url=[NSString stringWithFormat:@"%@%@",BASE_URL,path];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
   
        // [manager.requestSerializer setValue:[[AqarEasyUser sharedInstance] getSessionId] forHTTPHeaderField:@"Cookie"];
            //  [manager.requestSerializer setValue:[[AqarEasyUser sharedInstance] getSessionName] forHTTPHeaderField:[[AqarEasyUser sharedInstance] getSessionId]];
        
    
        
    
   // NSURLCredential *credential = [NSURLCredential credentialWithUser:[url stringByAppendingString:@"ahmad151"] password:@"1234567" persistence:NSURLCredentialPersistenceNone];
    
   //manager.credential = credential;
  /*  if ([[AqarEasyUser sharedInstance] isUserLogged]) {
        
        
        [manager.requestSerializer setValue:[[AqarEasyUser sharedInstance] getSessionToken] forHTTPHeaderField:@"X-CSRF-Token"];
        [manager.requestSerializer setValue:[[AqarEasyUser sharedInstance] getSessionToken] forHTTPHeaderField:@"Set-Cookie"];
        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
        
        manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [manager.requestSerializer setTimeoutInterval:90];
      //
        
    }else{
        
        [manager.requestSerializer setValue:[[AqarEasyUser sharedInstance] getUnloggedToken] forHTTPHeaderField:@"X-CSRF-Token"];
        [manager.requestSerializer setValue:[[AqarEasyUser sharedInstance] getUnloggedToken] forHTTPHeaderField:@"Set-Cookie"];
        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
        
        manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [manager.requestSerializer setTimeoutInterval:90];
       // [manager.requestSerializer setCachePolicy:NSURLRequestReloadIgnoringCacheData];
       
        
    }
*/
    
  //   [manager.requestSerializer setValue:@"<API Key>" forHTTPHeaderField:@"X-Parse-REST-API-Key"];
   // [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];

    
   // [manager.requestSerializer setCachePolicy:NSURLRequestReturnCacheDataElseLoad];
    
    
    [manager POST:url parameters:parms success:^(AFHTTPRequestOperation *operation, id responseObject) {
        completion(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"===============%@",  error);
        NSData *data=error.userInfo[@"com.alamofire.serialization.response.error.data"];
        if (data.length>0) {
            NSString* newStr = [NSString stringWithUTF8String:[data bytes]];
            NSLog(@"===============%@", newStr );
        }

        completion(nil);
    }];
    
    
    
}

@end
