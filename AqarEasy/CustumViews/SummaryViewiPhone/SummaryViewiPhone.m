//
//  SummaryViewiPhone.m
//  AqarEasy
//
//  Created by Eng. Eman Rezk on 11/19/14.
//  Copyright (c) 2014 Eng.Eman.Rezk. All rights reserved.
//

#import "SummaryViewiPhone.h"
#import "Utility.h"
#import "UIImageView+AFNetworking.h"
#import "AqarEasyUser.h"

@implementation SummaryViewiPhone
@synthesize favouritebutton,image;

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        //Initialize code
        
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self){
        
        // 1.load the interface file from .xib
        [[NSBundle mainBundle] loadNibNamed:@"SummaryViewiPhone" owner:self options:nil];
        
        CGRect frame = self.view.frame;
        frame.size = self.frame.size;
        self.view.frame = frame;
        
        // 2.Add as a subview
        [self addSubview:self.view];
    }
    return self;
}

-(void)setDataFromModel:(PropertyModel *)model{
    self.model=model;
    if (!self.model.showParking) {
        [self.LBL_parkingCount setHighlighted:YES];
        [self.IMGV_parking setHighlighted:YES];

    }
    
    self.LBL_name.text=model.nodeTitle;
    self.LBL_area.text=model.area;
    self.LBL_bedroomsCount.text=model.bedroomCount;
    self.LBL_bathroomsCount.text=model.bathroomCount;
    self.LBL_parkingCount.text=model.parkingCount;
    self.LBL_price.text=model.price;
    
   
    
    
    
    [self.favouritebutton addTarget:self action:@selector(addToFav:) forControlEvents:UIControlEventTouchUpInside];
    NSDictionary *dicFavs=[Utility getAllFavourites];
    
    if (dicFavs[model.nid]) {
        model.isFavorite=YES;
        self.favouritebutton.selected = YES;
    }else {
        model.isFavorite=NO;
        self.favouritebutton.selected = NO;
    }
    
    
    [self.activityIndicator startAnimating];
    self.activityIndicator.hidden = false;
    if (self.model.images.count>=1) {
        
        
        NSURL *imageURL = [NSURL URLWithString:self.model.images[0]];
        NSURLRequest *imageRequest = [NSURLRequest requestWithURL:imageURL];
        [self.image
         setImageWithURLRequest:imageRequest
         placeholderImage:nil
         success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image1)
         {
             self.image.image = image1;
             [self.activityIndicator stopAnimating];
         }
         failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error)
         {
             [self.activityIndicator stopAnimating];
         }];
    }
}

-(void)addToFav:(UIButton*)sender{
    
    if (![[AqarEasyUser sharedInstance] isUserLogged]) {
        [Utility showAlert:@"عفواً" message:@"من فضلك قم بتسجيل الدخول "];
        return;
    }
    
    if (sender.selected) {
        sender.selected=NO;
        [Utility DeleteFromFav:self.model.nid];
        self.model.isFavorite=NO;
        
    }else{
        sender.selected=YES;
        [Utility AddToFavourite:self.model.nid];
        self.model.isFavorite=YES;
    }
    
    
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
