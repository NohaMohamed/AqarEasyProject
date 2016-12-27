//
//  addAqarViewModel.h
//  AqarEasy
//
//  Created by ITS Mobile Banking on 10/14/15.
//  Copyright (c) 2015 Eng.Eman.Rezk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Utility.h"
#import "APIControlManager.h"

@protocol AddAqarViewModelDelg <NSObject>
@optional
-(void)resultFromTaxsonomy:(NSArray*)arr andDiffer:(NSString*)differ;
-(void)regionFromServer:(NSArray*)arr;
-(void)getAqarTypeFromServer:(NSArray*)arr;
@end

@interface addAqarViewModel : NSObject

-(void)getDatafromServerWithTaxsonomy:(Taxonomy)Ttype andParent:(NSString*)parent;
-(void)getDatafromServerWithtype:(Taxonomy)taxsonomyType andParent:(NSString*)parent andDifeerType:(NSString*)differ;

@property(nonatomic,weak)id<AddAqarViewModelDelg>delg;
@end


