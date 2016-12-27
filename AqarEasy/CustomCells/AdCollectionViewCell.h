//
//  AdCollectionViewCell.h
//  AqarEasy
//
//  Created by Eng. Eman Rezk on 11/21/14.
//  Copyright (c) 2014 Eng.Eman.Rezk. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "SummaryViewiPhone.h"
#import "SummaryViewiPad.h"

#import "PropertyModel.h"
#import <CADRACSwippableCell.h>

@interface AdCollectionViewCell : CADRACSwippableCell
@property (weak, nonatomic) IBOutlet SummaryViewiPhone *summaryView;
@property (weak, nonatomic) IBOutlet SummaryViewiPad *summaryViewiPad;


-(void)setData:(PropertyModel*)propertyInfo;
@end
