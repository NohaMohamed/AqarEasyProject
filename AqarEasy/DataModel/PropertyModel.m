//
//  PropertyModel.m
//  AqarEasy
//
//  Created by Eng. Eman Rezk on 11/21/14.
//  Copyright (c) 2014 Eng.Eman.Rezk. All rights reserved.
//

#import "PropertyModel.h"
#import "Constant.h"

@implementation PropertyModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.distanceLocationModel = [[DistanceLocationModel alloc]init];
    }
    return self;
}
-(void)PropertyFromDictionary:(NSDictionary *)dic{
    
    if (![dic isKindOfClass:[NSDictionary class]]) {
        return;
    }
    
    self.ArrImages=[NSMutableArray new];
    self.showParking=NO;
   
    /*
     @property(nonatomic,strong)NSString *location_parent2_tid;
     @property(nonatomic,strong)NSString *location_parent3_tid;

     */
   
    if (dic[@"location_tid"]) {
        self.location_tid=dic[@"location_tid"];
    }else{
        self.location_tid=@"";
    }
    
    if (dic[@"location_parent_tid"]) {
        self.location_parent_tid=dic[@"location_parent_tid"];
    } else {
        self.location_parent_tid=@"";
    }
    
    if (dic[@"location_parent2_tid"]) {
        self.location_parent2_tid=dic[@"location_parent2_tid"];
    } else {
        self.location_parent2_tid=@"";
    }
    
    if (dic[@"location_parent3_tid"]) {
        self.location_parent3_tid=dic[@"location_parent3_tid"];
    } else {
        self.location_parent3_tid=@"";
    }
    
    if (dic[@"location_parent2"]) {
        self.location_parent2=dic[@"location_parent2"];
    }else{
        self.location_parent2=@"";
    }
    
    if (dic[@"location_parent3"]) {
        self.location_parent3=dic[@"location_parent3"];
    }else{
        self.location_parent3=@"";
    }
    
    if (dic[@"location"]) {
        self.location=dic[@"location"];
    }else{
        self.location=@"";
    }
    if (dic[@"location_parent"]) {
        self.location_parent=dic[@"location_parent"];
    }else{
        self.location_parent=@"";
    }
    
    if (dic[@"field_parking"]) {
        if ([dic[@"field_parking"] isKindOfClass:[NSString class]]&&[dic[@"field_parking"] isEqualToString:@"yes"]) {
            self.showParking=YES;
        }
    }
    
    if (dic[@"images_id"]) {
        
        NSArray *ArrImgs=dic[@"images_id"];
        for (NSDictionary *dicTemp in ArrImgs) {
            NSString *uri=dicTemp[@"uri"];
            uri=[uri stringByReplacingOccurrencesOfString:@"public://" withString:@""];
            [self.ArrImages addObject:@{@"fid":dicTemp[@"fid"],@"url":[NSString stringWithFormat:@"http://aqareasy.com:8080/sites/aqareasy.com/files/%@",uri]}];
        }
        
    }
    if (dic[@"uid"]) {
        self.userId=dic[@"uid"];
    }
    
    if (dic[@"description"]&&[dic[@"description"] isKindOfClass:[NSString class]]) {
        self.nodeDescription=dic[@"description"];
    } else {
        self.nodeDescription=@"";
    }
    
    if (dic[@"regoin_id"]&&[dic[@"regoin_id"] isKindOfClass:[NSString class]]) {
        self.regoin_id=dic[@"regoin_id"];
    } else {
     self.regoin_id=@"";
    }
    
    if (dic[@"aqar_type"]&&[dic[@"aqar_type"] isKindOfClass:[NSString class]]) {
        self.aqarType=dic[@"aqar_type"];
    }else{
        self.aqarType=@"";
    }
    
    if (dic[@"aqar_type_id"]&&[dic[@"aqar_type_id"] isKindOfClass:[NSDictionary class]]) {
        if (dic[@"aqar_type_id"][@"tid"]) {
            self.aqarTypeId=dic[@"aqar_type_id"][@"tid"];
        }
    } else {
        self.aqarTypeId=@"";
    }
    
    if (dic[@"contract_id"]&&[dic[@"contract_id"] isKindOfClass:[NSDictionary class]]) {
        if (dic[@"contract_id"][@"tid"]) {
            self.contract_type_id=dic[@"contract_id"][@"tid"];
        }
    } else {
        self.contract_type_id=@"";
    }
    
    if (dic[@"currency"]) {
        self.currencyName=dic[@"currency"];
        //[@{@"name":@"ريال سعودي",@"tid":@"SAR"},@{@"name":@"دولار أمريكي",@"tid":@"USD"},@{@"name":@"يورو",@"tid":@"EUR"}];
        if ([self.currencyName rangeOfString:@"ريال سعودي"].location != NSNotFound) {
            self.currencyId=@"SAR";
        } else if ([self.currencyName rangeOfString:@"يورو"].location != NSNotFound) {
            self.currencyId=@"EUR";
        } else {
            self.currencyId=@"USD";
        }
    } else {
        self.currencyName=@"";
        self.currencyId=@"";
    }
    
  //  NSLog(@"===============%@",  dic);
    if (dic[@"author_email"]&&[dic[@"author_email"] isKindOfClass:[NSString class]]) {
        self.mail= dic[@"author_email"];
    } else if(dic[@"users_node_mail"]&&[dic[@"users_node_mail"] isKindOfClass:[NSString class]]) {
        self.mail= dic[@"users_node_mail"];
    }else{
         self.mail= @"";
    }
    
    if (dic[@"author_adress"]&&[dic[@"author_adress"] isKindOfClass:[NSString class]]) {
        self.address=dic[@"author_adress"];
    } else {
        self.address=@"";
    }
    
    if (dic[@"author_phone"]&&[dic[@"author_phone"] isKindOfClass:[NSString class]]) {
        self.Mobile=dic[@"author_phone"];
    } else {
        self.Mobile=@"";
    }
    
    NSDateFormatter *formatter= [[NSDateFormatter alloc] init];
    [formatter setLocale:[NSLocale currentLocale]];
    [formatter setDateFormat:@"HH:mm-dd/MM/yyyy"];
    
    if (dic[@"node_changed"]) {
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:[dic[@"node_changed"] floatValue]];
        self.updateddate = [formatter stringFromDate:date];
    } else {
        self.updateddate = @"";
    }
    
    if (dic[@"node_created"]) {
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:[dic[@"node_created"] floatValue]];
        self.createdDate = [formatter stringFromDate:date];
    } else {
        self.createdDate = @"";
        
    }
    
    
    if([[dic objectForKey:kCArea] isKindOfClass:[NSString class]])
        self.area = [dic objectForKey:kCArea];
    else
        self.area = @"";
    
    self.nid=dic[@"nid"];
    self.url=[NSURL URLWithString:[NSString stringWithFormat:@"http://aqareasy.com:8080/node/%@",self.nid]];
    
    if([[dic objectForKey:KCBedrooms] isKindOfClass:[NSString class]])
        self.bedroomCount = [dic objectForKey:KCBedrooms];
    else
        self.bedroomCount = @"";
    
    
    if([[dic objectForKey:KCBathrooms] isKindOfClass:[NSString class]])
        self.bathroomCount = [dic objectForKey:KCBathrooms];
    else
        self.bathroomCount = @"";
    
    
    if([[dic objectForKey:KCDistanceToAirport] isKindOfClass:[NSString class]])
        self.distanceLocationModel.distanceToAirport = [dic objectForKey:KCDistanceToAirport];
    else if(dic[KCDistanceToAirport2])
        self.distanceLocationModel.distanceToAirport = dic[KCDistanceToAirport2];
    else
      self.distanceLocationModel.distanceToAirport = @"";
    
    if([[dic objectForKey:KCDistanceToDwontowin] isKindOfClass:[NSString class]])
        self.distanceLocationModel.distanceToDownTown = [dic objectForKey:KCDistanceToDwontowin];
    else
        self.distanceLocationModel.distanceToDownTown = @"";
    
    
    if([[dic objectForKey:KCDistanceToHayway] isKindOfClass:[NSString class]])
        self.distanceLocationModel.distanceToHighWay = [dic objectForKey:KCDistanceToHayway];
    else if(dic[KCDistanceToHayway2])
        self.distanceLocationModel.distanceToHighWay = [dic objectForKey:KCDistanceToHayway2];
    else
        self.distanceLocationModel.distanceToHighWay = @"";
    
    
