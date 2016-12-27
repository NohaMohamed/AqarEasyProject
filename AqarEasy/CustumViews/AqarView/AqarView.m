//
//  AqarView.m
//  AqarEasy
//
//  Created by Eng. Eman Rezk on 11/24/14.
//  Copyright (c) 2014 Eng.Eman.Rezk. All rights reserved.
//

#import "AqarView.h"
#import "Utility.h"
#import "UIImageView+AFNetworking.h"
#import <FSImageViewer/FSBasicImageSource.h>
#import <FSImageViewer/FSBasicImage.h>
#import "AssetsView2.h"
#import <AFNetworking.h>
@implementation AqarView
@synthesize aqarInfoView;

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
        [[NSBundle mainBundle] loadNibNamed:@"AqarView" owner:self options:nil];
        
        CGRect frame = self.view.frame;
        frame.size = self.frame.size;
        self.view.frame = frame;
        
        // 2.Add as a subview
        [self addSubview:self.view];
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
       
    }
    return self;
}

-(void)setAqarInfo:(PropertyModel*)propertyModel{
    //for image gallery
    model=propertyModel;
    
    aqarInfoView.contractTypeLabel.text = propertyModel.contractType;
    NSString *backSlash=@"";
    if (propertyModel.location.length >1 || propertyModel.location_parent.length >1) {
        backSlash=@"/";
    }
    aqarInfoView.yearBuiltLabel.text = [NSString stringWithFormat:@"%@%@%@",propertyModel.location_parent,backSlash,propertyModel.location];
    
    
    aqarInfoView.priceLabel.text = propertyModel.price;
    if (propertyModel.currencyId) {
        
        NSString *price=propertyModel.price;
        if ([propertyModel.currencyId isEqualToString:@"SAR"]) {
            price=[NSString stringWithFormat:@"SAR %@",price];
        } else if([propertyModel.currencyId isEqualToString:@"EUR"]) {
             price=[NSString stringWithFormat:@"€ %@",price];
        }else if ([propertyModel.currencyId isEqualToString:@"USD"]){
             price=[NSString stringWithFormat:@"$ %@",price];
        }
        aqarInfoView.priceLabel.text = price;
        
    }
   // aqarInfoView.priceLabel.attributedText = [Utility setStringWithtwoFonts:propertyModel.price text2:@" ريال" ];
    aqarInfoView.areaLabel.attributedText = [Utility setStringWithtwoFonts:propertyModel.area text2:@" م٢" ];
    
    aqarInfoView.titleLabel.text = propertyModel.title;
    aqarInfoView.assetsView.parkingCountLabel.text = propertyModel.parkingCount;
    aqarInfoView.assetsView.bathroomCountLabel.text = propertyModel.bathroomCount;
    aqarInfoView.assetsView.bedroomCoutLabel.text = propertyModel.bedroomCount;
    
   
    if (propertyModel.showParking) {
        aqarInfoView.assetsView.parkingImgV.hidden=NO;
        aqarInfoView.assetsView.parkingCountLabel.hidden=NO;
    } else {
        aqarInfoView.assetsView.parkingImgV.hidden=YES;
        aqarInfoView.assetsView.parkingCountLabel.hidden=YES;
    }
    
    
    //set image
    [aqarInfoView.activityIndicator startAnimating];
    aqarInfoView.activityIndicator.hidden = NO;
    if ([propertyModel.images count]>=1) {
        NSURL *imageURL = [NSURL URLWithString:propertyModel.images[0]];
        // NSLog(@"imageURL: %@",imageURL);
        NSURLRequest *imageRequest = [NSURLRequest requestWithURL:imageURL];
        [aqarInfoView.image
         setImageWithURLRequest:imageRequest
         placeholderImage:nil
         success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image)
         {
             [aqarInfoView.activityIndicator stopAnimating];
             
             aqarInfoView.image.image = image;
         }
         failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error)
         {
             [aqarInfoView.activityIndicator stopAnimating];
         }];
        
    }
  
    
    aqarInfoView.numberofImagesLabel.text = [NSString stringWithFormat:@"%li %@",(unsigned long)[propertyModel.images count],@"صورة"];
    self._AdvertiserView.LBL_advertiserName.text=propertyModel.AdvertiserName;
    
    
    if ([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPad) {
        AssetsView2 *asset;
        if ([self viewWithTag:3424]) {
            asset=(AssetsView2*)[self viewWithTag:3424];
        } else {
            asset=[[AssetsView2 alloc] initWithFrame:CGRectMake(20, 0, 600, 40)];
            [self addSubview:asset];
        }
       
        asset.tag=3424;
        asset.bathroomCountLabel.text=propertyModel.bathroomCount;
        asset.bedroomCoutLabel.text=propertyModel.bedroomCount;
        asset.parkingCountLabel.text=propertyModel.parkingCount;
        
        
        
        [aqarInfoView.assetsView setHidden:YES];
        aqarInfoView.assetsView.alpha=0;
    
//        UILabel *lbl=[[UILabel alloc] initWithFrame:CGRectMake(100, 0, 300, 21)];
//        [lbl setBackgroundColor:[UIColor redColor]];
//        lbl.text=propertyModel.AdvertiserName;
//        [lbl setFont:[UIFont fontWithName:@"GESSTwoLight-Light" size:14.0]];
//        [self._AdvertiserView addSubview:lbl];
//        
//        [self._AdvertiserView.LBL_advertiserName setHidden:YES];
//        
    
    }
    
    
    //for image prowser
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapped:)];
    singleTap.numberOfTapsRequired = 1;
    singleTap.numberOfTouchesRequired = 1;
  
   
    [aqarInfoView.image addGestureRecognizer:singleTap];
    aqarInfoView.image.userInteractionEnabled = YES;
    
    
    
     //self._AdvertiserView.LBL_advertiserName.text=propertyModel.parkingCount
    
}

-(void)loadUserImageWithUrl:(NSString*)url{
    [self._AdvertiserView.IMGV_user setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"ad_profile.png"]];
    
}

-(void)imageTapped:(UIGestureRecognizer*)gest{
    
    [[NSUserDefaults standardUserDefaults] setValue:@"yes" forKey:@"landscacpe"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSMutableArray *images=[[NSMutableArray alloc] init];
    for (NSString *url in model.images) {
        FSBasicImage *img = [[FSBasicImage alloc] initWithImageURL:[NSURL URLWithString:url] name:@""];
        [images addObject:img];
    }
    
    FSBasicImageSource *photoSource = [[FSBasicImageSource alloc] initWithImages:images];
    
    
    FSImageViewerViewController *imageViewController = [[FSImageViewerViewController alloc] initWithImageSource:photoSource];
    //[imageViewController.view setBackgroundColor:[UIColor colorWithRed:224/255.0 green:224/255.0 blue:224/255.0 alpha:1]];
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:imageViewController];
    UINavigationController *nav=(UINavigationController*)[[UIApplication sharedApplication].delegate window].rootViewController;
    [nav presentViewController:navigationController animated:YES completion:nil];
}

@end
