//
//  HomeVC.m
//  Wag
//
//  Created by Elluminati - macbook on 20/09/14.
//  Copyright (c) 2014 Elluminati. All rights reserved.

#import "HomeVC.h"
#import "LoginVC.h"
#import "RegisterVC.h"
#import <CoreLocation/CoreLocation.h>
#import "Constants.h"
#import "AFNHelper.h"
#import "AppDelegate.h"
#import <GoogleMaps/GoogleMaps.h>

@interface HomeVC ()
{
    CLLocationManager *locationManager;
    BOOL internet,is_first;
}
@end

@implementation HomeVC

#pragma mark -
#pragma mark - Init

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

#pragma mark -
#pragma mark - ViewLife Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    is_first = true;
	[self.viewForBG setBackgroundColor:ProfileViewColor];

    [self GetGoolePlusKeys];
	
	[self.imgBG setBackgroundColor:ProfileViewColor];
	[self.btnSignIn setBackgroundColor:LightBtnColor];
	[self.btnRegister setBackgroundColor:DarkBtnColor];
	[self.btnOK setBackgroundColor:DarkBtnColor];
	
    self.navigationController.navigationBarHidden=YES;
    
    self.lblCopyRights.text = NSLocalizedString(@"COPYRIGHTS_NOTE", nil);
    [self.btnSignIn setTitle:NSLocalizedString(@"SIGN IN", nil) forState:UIControlStateNormal];
    [self.btnSignIn setTitle:NSLocalizedString(@"SIGN IN", nil) forState:UIControlStateSelected];
    [self.btnRegister setTitle:NSLocalizedString(@"Registerr", nil) forState:UIControlStateNormal];
    [self.btnRegister setTitle:NSLocalizedString(@"Registerr", nil) forState:UIControlStateSelected];
    
    //view note Localized strings
    
    self.viewNote.frame = self.view.frame;
    self.lblImpNote.text = NSLocalizedString(@"IMPORTANT_NOTE", nil);
    self.txtNote.text = NSLocalizedString(@"IMPORTANT_NOTE_TEXT", nil);
    [self.btnOK setTitle:NSLocalizedString(@"OK", nil) forState:UIControlStateNormal];
    
   // [APPDELEGATE.window addSubview:self.viewNote];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if([PREF boolForKey:PREF_IS_LOGIN])
    {
        [[AppDelegate sharedAppDelegate]showLoadingWithTitle:NSLocalizedString(@"ALREADY_LOGIN", nil)];
        self.navigationController.navigationBarHidden=YES;
        stripePublishableKey = [PREF valueForKey:@"stripe_key"];
        strForGooglePlusClientId = [PREF valueForKey:@"Google_Client_id"];
        strForGooglePlusClientSecret = [PREF valueForKey:@"Google_Client_secret"];
        strForGoogleMapKey = [PREF valueForKey:@"Google_Map_key"];
        [GMSServices provideAPIKey:strForGoogleMapKey];
        if(is_first)
        {
            is_first = false;
            [self performSegueWithIdentifier:SEGUE_TO_DIRECT_LOGIN sender:self];
        }
    }
    if(![PREF boolForKey:PREF_IS_LOGIN])
        self.navigationController.navigationBarHidden=YES;
}

-(void)viewWillDisappear:(BOOL)animated
{
    if(![PREF boolForKey:PREF_IS_LOGIN])
        self.navigationController.navigationBarHidden=NO;
    [super viewWillDisappear:animated];
}