//    self.images = [dic objectForKey:KCImage];
    self.images = [[NSMutableArray alloc]init];
    
    
    NSArray *ArrImages=[dic objectForKey:KCImage]?(NSArray*)[dic objectForKey:KCImage]:(NSArray*)[dic objectForKey:KCImage2];
    
    for(NSString *imageStr in ArrImages)
    {
        NSString * imageUrl;
        if([imageStr rangeOfString:@"src"].location !=NSNotFound)
        {
            imageUrl = [[imageStr componentsSeparatedByString:@"src=\""]objectAtIndex:1];
            imageUrl = [[imageUrl componentsSeparatedByString:@"\" "]objectAtIndex:0];
            //NSLog(@"imageUrl:%@",imageUrl);
            [self.images addObject:imageUrl];
        }else{
            [self.images addObject:imageStr];
        }
    }
    
    if (dic[KCLocationLongitude]&&[[dic objectForKey:KCLocationLongitude] isKindOfClass:[NSString class]]) {
        self.longitude = [[dic objectForKey:KCLocationLongitude] doubleValue];
    } else if(dic[KCLocationLongitude2] &&[[dic objectForKey:KCLocationLongitude] isKindOfClass:[NSString class]]){
        self.longitude = [[dic objectForKey:KCLocationLongitude2] doubleValue];
    }
    
    
    
    if (dic[KCLocationLatitude]&&[[dic objectForKey:KCLocationLatitude] isKindOfClass:[NSString class]]) {
         self.latitude = [[dic objectForKey:KCLocationLatitude] doubleValue];
        
    } else if(dic[KCLocationLatitude2]&&[[dic objectForKey:KCLocationLatitude2] isKindOfClass:[NSString class]]){
        self.latitude = [[dic objectForKey:KCLocationLatitude2] doubleValue];
        
    }

    
    
    if (dic[KCNodeAdertiserName]) {
        self.AdvertiserName=dic[KCNodeAdertiserName];
    } else {
        self.AdvertiserName=@"";
    }
    
    
    if([[dic objectForKey:KCNodeTitle] isKindOfClass:[NSString class]])
        self.nodeTitle = [dic objectForKey:KCNodeTitle];
    else if([dic[KCNodeTitle2]isKindOfClass:[NSString class]])
        self.nodeTitle = dic[KCNodeTitle2];
    else
        self.nodeTitle = @"";
    
    
    
    if([[dic objectForKey:KCPrice] isKindOfClass:[NSString class]])
        self.price = [dic objectForKey:KCPrice];
    else
        self.price = @"";
    
    
    // in response of AllAdApi contract type written as type
    if ([[dic allKeys]containsObject:KCType])
    {
        if([[dic objectForKey:KCType] isKindOfClass:[NSString class]])
            self.contractType = [dic objectForKey:KCType];
        else
            self.contractType = @"";
    }
    
    
    // in response of PropertiesNearByApi contract type written as contract_type
    if ([[dic allKeys]containsObject:KCContractType])
    {
        if([[dic objectForKey:KCContractType] isKindOfClass:[NSString class]])
            self.contractType = [dic objectForKey:KCContractType];
        else
            self.contractType = @"";
    }else if(dic[KCType]){
         self.contractType = [dic objectForKey:KCType];
    }
    
    
    if(dic[KCYearBuilt]&&[[dic objectForKey:KCYearBuilt] isKindOfClass:[NSString class]])
        self.yearBuilt = [dic objectForKey:KCYearBuilt];
    else if (dic[KCYearBuilt2]&&[[dic objectForKey:KCYearBuilt2] isKindOfClass:[NSString class]])
       self.yearBuilt=dic[KCYearBuilt2];
    else
        self.yearBuilt = @"";
    
    
    
}

@end
