//
//  Constant.h
//  AqarEasy
//
//  Created by Eng. Eman Rezk on 12/25/14.
//  Copyright (c) 2014 Eng.Eman.Rezk. All rights reserved.
//

#import <Foundation/Foundation.h>



typedef enum
{
    adsTypeForSale = 659,
    adsTypeForRent = 658,
    adsTypeAll = 0
}adsType;

typedef enum
{
    
    location = 2,
    type = 3,
    contracttype = 4
}Taxonomy;

#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

#define kCArea @"area"
#define KCBedrooms @"bedrooms"
//#define KCBedrooms2 @"bedrooms"

#define KCBathrooms @"bathrooms"

#define KCDistanceToAirport @"distance_to_airport"
#define KCDistanceToAirport2 @"distance_airport"



#define KCDistanceToDwontowin @"distance_to_downtown"
//#define KCDistanceToDwontowin2 @"distance_downtown"



#define KCDistanceToHayway @"distance_to_highways"
#define KCDistanceToHayway2 @"distance_hayway"


#define KCImage @"image"
#define KCImage2 @"images"

#define KCLocationLatitude @"location_latitude"
#define KCLocationLatitude2 @"lat"

#define KCLocationLongitude @"location_longitude"
#define KCLocationLongitude2 @"lon"

#define KCNodeID @"nid"

#define KCNodeTitle @"node_title"
#define KCNodeTitle2 @"title"

#define KCPrice @"price"

#define KCType @"type"


#define KCYearBuilt @"year_built"
#define KCYearBuilt2 @"built_year"

#define KCContractType @"contract_type"

#define KCNodeAdertiserName @"author_name"

#define GOOGLE_SHORTEN_KEY @"AIzaSyAI8e2sOdO_4SrKmMfwJLSGK9NJIt43yT8"

#define BASE_URL @"http://aqareasy.com:8080/api/"

#define URL_LOGIN @"http://aqareasy.com:8080/api/user/login"
#define URL_SESSION @"http://aqareasy.com:8080/services/session/token"


typedef enum SweetAlertTypes
{
    SSucess = 0,
    SFail = 1,
    SWarning =2,
    SNone = 3
} SAlertType;


//#define URL_ADD_NODE_IMG @"http://aqareasy.com/api/nodeImage"





