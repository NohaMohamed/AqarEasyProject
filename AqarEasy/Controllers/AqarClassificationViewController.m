//
//  AqarClassificationViewController.m
//  AqarEasy
//
//  Created by Eng. Eman Rezk on 12/2/14.
//  Copyright (c) 2014 Eng.Eman.Rezk. All rights reserved.
//

#import "AqarClassificationViewController.h"
#import "AdCollectionViewCell.h"
#import "PropertyInfoViewController.h"
#import "APIControlManager.h"
#import "Constant.h"
#import "Utility.h"
#import "AqarEasyUser.h"
#import <ReactiveCocoa/RACSignal+Operations.h>
#import "SDK_API_Controller.h"
#import <DIOSNode.h>
#import "AddAqarViewController.h"

@interface AqarClassificationViewController ()
{
    int page;
    NSMutableDictionary *dicFav;
    BOOL canLoadNexPage;
    
    NSArray *ArrFavsIds;
    NSInteger currentIndexFav;
}
@end

@implementation AqarClassificationViewController
@synthesize aqarClassification;

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if ([[AqarEasyUser sharedInstance] isUserLogged]) {
        //
        dicFav=[[NSMutableDictionary alloc] initWithDictionary:[Utility getAllFavourites]];
    }else{
        dicFav=[NSMutableDictionary new];
    }
    
    
    [self.collectionView reloadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
 
    page=0;
    canLoadNexPage=YES;
    currentIndexFav=0;
    
    // Do any additional setup after loading the view.

    self.propertyArray = [[NSMutableArray alloc]init];
    //dicFav=[[NSMutableDictionary alloc] initWithDictionary:[Utility getAllFavourites]];
    
    
    // Set the side bar button action. When it's tapped, it'll show up the sidebar.
    _menuButton.target = self.revealViewController;
    _menuButton.action = @selector(revealToggle:);
    
    self.revealViewController.delegate = self;
    
  
    
    switch (aqarClassification) {
        case favourite:
        {
            
            self.navigationItem.title = @"عقاراتي المفضلة";
            
           ArrFavsIds =[[Utility getAllFavourites] allKeys];
            
            [self getUserFavsNodsNextPage];
          

           //  [[APIControlManager sharedInstance] get];
            break;
        }
        case myaqars:
        {
            
            self.navigationItem.title = @"عقاراتي";
             [self loadPageWithUrl:@"myAqarat?page=0"];
            
            //  [[APIControlManager sharedInstance] get];
            break;
        }
         
        case searchResult:
        {
            
            self.navigationItem.title = @"نتيجه البحث";
            //  [Utility showLoading];
            //  [[APIControlManager sharedInstance] get];
            
            break;
        }
        case sale:
        {
            self.navigationItem.title = @"عقارات للبيع";
            NSString *path = [NSString stringWithFormat:@"adall/?page=%d&type=%d",page,adsTypeForSale];
            [self loadPageWithUrl:path];

            break;
            
            
        }
        case rent:
        {
            self.navigationItem.title = @"عقارات للإيجار";
            NSString *path = [NSString stringWithFormat:@"adall/?page=%d&type=%d",page,adsTypeForRent];
            [self loadPageWithUrl:path];
            
            break;
        }
            
        default:
            break;
    }
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    
    UICollectionViewFlowLayout * collectionViewFlowLayout = [[UICollectionViewFlowLayout alloc]init];
    if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone)
    {
        collectionViewFlowLayout.itemSize = CGSizeMake(self.view.frame.size.width , 210);
        
    }
    else
    {
        if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0) {
            [self resizeView];
        }
        collectionViewFlowLayout.itemSize = CGSizeMake(self.view.frame.size.width/2.0-2, 210);
    }
    collectionViewFlowLayout.minimumInteritemSpacing = 3;
    collectionViewFlowLayout.minimumLineSpacing = 1;
    self.collectionView.collectionViewLayout = collectionViewFlowLayout;
    


    /*
    if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone)
    {
        collectionViewFlowLayout.itemSize = CGSizeMake(self.view.frame.size.width - 20, 150);
    }
    else
    {
        if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0) {
            [self resizeView];
        }
        collectionViewFlowLayout.itemSize = CGSizeMake(self.view.frame.size.width/2.0-10, 150);
    }
    self.collectionView.collectionViewLayout = collectionViewFlowLayout;*/
}

