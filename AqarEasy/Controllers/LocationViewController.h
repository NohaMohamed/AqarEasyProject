//
//  LocationViewController.h
//  AqarEasy
//
//  Created by Eng. Eman Rezk on 11/21/14.
//  Copyright (c) 2014 Eng.Eman.Rezk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DistanceLocationView.h"
#import "DistanceLocationModel.h"
#import "SKSTableView.h"

@protocol locationDeleagte <NSObject>
@optional
-(void)getNumberOfSection:(int)sections;

@end

@interface LocationViewController : UIViewController<SKSTableViewDelegate>
@property (weak, nonatomic) IBOutlet SKSTableView *tableView;
@property (weak, nonatomic) IBOutlet DistanceLocationView *distanceLocationView;

@property(strong,nonatomic) NSMutableArray* locationNames;
@property(strong,nonatomic) NSMutableArray* locationLogos;
@property(nonatomic,strong) NSString *nid;
@property(nonatomic,weak) id<locationDeleagte> delg;

-(void)setDistances :(DistanceLocationModel*) distanceLocationModel;

@end

