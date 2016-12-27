//
//  APIControlManager.m
//  AqarEasy
//
//  Created by Eng. Eman Rezk on 24/12/14.
//  Copyright (c) 2014 Eng.Eman.Rezk. All rights reserved.
//

#import "APIControlManager.h"
#import "NearbyserviceApi.h"
//#import "DIOSSession.h"
#import "AllAdApi.h"
#import "PropertyModel.h"
#import "PropertiesNearBy.h"
#import "AdViewApi.h"
#import "TaxonomyApi.h"
//#import <DIOSUser.h>
#import <AFNetworking.h>
#import "Constant.h"
#import "SDK_API_Controller.h"
#import <DIOSSession.h>
#import "NSDictionary+UrlEncoding.h"
#import "AqarEasyUser.h"
@implementation APIControlManager

@synthesize reachability;

dispatch_queue_t myQueue;

+ (APIControlManager*)sharedInstance
{
    // 1
    static APIControlManager *_sharedInstance = nil;
    
    // 2
    static dispatch_once_t oncePredicate;
    
    // 3
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[APIControlManager alloc] init];
    });
    return _sharedInstance;
}


- (id)init
{
    self = [super init];
    if (self) {
      //  DIOSSession *sharedSession = [DIOSSession sharedSession];
        //[sharedSession setBaseURL:[NSURL URLWithString:@"http://aqareasy.com/api/"]];
      //  [DrupalAPIManager sharedDrupalAPIManager].baseURL = [NSURL URLWithString:@"http://aqareasy.com/api/"];
        //[sharedSession setBasicAuthCredsWithUsername:@"admin" andPassword:@"pass"];

    }
    return self;
}


-(void)getNearbyServicewithNodeID:(NSString*)nodeId withCompletionBlock:(void (^)(NSMutableArray *arr ,NSString* errorMessage))completion{
   
    reachability = [Reachability reachabilityWithHostname:@"https://www.google.com.eg/"];

   __block BOOL runOnce=YES;
    __weak typeof(self) weakSelf = self;
    reachability.reachableBlock = ^(Reachability * reachability)
    {
        if (!runOnce)return ;
        runOnce=NO;
        
        NearByServiceApi *nearByServiceApi = [[NearByServiceApi alloc]init];
        [nearByServiceApi getNearbyServicewithNodeID:nodeId withCompletionBlock:^(NSDictionary* dic){
         completion((NSMutableArray*)dic,nil);
            [weakSelf.reachability stopNotifier];
        }];
       
    };
    
    reachability.unreachableBlock = ^(Reachability * reachability)
    {
        completion(nil,@"noNetwok");
        
        [weakSelf.reachability stopNotifier];
    };
    
    [reachability startNotifier];
}

-(void)getData:(NSString*)path withCompletionBlock:(void (^)(NSMutableArray *propertyArray,NSString* errorMessage))completion{
    reachability = [Reachability reachabilityWithHostname:@"https://www.google.com.eg/"];
    
    __weak typeof(self) weakSelf = self;
   __block BOOL runOnce=YES;
    reachability.reachableBlock = ^(Reachability * reachability1)
    {
        
        if (!runOnce)return ;
        runOnce=NO;
        
            AllAdApi *allAdApi = [[AllAdApi alloc]init];
        [allAdApi getData:path withCompletionBlock:^(NSArray* result){
            
            
            NSMutableArray *propertyArray = [NSMutableArray array];
            if ([result isKindOfClass:[NSDictionary class]]) {
                 NSDictionary *returnedData=(NSDictionary*)result;
                if ([returnedData isKindOfClass:[NSDictionary class]]) {
                    for(NSString *key in returnedData)
                    {
                        PropertyModel * propertyModel = [[PropertyModel alloc]init];
                        [propertyModel PropertyFromDictionary:returnedData[key]];
                        [propertyArray addObject:propertyModel];
                    }
                    
                }
                
                
            } else {
                for(NSDictionary *dic in result)
                {
                    PropertyModel * propertyModel = [[PropertyModel alloc]init];
                    [propertyModel PropertyFromDictionary:dic];
                    [propertyArray addObject:propertyModel];
                }

            }
            completion(propertyArray,nil);
            [weakSelf.reachability stopNotifier];
            [reachability1 stopNotifier];
        }];
        
    };
    
    reachability.unreachableBlock = ^(Reachability * reachability)
    {
        completion(nil,@"noNetwok");
        
        [weakSelf.reachability stopNotifier];
    };
    
    [reachability startNotifier];
    
}



