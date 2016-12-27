//
//  DistanceLocationView.h
//  AqarEasy
//
//  Created by Eng. Eman Rezk on 11/21/14.
//  Copyright (c) 2014 Eng.Eman.Rezk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DistanceLocationView : UIView
@property (strong, nonatomic) IBOutlet UIView *view;
@property (weak, nonatomic) IBOutlet UILabel *distanceToAirportLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceToDownTownLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceToHighWayLabel;

@end
