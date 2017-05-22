//
//  ProfileVC.h
//  UberNew
//
//  Created by Elluminati - macbook on 26/09/14.
//  Copyright (c) 2014 Elluminati. All rights reserved.
//

#import "BaseVC.h"

@interface ProfileVC : BaseVC <UITextFieldDelegate, UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>


@property (weak, nonatomic) IBOutlet UIImageView *proPicImgv;
@property (weak, nonatomic) IBOutlet UIButton *btnProPic;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollv;
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtPhone;
@property (weak, nonatomic) IBOutlet UITextField *txtCurrentPWD;
@property (weak, nonatomic) IBOutlet UITextField *txtNewPWD;
@property (weak, nonatomic) IBOutlet UITextField *txtConformPWD;
@property (weak, nonatomic) IBOutlet UITextField *txtName1;
@property (weak, nonatomic) IBOutlet UITextField *txtName;
@property (weak, nonatomic) IBOutlet UIButton *btnUpdate;
@property (weak, nonatomic) IBOutlet UIButton *btnNavigation;

@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblEmail;
@property (weak, nonatomic) IBOutlet UILabel *lblPassword;
@property (weak, nonatomic) IBOutlet UILabel *lblNewPassword;
@property (weak, nonatomic) IBOutlet UILabel *lblConfirmPassword;
@property (weak, nonatomic) IBOutlet UILabel *lblPhone;
@property (weak, nonatomic) IBOutlet UIView *viewForBG;
@property (weak, nonatomic) IBOutlet UIView *viewForPassword;
@property (weak, nonatomic) IBOutlet UIView *viewForPhoneNumber;

- (IBAction)WritingName:(id)sender;
- (IBAction)selectPhotoBtnPressed:(id)sender;
- (IBAction)backButtonPressed:(id)sender;
- (IBAction)updateBtnPressed:(id)sender;

@end