-(void)getAllAdwithType:(NSString*)type withCompletionBlock:(void (^)(NSMutableArray *propertyArray,NSString* errorMessage))completion{
    
    reachability = [Reachability reachabilityWithHostname:@"https://www.google.com.eg/"];
    __block BOOL runOnce=YES;
    __weak typeof(self) weakSelf = self;
    reachability.reachableBlock = ^(Reachability * reachability)
    {
        if (!runOnce)return ;
        runOnce=NO;
        
        AllAdApi *allAdApi = [[AllAdApi alloc]init];
        [allAdApi getAllAdwithType:type withCompletionBlock:^(NSArray* result){
            NSMutableArray *propertyArray = [NSMutableArray array];
            for(NSDictionary *dic in result)
            {
                PropertyModel * propertyModel = [[PropertyModel alloc]init];
                [propertyModel PropertyFromDictionary:dic];
                [propertyArray addObject:propertyModel];
            }
            completion(propertyArray,nil);
            [weakSelf.reachability stopNotifier];
        }];
        
    };
    
    reachability.unreachableBlock = ^(Reachability * reachability)
    {
        completion(nil,@"noNetwok");
        
        [weakSelf.reachability stopNotifier];
    };
    
    [reachability startNotifier];
}



-(void)getPropertiesNearBywithLatitude:(NSString*)latitude Longitude:(NSString*)longitude Distance:(NSString*)distance andPath:(NSString*)path withCompletionBlock:(void (^)(NSMutableArray *propertyArray,NSString* errorMessage))completion{
    
    reachability = [Reachability reachabilityWithHostname:@"https://www.google.com.eg/"];
    __block BOOL runOnce=YES;
    
    __weak typeof(self) weakSelf = self;
    reachability.reachableBlock = ^(Reachability * reachability)
    {
        if (!runOnce)return ;
        runOnce=NO;
        
        PropertiesNearBy *propertiesNearByApi = [[PropertiesNearBy alloc]init];
        [propertiesNearByApi getPropertiesNearBywithLatitude:latitude Longitude:longitude Distance:distance andPath:path withCompletionBlock:^(NSArray * result) {
            NSMutableArray *propertyArray = [NSMutableArray array];
            for(NSDictionary *dic in result)
            {
                PropertyModel * propertyModel = [[PropertyModel alloc]init];
                [propertyModel PropertyFromDictionary:dic];
                [propertyArray addObject:propertyModel];
            }
            completion(propertyArray,nil);
            [weakSelf.reachability stopNotifier];
        }];
    };
    
    reachability.unreachableBlock = ^(Reachability * reachability)
    {
        completion(nil,@"noNetwok");
        
        [weakSelf.reachability stopNotifier];
    };
    
    [reachability startNotifier];
}


-(void)getAqarInformationwithnNodeID:(NSString*)nodeId withCompletionBlock:(void (^)(NSMutableArray *propertyArray,NSString* errorMessage))completion{
    
    reachability = [Reachability reachabilityWithHostname:@"https://www.google.com.eg/"];
    
    __block BOOL runOnce=YES;
    __weak typeof(self) weakSelf = self;
    reachability.reachableBlock = ^(Reachability * reachability)
    {
        if (!runOnce)return ;
        runOnce=NO;
        
        AdViewApi *adViewApi = [[AdViewApi alloc]init];
        [adViewApi getAqarInformationwithNodeID:nodeId withCompletionBlock:^(NSArray* result){
           
            NSMutableArray *propertyArray = [NSMutableArray array];
            for(NSDictionary *dic in result)
            {
                PropertyModel * propertyModel = [[PropertyModel alloc]init];
                [propertyModel PropertyFromDictionary:dic];
                [propertyArray addObject:propertyModel];
            }
            completion(propertyArray,nil);
            [weakSelf.reachability stopNotifier];
        }];
        
    };
    
    reachability.unreachableBlock = ^(Reachability * reachability)
    {
        completion(nil,@"noNetwok");
        
        [weakSelf.reachability stopNotifier];
    };
    
    [reachability startNotifier];
}


