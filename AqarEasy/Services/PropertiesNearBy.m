//
//  PropertiesNearBy.m
//  AqarEasy
//
//  Created by Eng. Eman Rezk on 12/25/14.
//  Copyright (c) 2014 Eng.Eman.Rezk. All rights reserved.
//

#import "PropertiesNearBy.h"
#import "APIControlManager.h"
#import <AFNetworking.h>
#import "Constant.h"
//#import "DIOSNode.h"
//#import "DIOSSession.h"

@implementation PropertiesNearBy
-(void)getPropertiesNearBywithLatitude:(NSString*)latitude Longitude:(NSString*)longitude Distance:(NSString*)distance andPath:(NSString*)path withCompletionBlock:(void(^)(NSArray *))completion{
  

    NSDictionary *parameters = @{@"dist":[NSString stringWithFormat:@"%@,%@_%@",latitude,longitude,distance]};

    
  path = [NSString stringWithFormat:@"%@%@/",BASE_URL, path];
    

    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:path parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"===============%@", operation.request.URL.absoluteString );
        NSArray *result = (NSArray *)responseObject;
        completion(result);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        completion(nil);
    }];

    
}
@end
