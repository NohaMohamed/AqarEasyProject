//
//  CustomAnnotation.h
//  AqarEasy
//
//  Created by Eng. Eman Rezk on 11/27/14.
//  Copyright (c) 2014 Eng.Eman.Rezk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "PropertyModel.h"
typedef enum  {
    hospital,
    shopping,
    airport,
    property
}locationType;

@interface CustomAnnotation : NSObject <MKAnnotation>

@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (copy,nonatomic) NSString *title;
@property (copy,nonatomic) NSString *subtitle;
@property (nonatomic)int type;
@property(nonatomic,strong)PropertyModel *model;
@property(nonatomic,assign)NSInteger Index;
-(id)initWithLocation:(CLLocationCoordinate2D)location;
-(MKAnnotationView *)annotationView;

@end

@interface CustomAnnotaionView : MKAnnotationView
@property(nonatomic,strong)CustomAnnotation *customAnnot;
@end