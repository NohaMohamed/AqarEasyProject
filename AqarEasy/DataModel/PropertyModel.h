//
//  PropertyModel.h
//  AqarEasy
//
//  Created by Eng. Eman Rezk on 11/21/14.
//  Copyright (c) 2014 Eng.Eman.Rezk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "DistanceLocationModel.h"


@interface PropertyModel : NSObject
@property(nonatomic,strong)NSString *Mobile;
@property(nonatomic,strong)NSString *createdDate;
@property(nonatomic,strong)NSString *updateddate;

@property(nonatomic,strong)NSString *nodeDescription;
@property(nonatomic,strong)NSString *title;
@property(nonatomic,strong)NSString *AdvertiserName;
@property(nonatomic,retain)NSString *price;
@property(nonatomic,strong)NSString *area;
@property(nonatomic,strong)NSMutableArray *images;
@property(nonatomic,strong)NSString *yearBuilt;
@property(nonatomic,strong)NSString *contractType;
@property(nonatomic,strong)NSString *bedroomCount;
@property(nonatomic,strong)NSString *bathroomCount;
@property(nonatomic,strong)NSString *parkingCount;
@property(nonatomic)CGFloat longitude;
@property(nonatomic)CGFloat latitude;
@property(nonatomic,strong)NSString *address;
@property(nonatomic,assign)BOOL isFavorite;
@property(nonatomic,strong)NSString *nid;
@property(nonatomic,strong)NSString *nodeTitle;
@property(nonatomic,strong) NSURL *url;
@property(nonatomic,strong)NSString *mail;
@property (strong,nonatomic) DistanceLocationModel * distanceLocationModel;
@property(nonatomic,strong)NSString*userId;
@property(nonatomic,strong)NSString *regoin_id;
@property(nonatomic,strong)NSString *aqarType;
@property(nonatomic,strong)NSString *aqarTypeId;
@property(nonatomic,strong)NSString *contract_type_id;
@property(nonatomic,strong)NSString *currencyId;
@property(nonatomic,strong)NSString *currencyName;
@property(nonatomic,strong)NSMutableArray *ArrImages;
@property(nonatomic,assign)BOOL showParking;
//for address
@property(nonatomic,strong)NSString *location;
@property(nonatomic,strong)NSString *location_parent;

//for edit aqar
@property(nonatomic,strong)NSString *location_tid;
@property(nonatomic,strong)NSString *location_parent_tid;
@property(nonatomic,strong)NSString *location_parent2_tid;
@property(nonatomic,strong)NSString *location_parent3_tid;

@property(nonatomic,strong)NSString *location_parent2;
@property(nonatomic,strong)NSString *location_parent3;

-(void)PropertyFromDictionary:(NSDictionary *)dic;
@end
