//
//  LoginVC.m
//  Uber
//
//  Created by Elluminati - macbook on 21/06/14.
//  Copyright (c) 2014 Elluminati MacBook Pro 1. All rights reserved.

#import "LoginVC.h"
#import "AppDelegate.h"
#import "AFNHelper.h"
#import "Constants.h"
#import "UtilityClass.h"
#import "UberStyleGuide.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "GoogleUtility.h"


static NSString *const kKeychainItemName = @"Google OAuth2 For gglplustest";
//static NSString *const kClientID = GOOGLE_PLUS_CLIENT_ID;
//static NSString *const kClientSecret = @"aUerqYEidSMauUa1hCPVUi9A";

@interface LoginVC ()
{
    NSString *strForSocialId,*strLoginType,*strForEmail;
    AppDelegate *appDelegate;
    int reTrive;
}

@end

@implementation LoginVC

#pragma mark -
#pragma mark - Init

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

#pragma mark -
#pragma mark - ViewLife Cycle

- (void)viewDidLoad
{
    reTrive=0;
    [super viewDidLoad];
    [self setLocalization];
	[self.viewForBG setBackgroundColor:ProfileViewColor];
	
    [super setNavBarTitle:NSLocalizedString(@"SIGN IN", nil)];
    [super setBackBarItem];
	
	[self.btnSignIn setBackgroundColor:LightBtnColor];
	[self.backBtn setBackgroundColor:DarkBtnColor];
    strLoginType=@"manual";
    
    self.txtEmail.font=[UberStyleGuide fontRegularLight];
    self.txtPsw.font=[UberStyleGuide fontRegularLight];

    //self.btnSignIn=[APPDELEGATE setBoldFontDiscriptor:self.btnSignIn];
    self.btnForgotPsw=[APPDELEGATE setBoldFontDiscriptor:self.btnForgotPsw];
    self.btnSignUp=[APPDELEGATE setBoldFontDiscriptor:self.btnSignUp];
    
    UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapGesture:)];
    singleTapGestureRecognizer.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:singleTapGestureRecognizer];
    [self.backBtn setTitle:NSLocalizedString(@"Back", nil) forState:UIControlStateNormal];
    [self.backBtn setTitle:NSLocalizedString(@"Back", nil) forState:UIControlStateSelected];
    self.lblSignInWith.text = NSLocalizedString(@"SIGN IN WITH", nil);
    self.lblUsername.text = NSLocalizedString(@"USERNAME", nil);
    self.lblPassword.text = NSLocalizedString(@"PASSWORD*", nil);
    [self.btnDontHaveAccount setTitle:NSLocalizedString(@"don't account register", nil) forState:UIControlStateNormal];
    [self.btnDontHaveAccount setTitle:NSLocalizedString(@"don't account register", nil) forState:UIControlStateSelected];
}

-(void)viewWillAppear:(BOOL)animated
{
    FBSDKLoginManager *logout = [[FBSDKLoginManager alloc] init];
    [logout logOut];
    self.navigationController.navigationBarHidden=YES;
}

-(void)setLocalization
{
    self.txtEmail.placeholder=NSLocalizedString(@"Email", nil);
    self.txtPsw.placeholder=NSLocalizedString(@"Password", nil);
    [self.btnForgotPsw setTitle:NSLocalizedString(@"Forgot Password", nil) forState:UIControlStateNormal];
    [self.btnSignIn setTitle:NSLocalizedString(@"SIGN IN", nil) forState:UIControlStateNormal];
}
- (void)viewDidAppear:(BOOL)animated
{
     [self.btnSignUp setTitle:NSLocalizedString(@"SIGN IN", nil) forState:UIControlStateNormal];
}

#pragma mark -back 


- (IBAction)onClickForback:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark -move to direct register :

- (IBAction)onclickForMoveRegtister:(id)sender
{
    
    [self performSegueWithIdentifier:SEGUE_TO_DIRCET_REGI sender:self];
    
}

#pragma mark -
#pragma mark - Actions