-(void)resizeView{
    //Change the width of a table view
    CGRect viewFrame = self.view.frame;
    viewFrame.size.width = self.view.frame.size.height;
    viewFrame.size.height = self.view.frame.size.width;
    self.view.frame = viewFrame;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self.propertyArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    AdCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    PropertyModel * propertModel = [self.propertyArray objectAtIndex:indexPath.row];
    [cell setData:propertModel];
    
    
    if (dicFav[propertModel.nid]) {
        cell.summaryView.favouritebutton.selected=YES;
        propertModel.isFavorite=YES;
        
    }else{
        cell.summaryView.favouritebutton.selected=NO;
        propertModel.isFavorite=NO;
    }
    
    
    [cell.summaryView.favouritebutton addTarget:self action:@selector(addToFav:) forControlEvents:UIControlEventTouchUpInside];
    cell.summaryView.favouritebutton.tag=indexPath.row;
    
    
    if (aqarClassification==myaqars) {
        
        UIView *bottomView = [[UIView alloc] init];
        bottomView.frame = (CGRect){
            .size = CGSizeMake(CGRectGetWidth(collectionView.bounds)/2, CGRectGetHeight(cell.bounds))
            
        };
        
        UIButton *btn_delete=[UIButton buttonWithType:UIButtonTypeCustom];
        [btn_delete setFrame:CGRectMake(bottomView.frame.size.width-80+10, bottomView.frame.size.height/2-32, 50, 50)];
        [btn_delete setImage:[UIImage imageNamed:@"trash"] forState:UIControlStateNormal];
        [btn_delete addTarget:self action:@selector(deleteAqar:) forControlEvents:UIControlEventTouchUpInside];
        btn_delete.tag=indexPath.row;
        
        
        UIButton *btn_edit=[UIButton buttonWithType:UIButtonTypeCustom];
        [btn_edit setFrame:CGRectMake(bottomView.frame.size.width-160+10, bottomView.frame.size.height/2-32, 50, 50)];
        [btn_edit setImage:[UIImage imageNamed:@"edit"] forState:UIControlStateNormal];
        [btn_edit addTarget:self action:@selector(editAqar:) forControlEvents:UIControlEventTouchUpInside];
        btn_edit.tag=indexPath.row;
        
        [bottomView addSubview:btn_delete];
        [bottomView addSubview:btn_edit];
        
        
        cell.allowedDirection = CADRACSwippableCellAllowedDirectionLeft;
        cell.revealView = bottomView;

        [[cell.revealViewSignal filter:^BOOL(NSNumber *isRevealed) {
            return [isRevealed boolValue];
        }] subscribeNext:^(id x) {
            [[collectionView visibleCells] enumerateObjectsUsingBlock:^(AdCollectionViewCell *otherCell, NSUInteger idx, BOOL *stop) {
                if (otherCell != cell)
                {
                    [otherCell hideRevealViewAnimated:YES];
                }
            }];
        }];
        
        bottomView.backgroundColor = [UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:239.0/255.0 alpha:1];
       }
    
    
    return cell;
    
}



-(void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row==self.propertyArray.count-1&&canLoadNexPage) {
        canLoadNexPage=NO;
        [self loadNextPage];
    }
    
}


-(void)deleteAqar:(UIButton*)sender{

    
    [Utility showLoading];
    
    
     PropertyModel * propertModel = [self.propertyArray objectAtIndex:sender.tag];
    //propertModel.nid
    [DIOSNode nodeDelete:@{@"nid":propertModel.nid} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"===============%@",  responseObject);
        if ([responseObject[0] intValue]==1) {
            [self.propertyArray removeObjectAtIndex:sender.tag];
            [self.collectionView reloadData];
             [Utility hideLoading];
            [Utility DeleteFromFav:propertModel.nid];
            //[Utility showAlert:@"نجاح" message:@"لقد تمت العمليه بنجاح"];
            [Utility ShowAlertWithTitle:@"" andMsg:@"لقد تمت العمليه بنجاح" andType:SSucess];
        }else{
            [Utility hideLoading];
           // [Utility showAlert:@"فشل" message:@"لقد حدث شىء ما من فضلك حاول مره اخري"];
            [Utility ShowAlertWithTitle:@"" andMsg:@"لقد حدث شىء ما من فضلك حاول مره اخري" andType:SFail];
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"===============%@",  error);
        [Utility hideLoading];
       [Utility ShowAlertWithTitle:@"" andMsg:@"لقد حدث شىء ما من فضلك حاول مره اخري" andType:SFail];
    }];
    
}
-(void)editAqar:(UIButton*)sender{
    NSLog(@"===============%ld",  (long)sender.tag);
    
    AddAqarViewController *addaqar=[self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([AddAqarViewController class])];
    PropertyModel * propertModel = [self.propertyArray objectAtIndex:sender.tag];
    
    addaqar.nodeId=propertModel.nid;

    [self.navigationController pushViewController:addaqar animated:YES];
    
    
}

