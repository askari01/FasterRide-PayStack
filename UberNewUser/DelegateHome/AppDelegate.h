//
//  AppDelegate.h
//  UberNewUser
//
//  Created by Elluminati - macbook on 27/09/14.
//  Copyright (c) 2014 Elluminati. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"
#import <GoogleSignIn/GoogleSignIn.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <UserNotifications/UserNotifications.h>

#define SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

@class MBProgressHUD,ProviderDetailsVC;
@interface AppDelegate : UIResponder <UIApplicationDelegate,UNUserNotificationCenterDelegate,GIDSignInDelegate>
{
    MBProgressHUD *HUD;
    UIView *viewLoading;
}
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) ProviderDetailsVC *vcProvider;
+(AppDelegate *)sharedAppDelegate;

-(void) showHUDLoadingView:(NSString *)strTitle;
-(void) hideHUDLoadingView;
-(void)showToastMessage:(NSString *)message;

-(void)showLoadingWithTitle:(NSString *)title;
-(void)hideLoadingView;
-(id)setBoldFontDiscriptor:(id)objc;

- (void)userLoggedIn;
- (NSString *)applicationCacheDirectoryString;
- (BOOL)connected;

@end