- (IBAction)onClickGooglePlus:(id)sender
{
    [self.navigationController setNavigationBarHidden:NO];
    strLoginType=@"google";
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"google"];
    [[GoogleUtility sharedObject]signInGoogle:^(BOOL success, GIDGoogleUser* user, NSError* error)
     {
         if (success)
         {
             //[dictparam setObject:user.userID forKey:PARAM_SOCIAL_ID];
             strLoginType = @"google";
             //  strLoginBy=GOOGLE;
             strForEmail=user.profile.email;
             self.txtEmail.text = strForEmail;
             self.txtPsw.userInteractionEnabled = NO;
             strForSocialId = user.userID;
             
             [appDelegate showLoadingWithTitle:NSLocalizedString(@"ALREADY_LOGIN", nil)];
             [self onClickLogin:nil];
         }
     }withParent:self];
}
- (IBAction)onClickFacebook:(id)sender
{
    strLoginType=@"facebook";
    
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"google"];
    
    if ([APPDELEGATE connected])
    {
        FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
        
        [loginManager
         logInWithReadPermissions: @[@"public_profile", @"email", @"user_friends"]
         fromViewController:self
         handler:^(FBSDKLoginManagerLoginResult *result, NSError *error)
         {
             if (error) {
                 NSLog(@"Process error");
             } else if (result.isCancelled) {
                 NSLog(@"Cancelled");
             } else {
                 NSLog(@"Logged in");
                 [APPDELEGATE showLoadingWithTitle:@"Please wait"];
                 
                 if ([FBSDKAccessToken currentAccessToken]) {
                     
                     FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                                   initWithGraphPath:@"me"
                                                   parameters:@{@"fields": @"first_name, last_name, picture.type(large), email, name, id, gender"}
                                                   HTTPMethod:@"GET"];
                     [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                                           id result,
                                                           NSError *error) {
                         NSLog(@"%@",result);
                         // Handle the result
                         [APPDELEGATE hideLoadingView];
                         
                         self.txtEmail.text=[result valueForKey:@"email"];
                         
                         strForSocialId=[result valueForKey:@"id"];
                         strForEmail=[result valueForKey:@"email"];
                         self.txtEmail.text=strForEmail;
                         [[AppDelegate sharedAppDelegate]hideLoadingView];
                         
                         [self onClickLogin:nil];
                     }];
                 }
             }
         }];
        
        [loginManager logOut];
        
    }
    else
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"NO_INTERNET_TITLE", nil) message:NSLocalizedString(@"NO_INTERNET", nil) delegate:self
                                           cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil, nil];
        [alert show];
        
    }
}