-(void)getTreewithVId:(int)vid andParent:(NSString*)parent withCompletionBlock:(void (^)(NSMutableArray *resultArray,NSString* errorMessage))completion{
    
    [[SDK_API_Controller sharedInstance] getTreewithVId:vid andParent:parent withCompletionBlock:^(NSMutableArray *resultArray, NSString *errorMessage) {
        completion(resultArray,errorMessage);
    }];
    
       /* reachability = [Reachability reachabilityWithHostname:@"https://www.google.com.eg/"];
        
        __weak typeof(self) weakSelf = self;
        reachability.reachableBlock = ^(Reachability * reachability)
        {
            TaxonomyApi *taxonomyApi = [[TaxonomyApi alloc]init];
            [taxonomyApi getTreewithVId:vid andParent:parent withCompletionBlock:^(NSMutableArray* result){
                completion(result,nil);
                [weakSelf.reachability stopNotifier];
            }];
            
        };
        
        reachability.unreachableBlock = ^(Reachability * reachability)
        {
            completion(nil,@"noNetwok");
            
            [weakSelf.reachability stopNotifier];
        };
        
        [reachability startNotifier];*/
}


-(void)postData:(NSString *)path withParms:(NSDictionary *)postedParms andImgArray:(NSArray*)ArrImgs withCompletionBlock:(void (^)(id))completion{
    
    reachability = [Reachability reachabilityWithHostname:@"https://www.google.com.eg/"];
    
    __block BOOL runOnce=YES;
    __weak typeof(self) weakSelf = self;
    reachability.reachableBlock = ^(Reachability * reachability)
    {
        if (!runOnce)return ;
        runOnce=NO;
        
        
        AllAdApi *allAdApi = [[AllAdApi alloc]init];
        [allAdApi postData:path withParms:postedParms andImgArray:ArrImgs andCompletionBlock:^(NSArray * result) {
            
            completion(result);
            [weakSelf.reachability stopNotifier];
            
        }];
        
        
    };
    
    reachability.unreachableBlock = ^(Reachability * reachability)
    {
        completion(nil);
        
        [weakSelf.reachability stopNotifier];
    };
    
    [reachability startNotifier];
}

-(void)postData:(NSString*)path withParms:(NSDictionary*)postedParms withCompletionBlock:(void (^)(id ret))completion{
    
    reachability = [Reachability reachabilityWithHostname:@"https://www.google.com.eg/"];
    __block BOOL runOnce=YES;
    
    __weak typeof(self) weakSelf = self;
    reachability.reachableBlock = ^(Reachability * reachability)
    {
        if (!runOnce)return ;
        runOnce=NO;
        
        AllAdApi *allAdApi = [[AllAdApi alloc]init];
        [allAdApi postData:path withParms:postedParms andCompletionBlock:^(NSArray * result) {
            
            completion(result);
            [weakSelf.reachability stopNotifier];
            
        }];
        
        
    };
    
    reachability.unreachableBlock = ^(Reachability * reachability)
    {
        completion(nil);
        
        [weakSelf.reachability stopNotifier];
    };
    
    [reachability startNotifier];
    
}

/*
-(void)attachImagesToNode:(NSString*)nodeId withCompletionBlock:(void (^)(id ret))completion{
    reachability = [Reachability reachabilityWithHostname:@"https://www.google.com.eg/"];
    
    //__weak typeof(self) weakSelf = self;
   // reachability.reachableBlock = ^(Reachability * reachability)
   // {
        AllAdApi *allAdApi = [[AllAdApi alloc]init];
        [allAdApi attachImagesToNode1:nodeId withCompletionBlock:^(id ret) {
            completion(ret);
          //  [weakSelf.reachability stopNotifier];
        }];
        
   /// };
    
//    reachability.unreachableBlock = ^(Reachability * reachability)
//    {
//        completion(nil);
//        
//        [weakSelf.reachability stopNotifier];
//    };
//    
//    [reachability startNotifier];

}
*/

-(void)getDataWithPath:(NSString*)path withCompletionBlock:(void (^)(id ret))completion{
    
    reachability = [Reachability reachabilityWithHostname:@"https://www.google.com.eg/"];
    
    __block BOOL runOnce=YES;
    
    __weak typeof(self) weakSelf = self;
    reachability.reachableBlock = ^(Reachability * reachability)
    {
        if (!runOnce)return ;
        runOnce=NO;
        
        AllAdApi *allAdApi = [[AllAdApi alloc]init];
        [allAdApi getData:path withCompletionBlock:^(NSArray * result) {
        
            completion(result);
            [weakSelf.reachability stopNotifier];
            
        }];
        
        
    };
    
    reachability.unreachableBlock = ^(Reachability * reachability)
    {
        completion(nil);
        
        [weakSelf.reachability stopNotifier];
    };
    
    [reachability startNotifier];
    
}

