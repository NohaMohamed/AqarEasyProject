//
//  AdViewApi.h
//  AqarEasy
//
//  Created by Eng. Eman Rezk on 12/30/14.
//  Copyright (c) 2014 Eng.Eman.Rezk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AdViewApi : NSObject
-(void)getAqarInformationwithNodeID:(NSString*)nodeId withCompletionBlock:(void(^)(NSArray *))completion;
@end
