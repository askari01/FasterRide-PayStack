//
//  AppDelegate.m
//  UberNewUser
//
//  Created by Elluminati - macbook on 27/09/14.
//  Copyright (c) 2014 Elluminati. All rights reserved.
//

#import "AppDelegate.h"
#import "MBProgressHUD.h"
#import <GoogleMaps/GoogleMaps.h>
#import "Stripe.h"
#import "Constants.h"
#import "ProviderDetailsVC.h"
#import <Paystack/Paystack.h>


@implementation AppDelegate
@synthesize vcProvider;

#pragma mark -
#pragma mark - UIApplication Delegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];
	
	[self registerForRemoteNotifications];
	
    // Use Firebase library to configure APIs
    
    [GIDSignIn sharedInstance].clientID = GOOGLE_PLUS_CLIENT_ID;
    [GIDSignIn sharedInstance].delegate = self;
    
    [Paystack setDefaultPublishableKey:@"pk_test_98da704106b69d8267a13f4789afbdf87b587967"];
    
	return YES;
}
- (void)registerForRemoteNotifications
{
	if(SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(@"10.0"))
		{
			UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
		center.delegate = self;
		[center requestAuthorizationWithOptions:(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error){
			if(!error){
				[[UIApplication sharedApplication] registerForRemoteNotifications];
			}
		}];
	}
	else {
		// Right, that is the point
		if([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0)
			{
			UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIRemoteNotificationTypeBadge
																								 |UIRemoteNotificationTypeSound
																								 |UIRemoteNotificationTypeAlert) categories:nil];
			[[UIApplication sharedApplication] registerUserNotificationSettings:settings];
			}
		else
			{
			//register to receive notifications
				UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
				[[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
			}
	}
	[UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

#pragma mark -
#pragma mark - Push Notification Methods

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    //register to receive notifications
    [application registerForRemoteNotifications];
}

//For interactive notification only
- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void(^)())completionHandler
{
    //handle the actions
    if ([identifier isEqualToString:@"declineAction"]){
    }
    else if ([identifier isEqualToString:@"answerAction"]){
    }
}

-(void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    NSString* strdeviceToken = [[NSString alloc]init];
    strdeviceToken=[self stringWithDeviceToken:deviceToken];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:strdeviceToken forKey:PREF_DEVICE_TOKEN];
    
    [prefs synchronize];
    //UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Token " message:strdeviceToken delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    //[alert show];
    NSLog(@"My token is: %@",strdeviceToken);
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    NSLog(@"Failed to get token, error: %@", error);
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:@"121212121212121212" forKey:PREF_DEVICE_TOKEN];
    [prefs synchronize];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSMutableDictionary *aps=[userInfo valueForKey:@"aps"];
    NSMutableDictionary *msg=[aps valueForKey:@"message"];
    NSLog(@"%@",msg);
    if([msg isKindOfClass:[NSMutableDictionary class]])
    {
        
        dictBillInfo=[msg valueForKey:@"bill"];
        is_walker_started=[[msg valueForKey:@"is_walker_started"] intValue];
        is_walker_arrived=[[msg valueForKey:@"is_walker_arrived"] intValue];
        is_started=[[msg valueForKey:@"is_walk_started"] intValue];
        is_completed=[[msg valueForKey:@"is_completed"] intValue];
        is_dog_rated=[[msg valueForKey:@"is_walker_rated"] intValue];
        if (dictBillInfo!=nil)
        {
            if (vcProvider)
            {
                [vcProvider.timerForTimeAndDistance invalidate];
                vcProvider.timerForCheckReqStatuss=nil;
                [vcProvider checkDriverStatus];
            }
            else
            {
                
            }
            
        }
    }
    //UIAlertView *alert=[[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"%@",msg] message:nil delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:@"cancel", nil];
    //[alert show];

}
-(void)handleRemoteNitification:(UIApplication *)application userInfo:(NSDictionary *)userInfo
{
    NSMutableDictionary *aps=[userInfo valueForKey:@"aps"];
    
    NSMutableDictionary *msg=[aps valueForKey:@"message"];
    dictBillInfo=[msg valueForKey:@"bill"];
    is_walker_started=[[msg valueForKey:@"is_walker_started"] intValue];
    is_walker_arrived=[[msg valueForKey:@"is_walker_arrived"] intValue];
    is_started=[[msg valueForKey:@"is_walk_started"] intValue];
    is_completed=[[msg valueForKey:@"is_completed"] intValue];
    is_dog_rated=[[msg valueForKey:@"is_walker_rated"] intValue];
    //UIAlertView *alert=[[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"%@",msg] message:nil delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:@"cancel", nil];
    //[alert show];
    if (vcProvider)
    {
        [vcProvider checkDriverStatus];
    }
}
- (NSString*)stringWithDeviceToken:(NSData*)deviceToken
{
    const char* data = [deviceToken bytes];
    NSMutableString* token = [NSMutableString string];
    
    for (int i = 0; i < [deviceToken length]; i++)
    {
        [token appendFormat:@"%02.2hhX", data[i]];
    }
    return [token copy] ;
}
//foreground app.
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler
{
	NSLog(@"User Info : %@",notification.request.content.userInfo);
	completionHandler(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge);
}