-(void)addToFav:(UIButton*)sender{
    
    if (![[AqarEasyUser sharedInstance] isUserLogged]) {
        [Utility showAlert:@"تنبيه" message:@"من فضلك سجل دخول اولا"];
        return;
    }
    PropertyModel * propertModel = [self.propertyArray objectAtIndex:sender.tag];
    
    if (sender.selected) {
        sender.selected=NO;
        [Utility DeleteFromFav:propertModel.nid];
        [dicFav removeObjectForKey:propertModel.nid];
        propertModel.isFavorite=NO;
        
    }else{
        sender.selected=YES;
        [Utility AddToFavourite:propertModel.nid];
        dicFav[propertModel.nid]=@"favs";
        propertModel.isFavorite=YES;
    }
    
    
}




- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if([segue.identifier isEqualToString:@"Search_Segue"])
    {
        SearchViewController *searchViewController = segue.destinationViewController;
        if (aqarClassification==rent) {
            searchViewController.comefromController=@"rent";
        } else if(aqarClassification==sale) {
            searchViewController.comefromController=@"sell";

        }
        searchViewController.delegate = self;
    }
    else if([segue.identifier isEqualToString:@"PropertyInfo_Segue"])
    {
    
    PropertyInfoViewController * propertyInfoViewController = [segue destinationViewController];
    
    NSIndexPath *indexPath = [self.collectionView.indexPathsForSelectedItems objectAtIndex:0];
    // get the cell object
    
    PropertyModel * propertyModel = [self.propertyArray objectAtIndex:indexPath.row];
    propertyInfoViewController.propertyModel = propertyModel;
    }
    
}

#pragma mark - SearchViewControllerDelegate

- (void)searchViewControllerDidCancel:(SearchViewController *)controller
{
    [self.navigationController popViewControllerAnimated:YES];
    
    
}

- (void)searchViewControllerDidSearch:(SearchViewController *)controller
{
    
    //[self.navigationController popViewControllerAnimated:YES];
    
     self.navigationItem.title=@"نتيجه البحث";
    [_propertyArray removeAllObjects];
    [_collectionView reloadData];

    
    [Utility showLoading];
   
    NSString *region=controller.tid;
    
    
    
    NSMutableDictionary*  postedSearchData=[NSMutableDictionary new];
    
    if (controller.SRcontract_type) {
        postedSearchData[@"contract_type"]=controller.SRcontract_type;
    }
    if (controller.SRtype) {
        postedSearchData[@"type"]=controller.SRtype;
    }
    if (region) {
        postedSearchData[@"region"]=region;
    }
    if ([controller.LBL_bathRoomCount.text intValue] >1) {
        postedSearchData[@"bedrooms"]=[NSString stringWithFormat:@"%@", controller.LBL_bedRoomCount.text];
    }
    if ([controller.LBL_bathRoomCount.text intValue] >1) {
        postedSearchData[@"bathrooms"]=[NSString stringWithFormat:@"%@", controller.LBL_bathRoomCount.text];
    }
    
    
     postedSearchData[@"price_from"]=controller.SRprice_from;
     postedSearchData[@"price_to"]=controller.SRprice_to;
    
    

    //bathrooms=2&bedrooms=3&contract_type=659&price_from=10000&price_to=10000000&region=56&type=631
    
    [[APIControlManager sharedInstance] nativePostWithUrl:[NSString stringWithFormat:@"%@searchAqar",BASE_URL] withParms:postedSearchData withCompletionBlock:^(id ret) {
        
        if (ret[@"data"]&&[ret[@"data"] count]>=1) {
            NSArray *result= [ret[@"data"] allValues];
            
            canLoadNexPage=NO;
            for(NSDictionary *dic in result)
            {
                PropertyModel * propertyModel = [[PropertyModel alloc]init];
                [propertyModel PropertyFromDictionary:dic];
                [_propertyArray addObject:propertyModel];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [_collectionView reloadData];
                [Utility hideLoading];
                
            });
            
        }else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [Utility hideLoading];
                [Utility showAlert:@"تنبيه" message:@"لا يوجد نتيجه لهذا البحث"];
            });
        }
        
    }];
    
    
    
}