-(void)postDataWithUrl:(NSString*)url withParms:(NSDictionary*)postedParms withCompletionBlock:(void (^)(id ret))completion{
    
    reachability = [Reachability reachabilityWithHostname:@"https://www.google.com.eg/"];
    
    __block BOOL runOnce=YES;
    
    __weak typeof(self) weakSelf = self;
    reachability.reachableBlock = ^(Reachability * reachability)
    {
        if (!runOnce)return ;
        runOnce=NO;
        
        
        AllAdApi *allAdApi = [[AllAdApi alloc]init];
        
        [allAdApi postDataWithUrl:url withParms:postedParms andCompletionBlock:^(NSArray * res) {
            
            completion(res);
            [weakSelf.reachability stopNotifier];
            
        }];
        
        
    };
    
    reachability.unreachableBlock = ^(Reachability * reachability)
    {
        completion(nil);
        
        [weakSelf.reachability stopNotifier];
    };
    
    [reachability startNotifier];
    
}
-(void)postDataWithUrl:(NSString*)url withParms:(NSDictionary*)postedParms andToken:(NSString*)token withCompletionBlock:(void (^)(id ret))completion{
    
    reachability = [Reachability reachabilityWithHostname:@"https://www.google.com.eg/"];
    
    __block BOOL runOnce=YES;
    
    __weak typeof(self) weakSelf = self;
    reachability.reachableBlock = ^(Reachability * reachability)
    {
        if (!runOnce)return ;
        runOnce=NO;
      
        
        AllAdApi *allAdApi = [[AllAdApi alloc]init];
        
        [allAdApi postDataWithUrl:url withParms:postedParms andToken:token andCompletionBlock:^(NSArray * res) {
            
            completion(res);
            [weakSelf.reachability stopNotifier];
            
        }];
        
        
    };
    
    reachability.unreachableBlock = ^(Reachability * reachability)
    {
        completion(nil);
        
        [weakSelf.reachability stopNotifier];
    };
    
    [reachability startNotifier];
    
}



-(void)uploadImg:(UIImage*)img withImgKeyName:(NSString*)keyName andParms:(NSDictionary*)parms andUrl:(NSString*)url withCompletionBlock:(void (^)(id ret))completion{
    
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
    
    
    if ([DIOSSession sharedSession].csrfToken) {
        
        [manager.requestSerializer setValue:[DIOSSession sharedSession].csrfToken forHTTPHeaderField:@"X-CSRF-Token"];
    }
    
    
    NSData *imageData;
    
    if(img)imageData=UIImageJPEGRepresentation(img, 0.5);
    
    AFHTTPRequestOperation *op = [manager POST:url parameters:parms constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        //do not put image inside parameters dictionary as I did, but append it!
        if(imageData)[formData appendPartWithFileData:imageData name:keyName fileName:@"img0.jpg" mimeType:@"image/jpeg"];
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
       // NSLog(@"Success: %@ ***** %@", operation.responseString, responseObject);
        
        completion(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
       // NSLog(@"Error: %@ ***** %@", operation.responseString, error);
        completion(error);
    }];
    [op start];
    
}

-(void)nativePostWithUrl:(NSString*)url withParms:(NSDictionary*)postedParms andImg:(UIImage*)img withImgKeyName:(NSString*)imgKeyName withCompletionBlock:(void (^)(id ret))completion{
    
   
    NSMutableURLRequest *request =  [NSMutableURLRequest
                                     requestWithURL:[NSURL URLWithString:url]
                                     cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:300];
    
    
    NSString *myboundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",myboundary];
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];

    //[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"POST"];
    
    // [request setTimeoutInterval:1000];
    
    if ([DIOSSession sharedSession].csrfToken) {
        
        [request setValue:[DIOSSession sharedSession].csrfToken forHTTPHeaderField:@"X-CSRF-Token"];
    }
    
    [request setHTTPBody:[self formatParms:postedParms andImage:img withImgKeyName:imgKeyName]];
    
    //[request setHTTPBody:data];
    
    // NSLog(@"===============%@",[self httpBodyForParamsDictionary:postedParms]  );
    
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        if (data) {
            id ret=  [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            completion(ret);
        } else {
            completion(nil);
        }
        if (connectionError) {
            NSLog(@"===============%@",  connectionError);
        }
    }];
    
    
}


