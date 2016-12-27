//
//  SDK_API_Controller.m
//  AqarEasy
//
//  Created by Atef on 5/15/15.
//  Copyright (c) 2015 Eng.Eman.Rezk. All rights reserved.
//

#import "SDK_API_Controller.h"
#import <DIOSTaxonomy.h>
#import <DIOSSession.h>

@implementation SDK_API_Controller

+ (instancetype)sharedInstance
{
    // 1
    static SDK_API_Controller *_sharedInstance = nil;
    
    // 2
    static dispatch_once_t oncePredicate;
    
    // 3
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[SDK_API_Controller alloc] init];
    });
    return _sharedInstance;
}

-(void)sendrequestWithPath:(NSString *)path andHttpMethod:(NSString*)method andParms:(NSDictionary*)parms andImgArrays:(NSArray*)ImgArr withCompletion:(void (^)(id result,NSError *error))completion{
    
    
    [[DIOSSession sharedSession] sendRequestWithPath:path method:method params:parms andImgArray:ImgArr success:^(AFHTTPRequestOperation *operation, id responseObject) {
        completion(responseObject,nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(nil,error);
    }];
}


-(void)sendrequestWithPath:(NSString *)path andHttpMethod:(NSString*)method andParms:(NSDictionary*)parms withCompletion:(void (^)(id result,NSError *error))completion{
    
    [[DIOSSession sharedSession] sendRequestWithPath:path method:method params:parms success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"get user image===============%@", operation.request.URL.absoluteString );
        completion(responseObject,nil);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //NSLog(@"===============%@",  error);
        completion(nil,error);
        
    }];
    
    /*
     - (void) sendRequestWithPath:(NSString*)path
     method:(NSString*)method
     params:(NSDictionary*)params
     success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
     failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error)) failure;

     */
    
}

-(void)getTreewithVId:(int)vid andParent:(NSString*)parent withCompletionBlock:(void (^)(NSMutableArray *resultArray,NSString* errorMessage))completion{
    
    self.reachability = [Reachability reachabilityWithHostname:@"https://www.google.com.eg/"];
    
    __weak typeof(self) weakSelf = self;
    self.reachability.reachableBlock = ^(Reachability * reachability)
    {
        [DIOSTaxonomy getTreeWithVid:[NSString stringWithFormat:@"%d",vid] withParent:parent andMaxDepth:@"1" success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSLog(@"===============%@",  operation.request.URL.absoluteString);
            //NSLog(@"######################################===========TAXSONOMY========############################");
            //NSLog(@"Taxonomy DATA===============%@",  responseObject);
            //NSLog(@"######################################===========TAXSONOMY========############################");
            
            if (responseObject &&[responseObject isKindOfClass:[NSArray class]]) {
                if ([responseObject count] >= 1) {
                    id obj0=responseObject[0];
                    if ([obj0 isKindOfClass:[NSString class]]) {
                        completion(nil,nil);
                    }else{
                        completion(responseObject,nil);
                    }
                } else {
                    completion(nil,nil);
                }
                
            }else{
                completion(nil,nil);
            }
         [weakSelf.reachability stopNotifier];
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            //NSLog(@"######################################===========TAXSONOMY========############################");
          //  NSLog(@"===============%@",  error);
            NSData *data=error.userInfo[@"com.alamofire.serialization.response.error.data"];
            if (data.length>0) {
                NSString* newStr = [NSString stringWithUTF8String:[data bytes]];
                NSLog(@"===============%@", newStr );
            }
            
            NSLog(@"######################################===========TAXSONOMY========#################//###########");
            completion(nil,nil);
            
             [weakSelf.reachability stopNotifier];
            
        }];
        
    };
    
    self.reachability.unreachableBlock = ^(Reachability * reachability)
    {
        completion(nil,@"noNetwok");
        
        [weakSelf.reachability stopNotifier];
    };
    
    [self.reachability startNotifier];
}
@end
