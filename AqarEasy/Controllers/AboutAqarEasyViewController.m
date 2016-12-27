//
//  AboutAqarEasyViewController.m
//  AqarEasy
//
//  Created by Eng. Eman Rezk on 11/26/14.
//  Copyright (c) 2014 Eng.Eman.Rezk. All rights reserved.
//

#import "AboutAqarEasyViewController.h"
#import "SWRevealViewController.h"

@interface AboutAqarEasyViewController ()

@end

@implementation AboutAqarEasyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) &&([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0)) {
        [self resizeView];
    }
    
    self.view.layer.borderColor = [UIColor brownColor].CGColor;
    self.view.layer.borderWidth = 2.5;
    
    [self setNavigationImage];
    
    _menuButton.target = self.revealViewController;
    _menuButton.action = @selector(revealToggle:);
    
    // Add pan gesture to hide the sidebar
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    [self loadContentInWebView];

   }

// Set image in position of navigationBar title
-(void) setNavigationImage{
    /* Create an Image View to replace the Title View */
    UIImageView *imageView =
    [[UIImageView alloc]
     initWithFrame:CGRectMake(0.0f, 0.0f, 100.0f, 35.0f)];
    
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    /* Load an image. Be careful, this image will be cached */
    UIImage *image = [UIImage imageNamed:@"logo_small.png"];
    
    /* Set the image of the Image View */
    [imageView setImage:image];
    
    /* Set the Title View */
    self.navigationItem.titleView = imageView;
}


// Set text of about AqarEasy
- (void) loadContentInWebView{
    // Path to the plist (in the application bundle)
   // NSString *path = [[NSBundle mainBundle] pathForResource:@"AqarEasy" ofType:@"plist"];
    NSString *str=@"شــركـة عقـــــار ايــزي<br/>.AQAREASY S.R.L<br/>  شركة ذات مسؤولية محدودة (SRL) مسجلة رسمياً بجمهورية ايطاليا ومقرها في مدينة كومو مملوكة بالكامل لمستثمرين خليجيين من ذوي الخبرة العقارية والاقتصادية تُمارس أعمالها في مجال التسويق والاستثمار والتطوير العقاري يتركز نشاط الشركة في العقارات الاوروبية والبحث عن أفضل الفرص الإستثمارية الآمنة وذات العوائد المرتفعة ..إضافة الى تقديمها خدمة التسويق العقاري عبر موقعها الإلكتروني من خلال أدوات تقنية متميزة وذلك بالاستعانة بنظام الخرائط الفضائية وأفضل المعايير التقنية لأجل تقديمها للباحث عن العقار بشكل احترافي ومــميز .<br/> <br/>المركز الرئيسي للشركة:    مدينة كـومــو(ايطـاليا)<br/>   الدور الثانيVIA FRATELLI RECCHI 7<br/>    ص.ب:CP 103 COMO CENTRO 22100 كومو<br/>    الهاتف: 00393383544555<br/>    (السجل التجاري)REA: 32296<br/>    <br/>PARTITA IVA(الرقم الضريبي) : 03593960135</string>";
    
    
    // Build the array from the plist
  //  NSMutableArray *array = [[NSMutableArray alloc] initWithContentsOfFile:path];
    ////NSString *aboutText = [array  objectAtIndex:0];
    
    //load html content into webview
    NSString *  htmlString = [NSString stringWithFormat:@"<html><head><style type=\"text/css\"> \n"
                              ".text {font-family: \"%@\"; font-size: %d; line-height:1.5;}\n"
                              "</style></head><body dir=\"%@\"><p align=\"justify\"><span class=\"text\"><font color=\"%@\">%@</font></span></p></body></html>", @"GESSTwoLight-Light", 12,@"rtl", @"E6E6E6", str];
    
    
    
    [self.webView loadHTMLString:htmlString baseURL:[NSURL URLWithString:@""]];
    
    // to make WebView Background color to transparent
    [self.webView setBackgroundColor:[UIColor clearColor]];
    [self.webView setOpaque:NO];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