-(NSMutableData*)formatParms:(NSDictionary*)dicParms andImage:(UIImage*)img withImgKeyName:(NSString*)imgKey{
    
    NSMutableData *body = [NSMutableData data];
    NSString *myboundary = @"---------------------------14737809831466499882746641449";
   // NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",myboundary];
    
    // file
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", myboundary] dataUsingEncoding:NSUTF8StringEncoding]];
    //[body appendData:[@"Content-Disposition: attachment; name=\"picture\"; filename=\".jpg\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: attachment; %@=\"%@\"; filename=\".jpg\"\r\n",imgKey,imgKey] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[NSData dataWithData:UIImageJPEGRepresentation(img, 0.5)]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    for (NSString *key in dicParms) {
        // text parameter
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", myboundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",key] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[dicParms valueForKey:key] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
    }
    
    return body;

}

#pragma - mark
#pragma - mark post without afnteworking

-(void)nativePostWithUrl2:(NSString*)url withParms:(NSDictionary*)postedParms withCompletionBlock:(void (^)(id ret))completion{
    
    
    
    /*
    [[DIOSSession sharedSession] sendRequestWithURL:url method:@"POST" params:postedParms success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        completion(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(nil);
    }];
    
    return;*/

    
    // NSURLRequest *req=[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:]];
    
    // NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSMutableURLRequest *request =  [NSMutableURLRequest
                                     requestWithURL:[NSURL URLWithString:url]
                                     cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:300];
    
    
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];

    // [request setTimeoutInterval:1000];
    
    if ([DIOSSession sharedSession].csrfToken) {
        
        [request setValue:[DIOSSession sharedSession].csrfToken forHTTPHeaderField:@"X-CSRF-TOKEN"];
        
       
    }

     //NSString *str=[postedParms urlEncodedString];
     //NSData *data=[str dataUsingEncoding:NSUTF8StringEncoding];
    
    [request setHTTPBody:[self httpBodyForParamsDictionary:postedParms]];
    
    
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        if (data) {
            id ret=  [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            completion(ret);
        } else {
            completion(nil);
        }
        if (connectionError) {
            completion(nil);
        }
    }];
    
    
}




