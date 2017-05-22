//
//  ReferralCodeVC.h
//  UberforXOwner
//
//  Created by Elluminati on 21/11/14.
//  Copyright (c) 2014 Elluminati. All rights reserved.
//

#import "BaseVC.h"
#import <MessageUI/MFMailComposeViewController.h>
#import <MessageUI/MessageUI.h>

@interface ReferralCodeVC : BaseVC <MFMailComposeViewControllerDelegate>
- (IBAction)shareBtnPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *lblCode;
@property (weak, nonatomic) IBOutlet UIButton *btnShare;
@property (weak, nonatomic) IBOutlet UILabel *lblYour;
@property (weak, nonatomic) IBOutlet UIButton *btnNavigation;
@property (weak, nonatomic) IBOutlet UILabel *lblBalance;
@property (weak, nonatomic) IBOutlet UILabel *lblCredit;
@property (weak, nonatomic) IBOutlet UILabel *lblYourReferralCredit;
@property (weak, nonatomic) IBOutlet UILabel *lblYourReferralCode;
@property (weak, nonatomic) IBOutlet UILabel *lblReferralTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblShareReferralMessage;
@property (weak, nonatomic) IBOutlet UILabel *lblBgRefrelCode;
@property (weak, nonatomic) IBOutlet UILabel *lblBgRefrelCredit;

- (IBAction)BackButtonPressed:(id)sender;

@end