-(void)GetGoolePlusKeys
{
    if([APPDELEGATE connected])
    {
        NSMutableString *url=[NSMutableString stringWithFormat:@"%@",FILE_GET_GOOGLE_KEYS];
        
        AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:GET_METHOD];
        [afn getDataFromPath:url withParamData:nil withBlock:^(id response, NSError *error)
         {
             NSLog(@"Keys = %@",response);
             if (response)
             {
                 if([[response valueForKey:@"success"] intValue]==1)
                 {
                     NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                     
                     dict = [response valueForKey:@"user"];
                     strForGooglePlusClientId = [dict valueForKey:@"Google_Client_id"];
                     strForGooglePlusClientSecret = [dict valueForKey:@"Google_Client_secret"];
                     strForGoogleMapKey = [dict valueForKey:@"Google_Map_key"];
                     [GMSServices provideAPIKey:strForGoogleMapKey];
                     [PREF setValue:strForGoogleMapKey forKey:@"Google_Map_key"];
                     [PREF setValue:strForGooglePlusClientId forKey:@"Google_Client_id"];
                     [PREF setValue:strForGooglePlusClientSecret forKey:@"Google_Client_secret"];
                     [PREF synchronize];
                     [self checkStatus];
                 }
             }
         }];
    }
    else
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"No Internet" message:NSLocalizedString(@"NO_INTERNET", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil, nil];
        [alert show];
    }
}

-(void)checkStatus
{
    internet=[APPDELEGATE connected];
    if ([CLLocationManager locationServicesEnabled])
    {
       // [[AppDelegate sharedAppDelegate]showLoadingWithTitle:NSLocalizedString(@"LOGIN", nil)];
        if(internet)
        {
            [self getUserLocation];
            self.lblName.text=NSLocalizedString(APPLICATION_NAME, nil);
            
            if([PREF boolForKey:PREF_IS_LOGIN])
            {
                [[AppDelegate sharedAppDelegate]showLoadingWithTitle:NSLocalizedString(@"ALREADY_LOGIN", nil)];
                self.navigationController.navigationBarHidden=YES;
               // [[AppDelegate sharedAppDelegate]hideLoadingView];
                if(is_first)
                {
                    is_first = false;
                    [self performSegueWithIdentifier:SEGUE_TO_DIRECT_LOGIN sender:self];
                }
            }
        }
        else
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"No Internet" message:NSLocalizedString(@"NO_INTERNET", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil, nil];
            [alert show];
        }
       // [[AppDelegate sharedAppDelegate]hideLoadingView];
    }
    else
    {
        
        UIAlertView *alertLocation=[[UIAlertView alloc]initWithTitle:@"" message:NSLocalizedString(@"Enable Location access", nil) delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        alertLocation.tag=100;
        [alertLocation show];
    }
}

#pragma mark -
#pragma mark - Actions

-(IBAction)onClickSignIn:(id)sender
{
    //[self performSegueWithIdentifier:@"" sender:self];
}

-(IBAction)onClickRegister:(id)sender
{
    
}
-(IBAction)onClickOK:(id)sender
{
    [self.viewNote removeFromSuperview];
    
}

#pragma mark -
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    //segue.identifier
}


#pragma mark-
#pragma mark- Text Field Delegate
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    return NO;
}

#pragma mark -
#pragma mark - Memory Mgmt

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)getUserLocation
{
    [locationManager startUpdatingLocation];
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate=self;
    locationManager.desiredAccuracy=kCLLocationAccuracyBest;
    locationManager.distanceFilter=kCLDistanceFilterNone;
    
#ifdef __IPHONE_8_0
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8")) {
        // Use one or the other, not both. Depending on what you put in info.plist
        [locationManager requestWhenInUseAuthorization];
        //[locationManager requestAlwaysAuthorization];
    }
#endif
    [locationManager startUpdatingLocation];
}


-(IBAction)onUnwindForLogout:(UIStoryboardSegue *)segueIdentifire
{
    [PREF removeObjectForKey:PREF_USER_TOKEN];
    [PREF removeObjectForKey:PREF_REQ_ID];
    [PREF removeObjectForKey:PREF_IS_LOGOUT];
    [PREF removeObjectForKey:PREF_USER_ID];
    [PREF removeObjectForKey:PREF_IS_LOGIN];
    [PREF synchronize];
}
@end