-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)())completionHandler
{
	NSLog(@"User Info : %@",response.notification.request.content.userInfo);
	completionHandler();
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{/*
  NSUserDefaults * defs = [NSUserDefaults standardUserDefaults];
  NSDictionary * dict = [defs dictionaryRepresentation];
  for (id key in dict) {
  [defs removeObjectForKey:key];
  }
  [defs synchronize];*/
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
	if(viewLoading!=nil)
	{
	[viewLoading removeFromSuperview];
	viewLoading = nil;
	NSString *str = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"LoadingTitle"]];
	[self hideLoadingView];
	[self showLoadingWithTitle:str];
	}
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [FBSDKAppEvents activateApp];
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
- (void)userLoggedIn
{
    // Set the button title as "Log out"
    /*
     SignInVC *obj=[[SignInVC alloc]init];
     UIButton *loginButton = obj.btnFacebook;
     [loginButton setTitle:@"Log out" forState:UIControlStateNormal];
     */
    // Welcome message
    // [self showMessage:@"You're now logged in" withTitle:@"Welcome!"];
    
}

#pragma mark -
#pragma mark - GPPDeepLinkDelegate
- (BOOL)application:(UIApplication *)app
            openURL:(NSURL *)url
            options:(NSDictionary *)options
{
    if([[NSUserDefaults standardUserDefaults]boolForKey:@"google"]==YES)
    {
        return [[GIDSignIn sharedInstance] handleURL:url
                                   sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
                                          annotation:options[UIApplicationOpenURLOptionsAnnotationKey]];
    }
    else
    {
        return [[FBSDKApplicationDelegate sharedInstance] application:app
                                                              openURL:url
                                                    sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
                                                           annotation:options[UIApplicationOpenURLOptionsAnnotationKey]];
    }
    
}

- (BOOL)application: (UIApplication *)application openURL: (NSURL *)url sourceApplication: (NSString *)sourceApplication annotation: (id)annotation
{
    if([[NSUserDefaults standardUserDefaults]boolForKey:@"google"]==YES)
    {
        return [[GIDSignIn sharedInstance] handleURL:url
                                   sourceApplication:sourceApplication
                                          annotation:annotation];
        
    }
    else
    {
        return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                              openURL:url
                                                    sourceApplication:sourceApplication
                                                           annotation:annotation];
    }


}

#pragma mark -
#pragma mark - sharedAppDelegate

