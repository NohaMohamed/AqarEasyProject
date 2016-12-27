//
//  PropertiesNearBy.h
//  AqarEasy
//
//  Created by Eng. Eman Rezk on 12/25/14.
//  Copyright (c) 2014 Eng.Eman.Rezk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PropertiesNearBy : NSObject
-(void)getPropertiesNearBywithLatitude:(NSString*)latitude Longitude:(NSString*)longitude Distance:(NSString*)distance andPath:(NSString*)path withCompletionBlock:(void(^)(NSArray *))completion;
@end
