//
//  MapView.m
//  AqarEasy
//
//  Created by Eng. Eman Rezk on 11/22/14.
//  Copyright (c) 2014 Eng.Eman.Rezk. All rights reserved.
//

#import "MapView.h"
#import "CustomAnnotation.h"

@implementation MapView
#define METERS_PER_MILE 1609.344

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        //Initialize code
    }
    return self;
}

-(id)init{
    self = [super init];
    if(self){
        
        // 1.load the interface file from .xib
        [[NSBundle mainBundle] loadNibNamed:@"MapView" owner:self options:nil];
        
        CGRect frame = self.view.frame;
        frame.size = self.frame.size;
        self.view.frame = frame;
        
        // 2.Add as a subview
        [self addSubview:self.view];
      //  [self addSIngleTab];
        
    }
    return self;
}
-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self){
        
        // 1.load the interface file from .xib
        [[NSBundle mainBundle] loadNibNamed:@"MapView" owner:self options:nil];
        
        CGRect frame = self.view.frame;
        frame.size = self.frame.size;
        self.view.frame = frame;
        
        // 2.Add as a subview
        [self addSubview:self.view];
        //[self addSIngleTab];

    }
    return self;
}

-(void)getLocation{

}


-(void)addSIngleTab{
    UITapGestureRecognizer *lpgr = [[UITapGestureRecognizer alloc]
                                    initWithTarget:self action:@selector(handleTabPress:)];
    // lpgr.minimumPressDuration = 1.0; //user needs to press for 2 seconds
    [self.mapView addGestureRecognizer:lpgr];
    
}


- (void)handleTabPress:(UIGestureRecognizer *)gestureRecognizer
{
    
    
    [self.mapView removeAnnotation:customAnnotation];
    
    CGPoint touchPoint = [gestureRecognizer locationInView:self.mapView];
    CLLocationCoordinate2D touchMapCoordinate =
    [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];
    
    customAnnotation = [[CustomAnnotation alloc]initWithLocation: CLLocationCoordinate2DMake(touchMapCoordinate.latitude,touchMapCoordinate.longitude)];
    //customAnnotation.coordinate = touchMapCoordinate;
    
    [self.mapView addAnnotation:customAnnotation];
    
}

- (void)gotoLocation:(CGFloat)latitude longitude:(CGFloat)longitude
{
   // CustomAnnotation * customAnnotation = [[CustomAnnotation alloc]initWithLocation: CLLocationCoordinate2DMake(latitude,longitude)];
    customAnnotation = [[CustomAnnotation alloc]initWithLocation: CLLocationCoordinate2DMake(latitude,longitude)];
    customAnnotation.type = property;
    [self.mapView addAnnotation:customAnnotation];
    

  
    
   // CLLocationCoordinate2D location = CLLocationCoordinate2DMake(latitude, longitude);
    

    //MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(location, 10000, 10000);
    
    MKCoordinateRegion mapRegion;
    mapRegion.center.latitude = latitude;
    mapRegion.center.longitude = longitude;
    mapRegion.span.latitudeDelta = 0.0015;
    mapRegion.span.longitudeDelta = 0.0015;
    
    
    //MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(location, 0.5*METERS_PER_MILE, 0.5*METERS_PER_MILE);

    [self.mapView setRegion:mapRegion animated:YES];
    [self.mapView regionThatFits:mapRegion];
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    
    if([annotation isKindOfClass:[CustomAnnotation class]]) //if this class is my custom pin class
    {
        //Try to get an unused annotation, similar to uitableviewcells
        CustomAnnotation *myLocation=(CustomAnnotation *)annotation;
        MKAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"CustomAnnotation"];
        
        if(annotationView == nil)
            annotationView = myLocation.annotationView;
        else
            annotationView.annotation = annotation;
        
        return annotationView;
    }
    else
        return nil;

}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    CLLocationCoordinate2D coord = self.mapView.userLocation.location.coordinate;
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coord, 1000.0, 1000.0);
    
   // MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coord, 0.5*METERS_PER_MILE, 0.5*METERS_PER_MILE);
    
    [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


@end
