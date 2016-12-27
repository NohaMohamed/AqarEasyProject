//
//  AppDelegate.m
//  AqarEasy
//
//  Created by Eng. Eman Rezk on 11/11/14.
//  Copyright (c) 2014 Eng.Eman.Rezk. All rights reserved.
//

#import "AppDelegate.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import "APIControlManager.h"
#import "AqarEasyUser.h"
#import <DIOSSession.h>
#import "Constant.h"
#import <DIOSFile.h>
#import <DIOSSession.h>
#import "SDK_API_Controller.h"
#import <DIOSUser.h>
#import <AFNetworking.h>
#import "Utility.h"
#import "iRate.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


+ (void)initialize
{
    //configure iRate
    [iRate sharedInstance].promptAtLaunch=NO;
    [iRate sharedInstance].daysUntilPrompt = 5;
    [iRate sharedInstance].usesUntilPrompt = 15;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
 
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithObjects:@"en", nil] forKey:@"AppleLanguages"];

    
    
    
    
    /*
    NSArray *arr = @[@"ram",@"Ram",@"vinoth",@"kiran",@"kiran"];
    NSArray *lowerCaseArr = [arr valueForKey:@"lowercaseString"];
    NSSet* uniqueName = [[NSSet alloc] initWithArray:lowerCaseArr];
    NSLog(@"Unique Names :%@",uniqueName);
    */
    //make sure that adview returns the same uid for the current logged user so the user can only edit his aqars not other user
    
  //adview get images and draw it below choose photo , camera and keep fid because maybe user delete these files and add others
    //
    
  // geocoding in add aqar  exm https://maps.googleapis.com/maps/api/geocode/json?address=الاسكندريه
    
    //remove location updates in map search because we don't need and focus update on Europe
    
    //in search by map any node that has no lat or long don't draw it
    
    
    [[SDImageCache sharedImageCache] setMaxCacheSize:0];
    
    [Fabric with:@[[Crashlytics class]]];
    
    //[DIOSSession setupDios];
    [DIOSSession setupDiosWithURL:@"http://aqareasy.com:8080"];
       
    //Set Font to NavigationBar title
    NSDictionary *navbarTitleTextAttributes = @{NSFontAttributeName: [UIFont fontWithName:@"DroidArabicNaskh-Bold" size:14.0]};
    
    [[UINavigationBar appearance] setTitleTextAttributes:navbarTitleTextAttributes];
    
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:80/255.0 green:81/255.0 blue:73/255.0 alpha:1]];
    [[UINavigationBar appearance] setTranslucent:NO];
    [NSThread sleepForTimeInterval:1];
    
     //10000978 my id when i registered
    //http://aqareasy.com/api/taxonomy/getTree
    //application/x-www-form-urlencoded
    //maxdepth=1&parent=0&vid=2
    
    
    //[self getUnloggedToken];
      // Override point for customization after application launch.
    return YES;
}

-(void)logout{
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@user/logout",BASE_URL]]];
    
    if ([[AqarEasyUser sharedInstance] getSessionId]) {
    
    [request setValue:[[AqarEasyUser sharedInstance] getSessionId] forHTTPHeaderField:@"Cookie"];
    [request setValue:[[AqarEasyUser sharedInstance] getSessionToken] forHTTPHeaderField:@"X-CSRF-Token"];
    [request setValue:[[AqarEasyUser sharedInstance] getSessionName] forHTTPHeaderField:[[AqarEasyUser sharedInstance] getSessionId]];
    
    [request setValue:[[AqarEasyUser sharedInstance] getSessionId] forHTTPHeaderField:[[AqarEasyUser sharedInstance] getSessionName]];
    }
    
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    
    [request setHTTPMethod:@"POST"];
  
    
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        id ret=  [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSLog(@"===============%@",  ret);
       
    }];
}

-(void)getUnloggedToken{
    //http://aqareasy.com/services/session/token
    //http://aqareasy.com/api/services/session/token
   
   
   [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:URL_SESSION]] queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        if (data) {
            NSString *token=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            [[AqarEasyUser sharedInstance] setUnloggedToken:token];
        }
  }];
}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [self logout];
    /*
    [[APIControlManager sharedInstance] postData:@"user/logout" withParms:nil withCompletionBlock:^(id ret) {
        NSLog(@"===============%@",  ret);
    }];*/
}
/*
- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    
    if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone)
    {
       
        UIViewController *currentViewController = [self topViewController];
        
        if ([currentViewController respondsToSelector:@selector(canAutoRotate)]) {
            NSMethodSignature *signature = [currentViewController methodSignatureForSelector:@selector(canAutoRotate)];
            
            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
            
            [invocation setSelector:@selector(canAutoRotate)];
            [invocation setTarget:currentViewController];
            
            [invocation invoke];
            
            BOOL canAutorotate = NO;
            [invocation getReturnValue:&canAutorotate];
            
            if (canAutorotate) {
                return UIInterfaceOrientationMaskAll;
            }
        }
        
        return UIInterfaceOrientationMaskPortrait;
        
    }
    else
    {
        return UIInterfaceOrientationMaskLandscape;
    }
    
    
}

- (UIViewController *)topViewController
{
    return [self topViewControllerWithRootViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
}

- (UIViewController *)topViewControllerWithRootViewController:(UIViewController *)rootViewController
{
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController* tabBarController = (UITabBarController*)rootViewController;
        return [self topViewControllerWithRootViewController:tabBarController.selectedViewController];
    } else if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController* navigationController = (UINavigationController*)rootViewController;
        return [self topViewControllerWithRootViewController:navigationController.visibleViewController];
    } else if (rootViewController.presentedViewController) {
        UIViewController* presentedViewController = rootViewController.presentedViewController;
        return [self topViewControllerWithRootViewController:presentedViewController];
    } else {
        return rootViewController;
    }
}
*/


- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window

{
    if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone)
    {
        if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"landscacpe"] isEqualToString:@"yes"]) {
            
            return UIInterfaceOrientationMaskAll;
            //return UIInterfaceOrientationMaskLandscape|UIInterfaceOrientationMaskPortrait;
        
        } else {
        
            return UIInterfaceOrientationMaskPortrait;
        }
        
    }
    else
    {

        if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"orn"] isEqualToString:@"allowOrientation"]) {
            return UIInterfaceOrientationMaskAll;
            
        }
        //
        return UIInterfaceOrientationMaskLandscape;
    }
    
}

@end
