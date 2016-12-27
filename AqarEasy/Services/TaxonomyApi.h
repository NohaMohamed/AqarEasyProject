//
//  TaxonomyApi.h
//  AqarEasy
//
//  Created by Eng. Eman Rezk on 12/30/14.
//  Copyright (c) 2014 Eng.Eman.Rezk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TaxonomyApi : NSObject
-(void)getTreewithVId:(int)vid andParent:(NSString*)parent withCompletionBlock:(void(^)(NSMutableArray *))completion;

@end