-(void)nativePostWithUrl:(NSString*)url withParms:(NSDictionary*)postedParms andImgs:(NSArray*)imgs withCompletionBlock:(void (^)(id ret))completion{
    
    
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:@"http://aqareasy.com/api/"]];
   
    
    manager.requestSerializer.timeoutInterval=300;
    
    
    if ([DIOSSession sharedSession].csrfToken) {
        
        [manager.requestSerializer setValue:[DIOSSession sharedSession].csrfToken forHTTPHeaderField:@"X-CSRF-Token"];
       // [manager.requestSerializer setValue:[[AqarEasyUser sharedInstance] getSessionId] forHTTPHeaderField:@"sessionid"];
        [manager.requestSerializer setValue:[[AqarEasyUser sharedInstance] getSessionId] forHTTPHeaderField:@"session_name"];
        
        /*
         
         [manager.requestSerializer setValue:[[AqarEasyUser sharedInstance] getSessionId] forHTTPHeaderField:@"Cookie"];
         [manager.requestSerializer setValue:[[AqarEasyUser sharedInstance] getSessionToken] forHTTPHeaderField:@"X-CSRF-Token"];
         [manager.requestSerializer setValue:[[AqarEasyUser sharedInstance] getSessionName] forHTTPHeaderField:[[AqarEasyUser sharedInstance] getSessionId]];
         
         [manager.requestSerializer setValue:[[AqarEasyUser sharedInstance] getSessionId] forHTTPHeaderField:[[AqarEasyUser sharedInstance] getSessionName]];
         
         [manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
         [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
         
         
         //[manager.requestSerializer setValue:[[AqarEasyUser sharedInstance] getSessionId] forKey:[[AqarEasyUser sharedInstance] getSessionName]];
         */
        
        
        
    }
    
    AFHTTPRequestOperation *op = [manager POST:@"addAqarWithImages" parameters:postedParms constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        for (NSDictionary *dic in imgs) {
            
             NSData *imageData = UIImageJPEGRepresentation(dic[@"img"], 0.5);
             [formData appendPartWithFileData:imageData name:@"images[]" fileName:@"images[]" mimeType:@"image/jpeg"];
            
        }
       
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Success: %@ ***** %@", operation.responseString, responseObject);
        completion(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@ ***** %@", operation.responseString, error);
        
        NSData *data=error.userInfo[@"com.alamofire.serialization.response.error.data"];
        if (data.length>0) {
            NSString* newStr = [NSString stringWithUTF8String:[data bytes]];
            NSLog(@"===============%@", newStr );
        }

        
        completion(error);
    }];
    [op start];
    
    
    
    
    
    return;
    // NSDictionary *postedSearchData=@{@"contract_type":@"659",@"price_from":@"10000",@"price_to":@"10000000",@"type":@"631",@"region":@"7",@"bedrooms":@"3",@"bathrooms":@"\"2\""};
    
    // NSURLRequest *req=[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:]];
    
    // NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSMutableURLRequest *request =  [NSMutableURLRequest
                                     requestWithURL:[NSURL URLWithString:url]
                                     cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:300];
    
    
    [request setValue:@"multipart/form-data" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"POST"];
    
    // [request setTimeoutInterval:1000];
    
    if ([DIOSSession sharedSession].csrfToken) {
        
        [request setValue:[DIOSSession sharedSession].csrfToken forHTTPHeaderField:@"X-CSRF-Token"];
    }
    
    NSMutableData *body=[NSMutableData new];//dataWithData:[self httpBodyForParamsDictionary:postedParms]];
    
    
    for (NSString *param in postedParms) {
        [body appendData:[[NSString stringWithFormat:@"--\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", param] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@\r\n", [postedParms objectForKey:param]] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    
    for (int i=0;i< imgs.count;i++) {
        NSData *imageData = UIImagePNGRepresentation(imgs[i][@"img"]);
       // NSData *imageData1 = UIImagePNGRepresentation(imgs[i][@"img"]);
       // NSString *base64Image1 =[[DIOSSession sharedSession] getbase64FromData:imageData1];
       // NSData *imageData = UIImageJPEGRepresentation(img, 1.0);
        if (imageData) {
            [body appendData:[[NSString stringWithFormat:@"--\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"image.jpg\"\r\n", @"images[]"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:imageData];
            [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        }

        
    }
    // add image data
   
    
    
    
    [request setHTTPBody:body];
    

    
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        if (data) {
            NSString *str=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"===================%@",str);

            NSError *er;
            id ret=  [NSJSONSerialization JSONObjectWithData:data options:0 error:&er];
            completion(ret);
        } else {
            completion(nil);
        }
        if (connectionError) {
            NSLog(@"===============%@",  connectionError);
        }
    }];
    
    
}


-(void)nativePostWithUrl:(NSString*)url withParms:(NSDictionary*)postedParms withCompletionBlock:(void (^)(id ret))completion{
    
   // NSDictionary *postedSearchData=@{@"contract_type":@"659",@"price_from":@"10000",@"price_to":@"10000000",@"type":@"631",@"region":@"7",@"bedrooms":@"3",@"bathrooms":@"\"2\""};
    
    // NSURLRequest *req=[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:]];
    
   // NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
   NSMutableURLRequest *request =  [NSMutableURLRequest
     requestWithURL:[NSURL URLWithString:url]
     cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:300];

    
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"POST"];
    
   // [request setTimeoutInterval:1000];

    if ([DIOSSession sharedSession].csrfToken) {
        
        [request setValue:[DIOSSession sharedSession].csrfToken forHTTPHeaderField:@"X-CSRF-Token"];
    }
    
    [request setHTTPBody:[self httpBodyForParamsDictionary:postedParms]];
    
    NSLog(@"===============%@",[self httpBodyForParamsDictionary:postedParms]  );
    
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        if (data) {
            id ret=  [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            completion(ret);
        } else {
            completion(nil);
        }
        if (connectionError) {
            NSLog(@"===============%@",  connectionError);
        }
    }];
    
    
}




- (NSData *)httpBodyForParamsDictionary:(NSDictionary *)paramDictionary
{
    NSMutableArray *parameterArray = [NSMutableArray array];
    
    [paramDictionary enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *obj, BOOL *stop) {
        NSString *param = [NSString stringWithFormat:@"%@=%@", key, [self percentEscapeString:obj]];
        [parameterArray addObject:param];
    }];
    
    NSString *string = [parameterArray componentsJoinedByString:@"&"];
    
    return [string dataUsingEncoding:NSUTF8StringEncoding];
}
- (NSString *)percentEscapeString:(NSString *)string
{
    string=[NSString stringWithFormat:@"%@",string];
    NSString *result = CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                 (CFStringRef)string,
                                                                                 (CFStringRef)@" ",
                                                                                 (CFStringRef)@":/?@!$&'()*+,;=",
                                                                                 kCFStringEncodingUTF8));
    return [result stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
}



@end
