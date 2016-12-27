//
//  LocationViewController.m
//  AqarEasy
//
//  Created by Eng. Eman Rezk on 11/21/14.
//  Copyright (c) 2014 Eng.Eman.Rezk. All rights reserved.
//

#import "LocationViewController.h"
#import "LocationTableViewCell.h"
#import "APIControlManager.h"
#import "Utility.h"

@interface LocationViewController ()
{
    NSMutableArray *ArrData;
    
    __weak IBOutlet UILabel *LBL_noNearByData;
}
@end

@implementation LocationViewController
@synthesize locationNames,locationLogos,distanceLocationView;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [Utility showLoading];
    _tableView.SKSTableViewDelegate = self;

    [[APIControlManager sharedInstance] getNearbyServicewithNodeID:self.nid withCompletionBlock:^(NSMutableArray *arr, NSString *errorMessage) {
        
        [NSThread detachNewThreadSelector:@selector(formateData:) toTarget:self withObject:arr];
       
       
        
    }];

    
}

-(void)formateData:(NSArray*)arr{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        ArrData=[NSMutableArray new];
        NSMutableDictionary *keysDic=[NSMutableDictionary new];
        for (NSDictionary *dic in arr) {
            keysDic[dic[@"type"]]=@"test";
            
        }
        
        for (NSString *key in keysDic) {
            NSArray *childs=[self getChildsForKey:key fromArray:arr];
            NSDictionary *dic=@{@"child_items":childs,@"title":childs[0][@"type_value"],@"type":childs[0][@"type"]};
            NSArray *arrSub=[NSArray arrayWithObject:dic];
            [ArrData addObject:arrSub];
        }
        if (ArrData.count <1) {
            _tableView.alpha=0;
            LBL_noNearByData.alpha=1;
        }
        
        if (_delg) {
            if ([_delg respondsToSelector:@selector(getNumberOfSection:)]) {
                [_delg getNumberOfSection:(int)ArrData.count];
            }
        }
        self.tableView.shouldExpandOnlyOneCell=YES;
        [self.tableView reloadData];
        [Utility hideLoading];
        
    });
   
}

-(NSArray*)getChildsForKey:(NSString*)key fromArray:(NSArray*)arr{
    NSMutableArray *ret=[NSMutableArray new];
    
    for (NSDictionary *dic in arr) {
        if ([dic[@"type"] isEqualToString:key]) {
            [ret addObject:dic];
        }
    }
    return ret;
}

-(void)setDistances:(DistanceLocationModel*) distanceLocationModel{

    NSLog(@"distanceToAirport:%@",distanceLocationModel.distanceToAirport);
    distanceLocationView.distanceToAirportLabel.text = distanceLocationModel.distanceToAirport;
    distanceLocationView.distanceToDownTownLabel.text = distanceLocationModel.distanceToDownTown;
    distanceLocationView.distanceToHighWayLabel.text = distanceLocationModel.distanceToHighWay;
    
   
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [ArrData count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [ArrData[section] count];
}

- (NSInteger)tableView:(SKSTableView *)tableView numberOfSubRowsAtIndexPath:(NSIndexPath *)indexPath
{
    return [ArrData[indexPath.section][indexPath.row][@"child_items"] count] ;
}

- (BOOL)tableView:(SKSTableView *)tableView shouldExpandSubRowsOfCellAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
    
    //    if ([ArrData[indexPath.section][indexPath.row][@"child_items"] count]>0) {
    //        return YES;
    //    }
    //
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    LocationTableViewCell *cell ;
    cell = (LocationTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"LocationCell"];
    
    cell.backgroundColor=[UIColor clearColor];
    cell.contentView.backgroundColor=[UIColor clearColor];
    
    cell.label.text = ArrData[indexPath.section][indexPath.row][@"title"];
    NSLog(@"===============%@",  ArrData[indexPath.section][indexPath.row][@"type"]);
    cell.logo.image = [UIImage imageNamed:ArrData[indexPath.section][indexPath.row][@"type"]];
    
    
    if([ArrData[indexPath.section][indexPath.row][@"child_items"] count]>0){
        cell.expandable = YES;

    }else{
        cell.expandable = NO;

    }
    
    return cell;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForSubRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"subCell"];
    [cell setBackgroundColor:[UIColor whiteColor]];
    [cell.contentView setBackgroundColor:[UIColor whiteColor]];
     cell.textLabel.font=[UIFont fontWithName:@"GESSTwoLight-Light" size:12.0];
    [cell.textLabel setBackgroundColor:[UIColor whiteColor]];
    
    cell.textLabel.text=[NSString stringWithFormat:@"%@", ArrData[indexPath.section][indexPath.row][@"child_items"][indexPath.subRow-1][@"node_title"]];
    
   
    
    NSString *dist=[NSString stringWithFormat:@"%.2f",[ArrData[indexPath.section][indexPath.row][@"child_items"][indexPath.subRow-1][@"location_distance"] floatValue]/1000];
    
    cell.detailTextLabel.text=[NSString stringWithFormat:@"يبعد %@ كم",dist];
    cell.detailTextLabel.backgroundColor=[UIColor whiteColor];
    //cell.detailTextLabel.tintColor=[UIColor greenColor];
    UIFont *fnt=[UIFont fontWithName:@"Oswald-Light" size:14.0];
    
    [cell.detailTextLabel setFont:fnt];
    //[cell.textLabel setFont:fnt];
 
    return cell;
    
}

- (CGFloat)tableView:(SKSTableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return 70;
}

-(CGFloat)tableView:(SKSTableView *)tableView heightForSubRowAtIndexPath:(NSIndexPath *)indexPath{
//    if ([Utilities isIpad]) {
//        return 65;
//    } else {
//        return 40;
//    }
    return 50;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
   
    
    
}

- (void)tableView:(SKSTableView *)tableView didSelectSubRowAtIndexPath:(NSIndexPath *)indexPath
{
    
   
}


#pragma mark - Table view data source
/*
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [locationNames count] ;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LocationTableViewCell *cell ;
    if (cell == nil) {
        cell = (LocationTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"LocationCell" forIndexPath:indexPath];
    }

    cell.label.text = [locationNames objectAtIndex:indexPath.row];
    cell.logo.image = [UIImage imageNamed:[locationLogos objectAtIndex:indexPath.row]];
    
    return cell;
}
*/
/*
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    CGFloat height = self.tableView.frame.size.height/ [locationNames count];    
    return height;
}
*/
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
