//
//  FeedBackVC.h
//  UberNewUser
//
//  Created by Elluminati on 01/11/14.
//  Copyright (c) 2014 Elluminati. All rights reserved.
//

#import "BaseVC.h"
#import "RatingBar.h"
#import "SWRevealViewController.h"
#import "PTKTextField.h"
#import <Paystack/Paystack.h>
#import <Paystack/PSTCKAPIClient.h>

@interface FeedBackVC : BaseVC <UITextViewDelegate>
{
    RatingBar *ratingView;
    NSString *strForLastFour;

}
@property(nonatomic) PSTCKPaymentCardTextField *paymentTextField;
@property (weak, nonatomic) IBOutlet UIImageView *imgPaymentBg;
@property (weak, nonatomic) IBOutlet UILabel *lblBgInvoice;
@property (weak, nonatomic) IBOutlet UILabel *lblBgGreenInvoice;

//////////// Outlets Price Label
@property (weak, nonatomic) IBOutlet UILabel *lblPaymentMode;
@property (weak, nonatomic) IBOutlet UILabel *lblPaymentModeTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblBasePrice;
@property (weak, nonatomic) IBOutlet UILabel *lblDistCost;
@property (weak, nonatomic) IBOutlet UILabel *lblTimeCost;
@property (weak, nonatomic) IBOutlet UILabel *lblTotal;
@property (weak, nonatomic) IBOutlet UILabel *lblPerDist;
@property (weak, nonatomic) IBOutlet UILabel *lblPerTime;
@property (weak, nonatomic) IBOutlet UILabel *lblPromoBouns;
@property (weak, nonatomic) IBOutlet UILabel *lblRferralBouns;
@property (nonatomic,strong) NSString *strUserImg;
@property (nonatomic,strong) NSMutableDictionary *dictWalkInfo;
@property (nonatomic,strong) NSString *strFirstName;
@property (nonatomic, strong) NSString *strLastName;
@property (weak, nonatomic) IBOutlet UIButton *barButton;
@property (weak, nonatomic) IBOutlet UITextView *txtComments;
@property (weak, nonatomic) IBOutlet UIImageView *imgUser;
@property (weak, nonatomic) IBOutlet UILabel *lblTIme;
@property (weak, nonatomic) IBOutlet UILabel *lblDistance;
@property (weak, nonatomic) IBOutlet UIView *viewForBill;
@property (weak, nonatomic) IBOutlet UIButton *btnConfirm;
@property (weak, nonatomic) IBOutlet UIButton *btnSubmit;
@property (weak, nonatomic) IBOutlet UIButton *btnFeedBack;
@property (weak, nonatomic) IBOutlet UILabel *lblFirstName;
@property (weak, nonatomic) IBOutlet UILabel *lblLastName;
@property (weak, nonatomic) IBOutlet UILabel *lBasePrice;
@property (weak, nonatomic) IBOutlet UILabel *lDistanceCost;
@property (weak, nonatomic) IBOutlet UILabel *lTimeCost;
@property (weak, nonatomic) IBOutlet UILabel *lPromoBonus;
@property (weak, nonatomic) IBOutlet UILabel *lreferalBonus;
@property (weak, nonatomic) IBOutlet UILabel *lTotalCost;
@property (weak, nonatomic) IBOutlet UILabel *lblInvoice;
@property (weak, nonatomic) IBOutlet UILabel *lComment;

- (IBAction)onClickBackBtn:(id)sender;

- (IBAction)submitBtnPressed:(id)sender;
- (IBAction)confirmBtnPressed:(id)sender;


//For Paystack Darshit
@property (weak, nonatomic) IBOutlet UITextField *txtCreditCard;
@property (weak, nonatomic) IBOutlet UITextField *txtCvv;
@property (weak, nonatomic) IBOutlet UITextField *txtmm;
@property (weak, nonatomic) IBOutlet UITextField *txtyy;
@property (weak, nonatomic) IBOutlet UITextField *txtCardHolderName;

@property (weak, nonatomic) IBOutlet UIView *pvew;
- (IBAction)onClickPayment:(id)sender;
- (IBAction)addPaymentBtnPressed:(id)sender;



@end
