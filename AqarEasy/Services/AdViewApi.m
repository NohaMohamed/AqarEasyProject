//
//  AdViewApi.m
//  AqarEasy
//
//  Created by Eng. Eman Rezk on 12/30/14.
//  Copyright (c) 2014 Eng.Eman.Rezk. All rights reserved.
//

#import "AdViewApi.h"
#import "APIControlManager.h"
#import <AFNetworking.h>
#import "Constant.h"
//#import "DIOSNode.h"
#import <DIOSSession.h>

@implementation AdViewApi
-(void)getAqarInformationwithNodeID:(NSString*)nodeId withCompletionBlock:(void(^)(NSArray *))completion{
    
   
    
    NSDictionary *parameters = @{@"nid": nodeId};
    
    
   // NSString *path = [NSString stringWithFormat:@"%@%@/",BASE_URL, @"adview"];
    
    [[DIOSSession sharedSession] sendRequestWithPath:@"adview" method:@"GET" params:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
       // NSLog(@"get node info===================%@",operation.request.URL.absoluteString);

        NSArray *result = (NSArray *)responseObject;
        completion(result);

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(nil);
    }];
    
    
    
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    [manager GET:path parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        
//        NSArray *result = (NSArray *)responseObject;
//        completion(result);
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        
//        completion(nil);
//    }];
    
   
}
@end
