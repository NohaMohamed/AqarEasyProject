//
//  Utility.m
//  Chanda
//
//  Created by Mohammad Azam on 10/25/11.
//  Copyright (c) 2011 HighOnCoding. All rights reserved.
//

#import "Utility.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "AqarEasyUser.h"
#import "AqarEasy-Swift.h"
@implementation Utility


//for picker 
+ (Utility*)sharedInstance
{
    // 1
    static Utility *_sharedInstance = nil;
    
    // 2
    static dispatch_once_t oncePredicate;
    
    // 3
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[Utility alloc] init];
    });
    return _sharedInstance;
}


- (id)init
{
    
    if (self = [super init]) {
        
    }
    return self;
}

+(CGFloat)getHeightForTxt:(NSString*)txt forWidth:(CGFloat)width withFont:(UIFont*)fnt{
    
    
    NSDictionary *attributes = @{NSFontAttributeName: fnt};
    CGRect rect = [txt boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                    options:NSStringDrawingUsesLineFragmentOrigin
                                 attributes:attributes
                                    context:nil];
    
    return rect.size.height;
    
}

+(UIImage *)makeRoundedImage:(UIImage *)image{
    
    CALayer *imageLayer = [CALayer layer];
    imageLayer.frame = CGRectMake(0, 0, image.size.width, image.size.width);
    imageLayer.contents = (id) image.CGImage;
    
    imageLayer.masksToBounds = YES;
    imageLayer.cornerRadius = image.size.width/2;
    
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width, image.size.width));
    [imageLayer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *roundedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return roundedImage;
}


+(BOOL)IsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = NO; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

+(void)showAlert:(NSString *)title message:(NSString *)msg
{
   /* UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:title
                          message:msg
                          delegate:self
                          cancelButtonTitle:nil
                          otherButtonTitles: NSLocalizedString(@"Ok", nil),
                          nil];

    [alert show];
    */
    [Utility ShowAlertWithTitle:title andMsg:msg andType:SWarning];
}

+(NSAttributedString*)setStringWithtwoFonts:(NSString*)text1 text2:(NSString*)text2{
    UIFont *font1 = [UIFont fontWithName:@"Oswald-Light" size:16];
    NSDictionary *firstDic = [NSDictionary dictionaryWithObject: font1 forKey:NSFontAttributeName];
    NSMutableAttributedString *aAttrString1 = [[NSMutableAttributedString alloc] initWithString:text1 attributes: firstDic];
    
    UIFont *font2 = [UIFont fontWithName:@"GESSTwoMedium-Medium" size:14];
    NSDictionary *secondDec = [NSDictionary dictionaryWithObject: font2 forKey:NSFontAttributeName];
    NSMutableAttributedString *aAttrString2 = [[NSMutableAttributedString alloc] initWithString:text2 attributes: secondDec];
    
    [aAttrString1 appendAttributedString:aAttrString2];
    return aAttrString1;
}

+(void)AddToFavourite:(NSString*)aqarId{
    
    NSString *user_id=[[AqarEasyUser sharedInstance] getUserUid];
    NSString *ext=@".data";
    
    
    NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithDictionary:[Utility getAllFavourites]];
    dic[aqarId]=@"fav";
    
    NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
    
    [dic writeToURL:[documentsDirectoryURL URLByAppendingPathComponent:[NSString stringWithFormat:@"%@%@", user_id,ext]] atomically:YES];

}

+(void)DeleteFromFav:(NSString*)aqarId{
    NSString *user_id=[[AqarEasyUser sharedInstance] getUserUid];
    NSString *ext=@".data";
    
    
    NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithDictionary:[Utility getAllFavourites]];
    [dic removeObjectForKey:aqarId];
    
    NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
    
    [dic writeToURL:[documentsDirectoryURL URLByAppendingPathComponent:[NSString stringWithFormat:@"%@%@", user_id,ext]] atomically:YES];

    
}

+(NSDictionary*)getAllFavourites{
    
    NSString *user_id=[[AqarEasyUser sharedInstance] getUserUid];
    NSString *ext=@".data";
    
    NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
    
  return [NSDictionary dictionaryWithContentsOfURL:[documentsDirectoryURL URLByAppendingPathComponent:[NSString stringWithFormat:@"%@%@", user_id,ext]]];
    
}


