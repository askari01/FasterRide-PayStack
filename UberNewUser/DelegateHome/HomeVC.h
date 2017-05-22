//
//  HomeVC.h
//  Wag
//
//  Created by Elluminati - macbook on 20/09/14.
//  Copyright (c) 2014 Elluminati. All rights reserved.
//

#import "BaseVC.h"
#import <CoreLocation/CoreLocation.h>

@interface HomeVC : BaseVC <CLLocationManagerDelegate,UITextViewDelegate>
{
    
}

@property (weak, nonatomic) IBOutlet UIButton *btnSignIn;
@property (weak, nonatomic) IBOutlet UIButton *btnRegister;
@property (weak, nonatomic) IBOutlet UIImageView *imgBG;

@property(nonatomic,weak)IBOutlet UILabel *lblName;

-(IBAction)onClickSignIn:(id)sender;
-(IBAction)onClickRegister:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *lblCopyRights;

@property (weak, nonatomic) IBOutlet UIView *viewForBG;

// view note
@property (weak, nonatomic) IBOutlet UIView *viewNote;
@property (weak, nonatomic) IBOutlet UILabel *lblImpNote;
@property (weak, nonatomic) IBOutlet UITextView *txtNote;
@property (weak, nonatomic) IBOutlet UIButton *btnOK;
-(IBAction)onClickOK:(id)sender;

-(IBAction)onUnwindForLogout:(UIStoryboardSegue *)segueIdentifire;
@end
