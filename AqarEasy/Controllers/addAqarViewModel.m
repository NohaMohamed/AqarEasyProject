//
//  addAqarViewModel.m
//  AqarEasy
//
//  Created by ITS Mobile Banking on 10/14/15.
//  Copyright (c) 2015 Eng.Eman.Rezk. All rights reserved.
//

#import "addAqarViewModel.h"


@implementation addAqarViewModel



-(void)getDatafromServerWithtype:(Taxonomy)taxsonomyType andParent:(NSString*)parent andDifeerType:(NSString*)differ{
    [Utility showLoading];
    
    [[APIControlManager sharedInstance]getTreewithVId:taxsonomyType andParent:parent withCompletionBlock:^(NSMutableArray * resultArray, NSString *errorMessage) {
        
        switch (taxsonomyType) {
                
            case location:
                if (_delg) {
                    if ([_delg respondsToSelector:@selector(resultFromTaxsonomy:andDiffer:)]) {
                        [_delg resultFromTaxsonomy:resultArray andDiffer:differ];
                    }
                }
                /*
                if ([differ isEqualToString:@"cities"]) {
                    citiesArray=resultArray;
                    
                } else if([differ isEqualToString:@"streets"]) {
                    streetsArray=resultArray;
                    
                }else{
                    countriesArray=resultArray;
                }
                */
                break;
                
            default:
                break;
        }
        [Utility hideLoading];
        if (errorMessage) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [Utility ShowAlertWithTitle:@"" andMsg:errorMessage andType:SFail];
            });
        }
       
        
    }];
}

-(void)getDatafromServerWithTaxsonomy:(Taxonomy)Ttype andParent:(NSString*)parent{
    
    //aqarTypeArray=[NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"AqarType" ofType:@"plist"]];
    
    
    
    [Utility showLoading];
    
    
    [[APIControlManager sharedInstance]getTreewithVId:Ttype andParent:parent withCompletionBlock:^(NSMutableArray * resultArray, NSString *errorMessage) {
        //
        if (_delg) {
            if ([_delg respondsToSelector:@selector(regionFromServer:)]) {
                [_delg regionFromServer:resultArray];
            }
        }
        //        NSLog(@"locationArrayCount: %li",[locationArray count]);
        if(errorMessage == nil)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[APIControlManager sharedInstance]getTreewithVId:type andParent:@"0" withCompletionBlock:^(NSMutableArray * resultArray, NSString *errorMessage) {
                    //
                    
                    
                    if (_delg) {
                        if ([_delg respondsToSelector:@selector(getAqarTypeFromServer:)]) {
                            [_delg getAqarTypeFromServer:resultArray];
                        }
                    }
                    
                    //                NSLog(@"aqarTypeArrayCount: %li",[aqarTypeArray count]);
                    if(errorMessage == nil)
                    {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            if(errorMessage == nil)
                            {
                                
                                [Utility hideLoading];
                            }
                            else{
                                [Utility showAlert:@"عفوا" message:errorMessage];
                                [Utility hideLoading];
                            }
                        });
                        
                    }
                    else
                    {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [Utility showAlert:@"عفوا" message:@"يوجد خطأ في الاتصال بالانترنت برجاء المحاولة مرة أخري"];
                            [Utility hideLoading];
                        });
                    }
                }];
            });
            
        }
        else{
            dispatch_async(dispatch_get_main_queue(), ^{
                 [Utility hideLoading];
                [Utility showAlert:@"عفوا" message:@"يوجد خطأ في الاتصال بالانترنت برجاء المحاولة مرة أخري"];
               
            });
        }
    }];
    
    
}
@end