+(void)shortenUrl:(NSString*)longUrl WithComplectionBlock:(void (^)(NSDictionary*result))completion{
   // longUrl=@"http://stackoverflow.com/questions/21875222/how-can-i-implement-google-shortener-api-in-iphone";
    //https://www.googleapis.com/urlshortener/v1/url
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://www.googleapis.com/urlshortener/v1/url?key=AIzaSyCrVfDshitSmPOGI85aPOeHRD-lxSHUewo"]
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                       timeoutInterval:60.0];
    
   
    [request setHTTPMethod:@"POST"];
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    NSString *body=[NSString stringWithFormat:@"{\"longUrl\": \"%@\"}", longUrl];
    
    
    [request setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init]  completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
       
        NSError* error;
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data
                                                             options:kNilOptions
                                                               error:&error];
        
        completion(json);
       
        
    
    }];

}


+(void)showLoading{
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
}
+(void)hideLoading{
    dispatch_async(dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
        
    });
    
}

+(UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    /* UIGraphicsBeginImageContext(newSize);
     [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
     UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
     UIGraphicsEndImageContext();
     return newImage;*/
    
    float width = newSize.width;
    float height = newSize.height;
    
    UIGraphicsBeginImageContext(newSize);
    CGRect rect = CGRectMake(0, 0, width, height);
    
    float widthRatio = image.size.width / width;
    float heightRatio = image.size.height / height;
    float divisor = widthRatio > heightRatio ? widthRatio : heightRatio;
    
    width = image.size.width / divisor;
    height = image.size.height / divisor;
    
    rect.size.width  = width;
    rect.size.height = height;
    
    //indent in case of width or height difference
    /*float offset = (width - height) / 2;
     if (offset > 0) {
     rect.origin.y = offset;
     }
     else {
     rect.origin.x = -offset;
     }*/
    
    [image drawInRect: rect];
    
    UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImage *reduced=[UIImage imageWithData:UIImageJPEGRepresentation(smallImage, 0.5)];
    
    return reduced;
}


+(UIImage*)scaleImage:(UIImage*)image toSize:(CGSize)size{
    CGFloat maxSize = 1024.0f;
    CGFloat width = image.size.width;
    CGFloat height = image.size.height;
    CGFloat newWidth = width;
    CGFloat newHeight = height;
    
    // If any side exceeds the maximun size, reduce the greater side to 1200px and proportionately the other one
    if (width > maxSize || height > maxSize) {
        if (width > height) {
            newWidth = maxSize;
            newHeight = (height*maxSize)/width;
        } else {
            newHeight = maxSize;
            newWidth = (width*maxSize)/height;
        }
    }
    
    // Resize the image
    CGSize newSize = CGSizeMake(newWidth, newHeight);
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // Set maximun compression in order to decrease file size and enable faster uploads & downloads
    NSData *imageData = UIImageJPEGRepresentation(newImage, 0.0f);
    UIImage *processedImage = [UIImage imageWithData:imageData];
    
    return processedImage;
}

+(NSString *)stringByStrippingHTML:(NSString*)str{
    NSRange r;
    NSString *s = [str copy];
    while ((r = [s rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
        s = [s stringByReplacingCharactersInRange:r withString:@""];
    return s;
}


+(NSString *)randomStringWithLength:(int)len {
    
    NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";

    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    
    for (int i=0; i<len; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random_uniform([letters length])]];
    }
    
    return randomString;
}


#pragma  -mark
#pragma  -mark alert
+(void)ShowAlertWithTitle:(NSString*)title andMsg:(NSString*)msg andType:(SAlertType)type{
    
    //Success 0 ,Error 1,Warning 2 ,None 3
    
    [[[SweetAlert alloc] init] SalertWithView:[Utility createViewForSweetAlertWithMsg:msg] alertType:type buttonTitle:@"Ok" buttonColor:[UIColor colorWithRed:123/255.0 green:112/255.0 blue:88/255.0 alpha:1] otherButtonTitle:nil otherbuttonColor:[UIColor clearColor] action:nil];
 //   [[[SweetAlert alloc] init] showAlert:msg];
}

+(UIView*)createViewForSweetAlertWithMsg:(NSString*)msg{
    
    CGFloat width =300;//[UIScreen mainScreen].bounds.size.width;
    
    CGFloat height = [Utility getHeightForTxt:msg forWidth:width-50 withFont:[UIFont systemFontOfSize:16]];
    
    if (height < 90) {
        height=90;
    }
    UILabel *lbl=[[UILabel alloc] initWithFrame:CGRectMake(10, 0, width-50, height) ];
    
    lbl.numberOfLines=0;
    lbl.lineBreakMode=NSLineBreakByWordWrapping;
    lbl.textAlignment=NSTextAlignmentCenter;
    lbl.text=msg;
    
    UIView *view= [[UIView alloc] initWithFrame:CGRectMake(0, 0, width-30, lbl.frame.size.height)];
    [view addSubview:lbl];
    
    return view;
}



@end
