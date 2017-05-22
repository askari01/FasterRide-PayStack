//
//  LoginVC.h
//  Uber
//
//  Created by Elluminati - macbook on 21/06/14.
//  Copyright (c) 2014 Elluminati MacBook Pro 1. All rights reserved.
//

#import "BaseVC.h"
#import "Reachability.h"
//#import <GooglePlus/GooglePlus.h>
//#import <GoogleOpenSource/GoogleOpenSource.h>

@interface LoginVC : BaseVC<UITextFieldDelegate,UIGestureRecognizerDelegate,GIDSignInDelegate>
{
    
}

@property (weak, nonatomic) IBOutlet UIButton *btnSignIn;
@property (weak, nonatomic) IBOutlet UIButton *btnForgotPsw;
@property (weak, nonatomic) IBOutlet UIButton *btnSignUp;
@property (weak, nonatomic) IBOutlet UIButton *btnDontHaveAccount;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UILabel *lblSignInWith;
@property (weak, nonatomic) IBOutlet UILabel *lblUsername;
@property (weak, nonatomic) IBOutlet UILabel *lblPassword;

@property NetworkStatus internetConnectionStatus;
@property(nonatomic,weak)IBOutlet UIScrollView *scrLogin;
@property(nonatomic,weak)IBOutlet UITextField *txtEmail;
@property(nonatomic,weak)IBOutlet UITextField *txtPsw;
@property (weak, nonatomic) IBOutlet UIView *viewForBG;

- (IBAction)onClickForback:(id)sender;
- (IBAction)onclickForMoveRegtister:(id)sender;

- (IBAction)onClickGooglePlus:(id)sender;
- (IBAction)onClickFacebook:(id)sender;

-(IBAction)onClickLogin:(id)sender;
-(IBAction)onClickForgotPsw:(id)sender;

@end