+(AppDelegate *)sharedAppDelegate
{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

#pragma mark -
#pragma mark - Loading View

-(void)showLoadingWithTitle:(NSString *)title{
    if (viewLoading==nil)
    {
		[[NSUserDefaults standardUserDefaults]setValue:title forKey:@"LoadingTitle"];

        viewLoading=[[UIView alloc]initWithFrame:self.window.bounds];
        viewLoading.backgroundColor = [UIColor clearColor];
        UIImageView *imgs=[[UIImageView alloc] initWithFrame:self.window.bounds];
	[imgs setBackgroundColor:ProfileViewColor];
       // imgs.image=[UIImage imageNamed:@"bg_loding"];
        imgs.alpha=0.90;
        UIImageView *img=[[UIImageView alloc]initWithFrame:CGRectMake((viewLoading.frame.size.width/2)-(viewLoading.frame.size.width/4),(viewLoading.frame.size.height/2)-(viewLoading.frame.size.height/4),(viewLoading.frame.size.width/3),(viewLoading.frame.size.height/3))];
        
        UIImageView *imgCar = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Car_loading"]];
        
        imgCar.center=viewLoading.center;
        img.center=viewLoading.center;
        img.backgroundColor=[UIColor clearColor];
        img.contentMode=UIViewContentModeCenter;
        img.image=[UIImage imageNamed:@"loading_ring"];
        img.animationDuration = 1.0f;
        img.animationRepeatCount = 0;
        [viewLoading addSubview:imgs];
        [viewLoading addSubview:img];
        [viewLoading addSubview:imgCar];
        [img startAnimating];
        UITextView *txt=[[UITextView alloc]initWithFrame:CGRectMake(viewLoading.frame.origin.x+20, (viewLoading.frame.origin.y+viewLoading.frame.size.height - 170), viewLoading.frame.size.width-40, 60)];
        txt.textAlignment=NSTextAlignmentCenter;
        txt.backgroundColor=[UIColor clearColor];
        txt.text=[title uppercaseString];
        txt.font=[UIFont fontWithName:@"Arial" size:17];
        txt.alpha=0.9;
        txt.userInteractionEnabled=FALSE;
        txt.scrollEnabled=FALSE;
        txt.textColor=[UIColor whiteColor];
        [viewLoading addSubview:txt];
        img.transform = CGAffineTransformMakeScale(0.6f, 0.6f);
        [UIView animateWithDuration:0.6 delay:0 options: UIViewAnimationOptionAutoreverse| UIViewAnimationOptionRepeat| UIViewAnimationOptionCurveEaseOut animations:^{
            // animate it to the identity transform (100% scale)
            
            CGAffineTransform scaleTrans = CGAffineTransformMakeScale(1.0f, 1.0f);
            img.transform = scaleTrans;
        } completion:^(BOOL finished){
            
        }];
	[self.window addSubview:viewLoading];
	[self.window bringSubviewToFront:viewLoading];

    }

}
-(void)hideLoadingView
{
	if (viewLoading)
	{
		[viewLoading removeFromSuperview];
		viewLoading=nil;
		[[NSUserDefaults standardUserDefaults]removeObjectForKey:@"LoadingTitle"];
		[[NSUserDefaults standardUserDefaults]synchronize];
	}

}

-(void) showHUDLoadingView:(NSString *)strTitle
{
    if (HUD==nil) {
        HUD = [[MBProgressHUD alloc] initWithView:self.window];
        [self.window addSubview:HUD];
    }
    
    //HUD.delegate = self;
    //HUD.labelText = [strTitle isEqualToString:@""] ? @"Loading...":strTitle;
    HUD.detailsLabelText=[strTitle isEqualToString:@""] ? @"Loading...":strTitle;
    [HUD show:YES];
}

-(void) hideHUDLoadingView
{
    //[HUD removeFromSuperview];
    [HUD hide:YES];
}

-(void)showToastMessage:(NSString *)message
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.window
                                              animated:YES];
    
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.detailsLabelText = message;
    hud.margin = 10.f;
    hud.yOffset = 150.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:2.0];
}
#pragma mark - Application's Documents directory

/**
 Returns the URL to the application's Documents directory.
 */
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}
#pragma mark -
#pragma mark - Directory Path Methods

- (NSString *)applicationCacheDirectoryString
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cacheDirectory = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return cacheDirectory;
}
- (BOOL)connected
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return networkStatus != NotReachable;
}

#pragma mark-
#pragma mark- Font Descriptor

-(id)setBoldFontDiscriptor:(id)objc
{
    if([objc isKindOfClass:[UIButton class]])
    {
        UIButton *button=objc;
        button.titleLabel.font = [UIFont fontWithName:@"OpenSans-Bold" size:13.0f];
        return button;
    }
    else if([objc isKindOfClass:[UITextField class]])
    {
        UITextField *textField=objc;
        textField.font = [UIFont fontWithName:@"OpenSans-Bold" size:13.0f];
        return textField;
    }
    else if([objc isKindOfClass:[UILabel class]])
    {
        UILabel *lable=objc;
        lable.font = [UIFont fontWithName:@"OpenSans-Bold" size:13.0f];
        return lable;
    }
    return objc;
}


@end