-(void)updateView:(NSString*) errorMessage{
    
    if(errorMessage == nil)
    {
        if([_propertyArray count] == 0)
            [Utility showAlert:@"عفوا" message:@"لا توجد بيانات"];
    }
    else
    {
        [Utility showAlert:@"عفوا" message:@"يوجد خطأ في الاتصال بالانترنت برجاء المحاولة مرة أخري"];
    }
    
    [_collectionView reloadData];
    [Utility hideLoading];
    //[_activityIndicator stopAnimating];
}

#pragma - mark
#pragma - mark pagging

-(void)loadNextPage{
    
    page++;
    
    switch (aqarClassification) {
            
        case favourite:
            [self getUserFavsNodsNextPage];
            break;
        case myaqars:{
            NSString *path=[NSString stringWithFormat:@"myAqarat?page=%d",page];
            [self loadPageWithUrl:path];
            break;
        }
        case sale:{
            NSString *path = [NSString stringWithFormat:@"adall/?page=%d&type=%d",page,adsTypeForSale];
            [self loadPageWithUrl:path];
            break;
        }
            
        case rent:{
                NSString *path = [NSString stringWithFormat:@"adall/?page=%d&type=%d",page,adsTypeForRent];
                [self loadPageWithUrl:path];
                break;
            }

            break;
        default:
            break;
    }
    
   
}

-(void)loadPageWithUrl:(NSString*)url{
    
    //1-check if is current favourite page
      //2- check for
    [Utility showLoading];
    
    [[SDK_API_Controller sharedInstance] sendrequestWithPath:url andHttpMethod:@"GET" andParms:nil withCompletion:^(id result, NSError *error) {
        
        NSMutableArray *propertyArray = [NSMutableArray array];
        if ([result isKindOfClass:[NSDictionary class]]) {
            NSDictionary *returnedData=(NSDictionary*)result;
            if ([returnedData isKindOfClass:[NSDictionary class]]) {
                for(NSString *key in returnedData)
                {
                    if (key.length <1) {
                        continue;
                    }
                    PropertyModel * propertyModel = [[PropertyModel alloc]init];
                    [propertyModel PropertyFromDictionary:returnedData[key]];
                    [propertyArray addObject:propertyModel];
                }
                
            }
            
            
        } else {
            for(NSDictionary *dic in result)
            {
                
                
                PropertyModel * propertyModel = [[PropertyModel alloc]init];
                [propertyModel PropertyFromDictionary:dic];
                [propertyArray addObject:propertyModel];
            }
            
        }

        
        if (propertyArray.count>0) {
            [_propertyArray addObjectsFromArray:propertyArray];
            canLoadNexPage=YES;
        }else{
            canLoadNexPage=NO;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self updateView:error.localizedDescription];
        });

        
    }];
   
}



#pragma - mark
#pragma - mark load fav

-(void)getUserFavsNodsNextPage{
    
    int pageSize=15;
    NSInteger length=(currentIndexFav+pageSize)>ArrFavsIds.count?(ArrFavsIds.count-currentIndexFav):pageSize;
    
    if (length>0) {
        NSArray *ArrIds=[ArrFavsIds subarrayWithRange:NSMakeRange(currentIndexFav, length)];
        
        
        currentIndexFav +=pageSize;
        
        NSString *ids=  [ArrIds componentsJoinedByString:@"&nids[]="];
        
        //  http://aqareasy.com/api/getNodes.json?nids[]=508&nids[]=77777
        
        NSString *path = [NSString stringWithFormat:@"getNodes.json?nids[]=%@",ids];
        
        [self loadPageWithUrl:path];
    } else {
        canLoadNexPage=NO;
    }
    
    
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
