//
//  NewsViewController.m
//  AqarEasy
//
//  Created by Assem Imam on 10/28/16.
//  Copyright © 2016 Eng.Eman.Rezk. All rights reserved.
//

#import "NewsViewController.h"
#import "NewsCell.h"
#import "Utility.h"
#import "SDK_API_Controller.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "SWRevealViewController.h"

@interface NewsViewController ()
{
    NSDictionary *newsItemsList;
}
@end

@implementation NewsViewController
-(void)getNews{
    [Utility showLoading];
    
    [[SDK_API_Controller sharedInstance] sendrequestWithPath:@"getNews" andHttpMethod:@"GET" andParms:nil withCompletion:^(id result, NSError *error) {
        if (!error) {
            newsItemsList = result;
           
        }
        
        [Utility hideLoading];
        [newsTableView reloadData];
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    @try {
        menuButton.target = self.revealViewController;
        menuButton.action = @selector(revealToggle:);
        
        
        // Add pan gesture to hide the sidebar
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
        [self getNews];
        
    } @catch (NSException *exception) {
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NewsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cleNews"];
    NSString*currentkey = [newsItemsList.allKeys objectAtIndex:indexPath.row];
    id newsItem = [newsItemsList objectForKey:currentkey];
    cell.newsItemTitleLabel.text = newsItem[@"title"];

    NSURL *url= [NSURL URLWithString:newsItem[@"cover"]];
    
    if (url) {
        [cell.newsItemImageView  sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"defaultImg"]   completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (image) {
                cell.newsItemImageView .image = image;
            }
        } ];
    }
    
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [newsItemsList.allKeys count];
}
- (IBAction)backButtonAction:(UIButton *)sender {
}

- (IBAction)readMoreButtonAction:(UIButton *)sender {
}
@end
