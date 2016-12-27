//
//  Utility.h
//  Chanda
//
//  Created by Mohammad Azam on 10/25/11.
//  Copyright (c) 2011 HighOnCoding. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h" 
#import "Constant.h"

typedef enum{
    pickerTypePhoto,
    pickerTypeMovie
}AssetsPickerType;


@interface Utility : NSObject

@property (strong,nonatomic) NSMutableArray* selectedAssets;
@property (nonatomic) AssetsPickerType pickerType;

+(Utility*)sharedInstance;

+(UIImage *)makeRoundedImage:(UIImage *)image;

+(void) showAlert:(NSString *) title message:(NSString *) msg;

+(NSAttributedString*)setStringWithtwoFonts:(NSString*)text1 text2:(NSString*)text2;

+(NSDictionary*)getAllFavourites;
+(void)AddToFavourite:(NSString*)aqarId;
+(void)DeleteFromFav:(NSString*)aqarId;

+(void)showLoading;
+(void)hideLoading;

+(void)shortenUrl:(NSString*)longUrl WithComplectionBlock:(void (^)(NSDictionary*result))completion;

+(BOOL)IsValidEmail:(NSString *)checkString;

+(UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;

+(NSString *)stringByStrippingHTML:(NSString*)str;

+(NSString *)randomStringWithLength:(int)len ;

+(void)ShowAlertWithTitle:(NSString*)title andMsg:(NSString*)msg andType:(SAlertType)type;

+(CGFloat)getHeightForTxt:(NSString*)txt forWidth:(CGFloat)width withFont:(UIFont*)fnt;
+(UIImage*)scaleImage:(UIImage*)image toSize:(CGSize)size;
@end
