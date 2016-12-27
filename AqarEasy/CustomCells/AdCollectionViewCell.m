//
//  AdCollectionViewCell.m
//  AqarEasy
//
//  Created by Eng. Eman Rezk on 11/21/14.
//  Copyright (c) 2014 Eng.Eman.Rezk. All rights reserved.
//

#import "AdCollectionViewCell.h"
//#import "UIImageView+AFNetworking.h"
#import "Utility.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation AdCollectionViewCell
@synthesize summaryView,summaryViewiPad;

-(void)setData:(PropertyModel*)propertyInfo{
  
        summaryView.LBL_name.text = propertyInfo.nodeTitle;
    
    NSString *price=propertyInfo.price;
    if ([propertyInfo.currencyId isEqualToString:@"SAR"]) {
        price=[NSString stringWithFormat:@"SAR %@",price];
    } else if([propertyInfo.currencyId isEqualToString:@"EUR"]) {
        price=[NSString stringWithFormat:@"€ %@",price];
    }else if ([propertyInfo.currencyId isEqualToString:@"USD"]){
        price=[NSString stringWithFormat:@"$ %@",price];
    }
    
      
    
    //price=[price stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    summaryView.LBL_price.text=price;
   

        //        summaryView.priceLabel.attributedText = [Utility setStringWithtwoFonts:propertyInfo.price text2:@" ريال" ];
        summaryView.LBL_area.text = [NSString stringWithFormat:@"%@ م٢",propertyInfo.area];
       
        
        summaryView.LBL_parkingCount.text = propertyInfo.parkingCount;
        summaryView.LBL_bathroomsCount.text = propertyInfo.bathroomCount;
        summaryView.LBL_bedroomsCount.text = propertyInfo.bedroomCount;
    
    if (propertyInfo.showParking) {
        summaryView.LBL_parkingCount.hidden=NO;
        summaryView.IMGV_parking.hidden=NO;
    }else{
        summaryView.LBL_parkingCount.hidden=YES;
        summaryView.IMGV_parking.hidden=YES;
    }
    
        [summaryView.activityIndicator startAnimating];
        summaryView.activityIndicator.hidden = false;
        
        if (propertyInfo.images.count>0) {
            NSString *imgUrl=propertyInfo.images[0];
            //imgUrl=[NSString stringWithFormat:@"%@&date=%f",imgUrl,[[NSDate date] timeIntervalSince1970]];
            NSURL *imageURL = [NSURL URLWithString:imgUrl];
            
            //[summaryView.image sd_setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"defImg"]];
            [summaryView.image sd_setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"defaultImg"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                [summaryView.activityIndicator stopAnimating];
                NSLog(@"===================%ld",cacheType);


            }];
            
           // [summaryView.image sd_set];
            /*
            NSURLRequest *imageRequest = [NSURLRequest requestWithURL:imageURL];
            [summaryView.image
             setImageWithURLRequest:imageRequest
             placeholderImage:nil
             success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image)
             {
                 summaryView.image.image = image;
                 [summaryView.activityIndicator stopAnimating];
             }
             failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error)
             {
                 [summaryView.activityIndicator stopAnimating];
             }];*/
        }
      
        
 
}
@end
