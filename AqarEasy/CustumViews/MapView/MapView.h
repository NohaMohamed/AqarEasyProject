//
//  MapView.h
//  AqarEasy
//
//  Created by Eng. Eman Rezk on 11/22/14.
//  Copyright (c) 2014 Eng.Eman.Rezk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "CustomAnnotation.h"

@interface MapView : UIView <MKMapViewDelegate>{
    CustomAnnotation * customAnnotation;
}

@property (strong, nonatomic) IBOutlet UIView *view;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;


- (void)gotoLocation:(CGFloat)latitude longitude:(CGFloat)longitude;
@end
