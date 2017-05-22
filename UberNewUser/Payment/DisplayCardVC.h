//
//  DisplayCardVC.h
//  UberforXOwner
//
//  Created by Elluminati on 17/11/14.
//  Copyright (c) 2014 Elluminati. All rights reserved.
//

#import "BaseVC.h"
#import "PTKCard.h"
#import "PTKView.h"
#import "Stripe.h"
#import "PTKTextField.h"
#import <Paystack/Paystack.h>
#import <Paystack/PSTCKAPIClient.h>

@interface DisplayCardVC : BaseVC<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,PTKViewDelegate>
{
    NSString *strForID;
    NSString *strForToken;
    NSString *strForStripeToken,*strForLastFour;
    
    NSInteger cardTag;


}
@property(nonatomic) PSTCKPaymentCardTextField *paymentTextField;
- (IBAction)addCardBtnPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet PTKView *paymentView;

//- (void)createBackendChargeWithToken:(STPToken *)token;
@property (weak, nonatomic) IBOutlet UIImageView *imgBGAddCard;

- (IBAction)backBtnPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *lblNoCards;
@property (weak, nonatomic) IBOutlet UILabel *lblAddPaymentCard;
@property (weak, nonatomic) IBOutlet UILabel *lblAddManually;
@property (weak, nonatomic) IBOutlet UILabel *lblSelectPaymentCard;
@property (weak, nonatomic) IBOutlet UIImageView *imgNoItems;
@property (weak, nonatomic) IBOutlet UIButton *btnMenu;
- (IBAction)onClickforHidePview:(id)sender;

- (IBAction)scanBtnPressed:(id)sender;
- (IBAction)addPaymentBtnPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *txtCreditCard;
@property (weak, nonatomic) IBOutlet UITextField *txtCvv;
@property (weak, nonatomic) IBOutlet UITextField *txtmm;
@property (weak, nonatomic) IBOutlet UITextField *txtyy;

@property (weak, nonatomic) IBOutlet UIView *pvew;
@property (weak, nonatomic) IBOutlet UIView *deleteCardView;
- (IBAction)onClickForCancelDeleteCardView:(id)sender;
- (IBAction)onClickForDeleteCard:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *alertBG;

@property (weak, nonatomic) IBOutlet UIImageView *alertBGDelete;
- (IBAction)onClcikForHideDeleteView:(id)sender;
@end