-(IBAction)onClickLogin:(id)sender
{
    if([[AppDelegate sharedAppDelegate]connected])
    {
        if(self.txtEmail.text.length>0)
        {
            [[AppDelegate sharedAppDelegate]showLoadingWithTitle:NSLocalizedString(@"LOGIN", nil)];
            
            NSString *strDeviceId=[PREF objectForKey:PREF_DEVICE_TOKEN];
            
            if (strDeviceId==nil || [strDeviceId isEqualToString:@""] || [strDeviceId isKindOfClass:[NSNull class]] || strDeviceId.length < 1)
            {
                strDeviceId=@"11111";
            }
            
            NSMutableDictionary *dictParam=[[NSMutableDictionary alloc]init];
            [dictParam setValue:@"ios" forKey:PARAM_DEVICE_TYPE];
            [dictParam setValue:strDeviceId forKey:PARAM_DEVICE_TOKEN];
            if([strLoginType isEqualToString:@"manual"])
                [dictParam setValue:self.txtEmail.text forKey:PARAM_EMAIL];
             else
                 [dictParam setValue:strForEmail forKey:PARAM_EMAIL];
            
            [dictParam setValue:strLoginType forKey:PARAM_LOGIN_BY];
            
            if([strLoginType isEqualToString:@"facebook"])
                [dictParam setValue:strForSocialId forKey:PARAM_SOCIAL_UNIQUE_ID];
            else if ([strLoginType isEqualToString:@"google"])
                [dictParam setValue:strForSocialId forKey:PARAM_SOCIAL_UNIQUE_ID];
            else
                [dictParam setValue:self.txtPsw.text forKey:PARAM_PASSWORD];
            
            AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:POST_METHOD];
            [afn getDataFromPath:FILE_LOGIN withParamData:dictParam withBlock:^(id response, NSError *error)
             {
                 [[AppDelegate sharedAppDelegate]hideLoadingView];
                 
                 NSLog(@"Login Response ---> %@",response);
                 if (response)
                 {
                     if([[response valueForKey:@"success"]boolValue])
                     {
                         NSString *strLog=[NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"LOGIN_SUCCESS", nil),[response valueForKey:@"first_name"]];
                         
                         [APPDELEGATE showToastMessage:strLog];
                         
                         stripePublishableKey = [NSString stringWithFormat:@"%@",[response valueForKey:@"stripe_publishable_key"]];
                         
                         [PREF setObject:response forKey:PREF_LOGIN_OBJECT];
                         [PREF setObject:[response valueForKey:@"token"] forKey:PREF_USER_TOKEN];
                         [PREF setObject:[response valueForKey:@"id"] forKey:PREF_USER_ID];
                         [PREF setObject:[response valueForKey:@"is_referee"] forKey:PREF_IS_REFEREE];
                         [PREF setObject:stripePublishableKey forKey:@"stripe_key"];
                         
                         [PREF setBool:YES forKey:PREF_IS_LOGIN];
                         
                         [PREF synchronize];
                         
                         [self performSegueWithIdentifier:SEGUE_SUCCESS_LOGIN sender:self];
                     }
                     else
                     {
						strLoginType = @"manual";
						self.txtEmail.text = @"";
						self.txtPsw.text = @"";
						self.txtPsw.userInteractionEnabled = YES;
						for (NSArray *arr in [response valueForKey:@"error_messages"]) {
							NSString *str=[NSString stringWithFormat:@"%@",arr];
							UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:[afn getErrorMessage:str] delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil, nil];
							[alert show];
							break;
						}
					 reTrive-- ;
					 }
                 }
             }];
        }
        else
        {
            if(self.txtEmail.text.length==0)
            {
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:NSLocalizedString(@"PLEASE_EMAIL", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil, nil];
                [alert show];
            }
            else
            {
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:NSLocalizedString(@"PLEASE_PASSWORD", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil, nil];
                [alert show];
            }
        }
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Network Status", nil) message:NSLocalizedString(@"NO_INTERNET", nil) delegate:self cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"OK", nil), nil];
        [alert show];
    }
}

-(IBAction)onClickForgotPsw:(id)sender
{
    [self textFieldShouldReturn:self.txtPsw];
    /*
    if (self.txtEmail.text.length==0)
    {
        [[UtilityClass sharedObject]showAlertWithTitle:@"" andMessage:@"Enter your email id."];
        return;
    }
    else if (![[UtilityClass sharedObject]isValidEmailAddress:self.txtEmail.text])
    {
        [[UtilityClass sharedObject]showAlertWithTitle:@"" andMessage:@"Enter valid email id."];
        return;
    }
     */
}

#pragma mark -
#pragma mark - TextField Delegate
-(void)handleSingleTapGesture:(UITapGestureRecognizer *)tapGestureRecognizer;
{
    [self.txtEmail resignFirstResponder];
    [self.txtPsw resignFirstResponder];
	[self.scrLogin setContentOffset:CGPointMake(0, 0) animated:YES];
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    int y=0;
    if (textField==self.txtEmail)
    {
        y=140;
    }
    else if (textField==self.txtPsw){
        y=160;
    }
    [self.scrLogin setContentOffset:CGPointMake(0, y) animated:YES];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField==self.txtEmail)
    {
        [self.txtPsw becomeFirstResponder];
    }
    else if (textField==self.txtPsw){
        [textField resignFirstResponder];
        [self.scrLogin setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    return YES;
}

#pragma mark -
#pragma mark - Memory Mgmt

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
