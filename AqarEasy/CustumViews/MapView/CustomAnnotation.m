//
//  CustomAnnotation.m
//  AqarEasy
//
//  Created by Eng. Eman Rezk on 11/27/14.
//  Copyright (c) 2014 Eng.Eman.Rezk. All rights reserved.
//

#import "CustomAnnotation.h"

@implementation CustomAnnotation
@synthesize subtitle,title,type;

/*-(id)initWithTitle:(NSString *)newTitle Location:(CLLocationCoordinate2D)location{
    self = [super init];
    
    if(self)
    {
        _title = newTitle;
        _coordinate = location;
    }
    return self;
}*/

-(id)initWithLocation:(CLLocationCoordinate2D)location{
    self = [super init];
    
    if(self)
    {
        _coordinate = location;
    }
    return self;
}

-(MKAnnotationView *)annotationView{
    MKAnnotationView *annotationView = [[MKAnnotationView alloc]initWithAnnotation:self reuseIdentifier:@"MyCustomAnnotation"];
    annotationView.enabled = YES;
    annotationView.canShowCallout = YES;
    switch (type) {
        case hospital:
             annotationView.image = [UIImage imageNamed:@"train"];
            break;
        case airport:
             annotationView.image = [UIImage imageNamed:@"map_pin_location"];
            break;
        case shopping:
            annotationView.image = [UIImage imageNamed:@"supermarket"];
            break;
        case property:
           // annotationView.image = [UIImage imageNamed:@"location"];
            annotationView.image = [UIImage imageNamed:@"home22"];
            break;
            
        default:
            break;
    }
   
//    annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    return annotationView;
}
@end

@implementation CustomAnnotaionView

@end
