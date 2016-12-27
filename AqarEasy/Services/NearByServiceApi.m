//
//  NearByServiceApi.m
//  AqarEasy
//
//  Created by Eng. Eman Rezk on 24/12/14.
//  Copyright (c) 2014 Eng.Eman.Rezk. All rights reserved.
//

#import "NearbyserviceApi.h"
#import "APIControlManager.h"
#import <AFNetworking.h>
#import "Constant.h"
//#import "DIOSNode.h"
//#import "DIOSSession.h"

@implementation NearByServiceApi

-(void)getNearbyServicewithNodeID:(NSString*)nodeId withCompletionBlock:(void (^)(NSDictionary *))completion{
    
    
     NSDictionary *parameters = @{@"nid": nodeId};
    
    NSString *path = [NSString stringWithFormat:@"%@%@/",BASE_URL ,@"nearbyservice"];
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:path parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"nearby services===================%@",operation.request.URL.absoluteString);

        completion(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        completion(nil);
    }];

}
@end
