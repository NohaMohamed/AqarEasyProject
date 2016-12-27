//
//  NearByServiceApi.h
//  AqarEasy
//
//  Created by Eng. Eman Rezk on 24/12/14.
//  Copyright (c) 2014 Eng.Eman.Rezk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NearByServiceApi : NSString
-(void)getNearbyServicewithNodeID:(NSString*)nodeId withCompletionBlock:(void(^)(NSDictionary *))completion;
@end
