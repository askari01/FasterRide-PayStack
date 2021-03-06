//
//  DisplayCardVC.m
//  UberforXOwner
//
//  Created by Elluminati on 17/11/14.
//  Copyright (c) 2014 Elluminati. All rights reserved.
//

#import "DisplayCardVC.h"
#import "DispalyCardCell.h"
#import "AppDelegate.h"
#import "Constants.h"
#import "AFNHelper.h"
#import "PTKView.h"
#import "Stripe.h"
#import "PTKTextField.h"
#import "UberStyleGuide.h"


@interface DisplayCardVC ()<PTKViewDelegate,PSTCKPaymentCardTextFieldDelegate>
{
    NSMutableArray *arrForCards;
    NSString *card_id;
}

@end

@implementation DisplayCardVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setLocalization];
    arrForCards=[[NSMutableArray alloc]init];
    card_id=@"0";
	[self.imgBGAddCard setBackgroundColor:DarkBtnColor];
   [self.alertBG setBackgroundColor:DisplayAlertBgColor];
	[self.alertBGDelete setBackgroundColor:DisplayAlertBgColor];
	self.alertBGDelete.layer.cornerRadius = self.alertBGDelete.frame.size.width / 2;
	self.alertBG.layer.cornerRadius = self.alertBG.frame.size.width / 2;
    
    self.paymentTextField = [[PSTCKPaymentCardTextField alloc] initWithFrame:CGRectMake(15, 15, CGRectGetWidth(self.view.frame) - 30, 44)];
    self.paymentTextField.delegate = self;
    [self.view addSubview:self.paymentTextField];
    
    
	
    //[super setBackBarItem];
}

-(void)viewWillAppear:(BOOL)animated
{
    if (stripePublishableKey.length>1)
    {
        [Stripe setDefaultPublishableKey:stripePublishableKey];
    }
    self.pvew.hidden=YES;
    self.deleteCardView.hidden=YES;
    
    self.tableView.tableHeaderView=self.headerView;
    self.tableView.hidden=NO;
    self.headerView.hidden=NO;
    self.lblNoCards.hidden=YES;
     self.imgNoItems.hidden=YES;
    [self.btnMenu setTitle:NSLocalizedString(@"ADD PAYMENT", nil) forState:UIControlStateNormal];
    [self getAllMyCards];
}

- (void)viewDidAppear:(BOOL)animated
{
    
}

-(void)setLocalization
{
    self.lblAddPaymentCard.text = NSLocalizedString(@"Add Payment Card", nil);
    self.lblAddManually.text = NSLocalizedString(@"Add Manually", nil);
    self.lblSelectPaymentCard.text = NSLocalizedString(@"Select Your Payment Card", nil);
    self.txtCreditCard.placeholder = NSLocalizedString(@"Credit card number", nil);
    self.txtCvv.placeholder = NSLocalizedString(@"cvv", nil);
    self.txtmm.placeholder = NSLocalizedString(@"mm", nil);
    self.txtyy.placeholder = NSLocalizedString(@"yy", nil);
}

#pragma mark - textfield :

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if([textField isEqual:self.txtCreditCard])
    {
        [self.txtCvv becomeFirstResponder];
    }
    else if([textField isEqual:self.txtCvv])
    {
        [self.txtmm becomeFirstResponder];
    }
    else if([textField isEqual:self.txtmm])
    {
        [self.txtyy becomeFirstResponder];
    }
    else if([textField isEqual:self.txtyy])
    {
        [self.txtyy resignFirstResponder];
    }
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if(textField==self.txtCreditCard)
    {
        [UIView animateWithDuration:0.5 animations:^{
            
            self.pvew.frame=CGRectMake(0, -25, self.pvew.frame.size.width, self.pvew.frame.size.height);
            
        } completion:^(BOOL finished)
         {
         }];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.txtCreditCard)
    {
        if (self.txtCreditCard.text.length >= Card_Length && range.length == 0)
        {
            [self.txtCvv becomeFirstResponder];
            return NO; // return NO to not change text
        }
    }
    else if (textField == self.txtmm)
    {
        if (self.txtmm.text.length >= Card_Month && range.length == 0)
        {
            [self.txtyy becomeFirstResponder];
            return NO;
        }
    }
    else if (textField == self.txtyy)
    {
        if (self.txtyy.text.length >= Card_Year && range.length == 0)
        {
            [UIView animateWithDuration:0.5 animations:^{
                
                self.pvew.frame=CGRectMake(0, 0, self.pvew.frame.size.width, self.pvew.frame.size.height);
                
            } completion:^(BOOL finished)
             {
             }];
            [self.txtyy resignFirstResponder];
            return NO;
        }
    }
    else
    {
        if (self.txtCvv.text.length >= Card_CVC_CVV && range.length == 0)
        {
            [self.txtmm becomeFirstResponder];
            return NO;
        }
    }
    return YES;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.txtCreditCard resignFirstResponder];
    [self.txtCvv resignFirstResponder];
    [self.txtmm resignFirstResponder];
    [self.txtyy resignFirstResponder];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [self touchesBegan:touches withEvent:event];
}

//- (void)paymentView:(PTKView *)view withCard:(PTKCard *)card isValid:(BOOL)valid
//{
//    // Toggle navigation, for example
//    //self.saveButton.enabled = valid;
//    [self.view endEditing:YES];
//}
//- (void)handlePaymentAuthorizationWithPayment:(PKPayment *)payment
//                                   completion:(void (^)(PKPaymentAuthorizationStatus))completion {
//    [Stripe createTokenWithPayment:payment
//                        completion:^(STPToken *token, NSError *error) {
//                            if (error) {
//                                completion(PKPaymentAuthorizationStatusFailure);
//                                return;
//                            }
//                            /*
//                             We'll implement this below in "Sending the token to your server".
//                             Notice that we're passing the completion block through.
//                             See the above comment in didAuthorizePayment to learn why.
//                             */
//                            //[self createBackendChargeWithToken:token completion:completion];
//                            
//                        }];
//}

#pragma mark -
#pragma mark - Actions
- (void)paymentView:(PTKView *)paymentView
           withCard:(PTKCard *)card
            isValid:(BOOL)valid
{
    // Enable save button if the Checkout is valid
    //self.btnAddPayment.enabled=YES;
}

- (void)handlePaymentAuthorizationWithPayment:(PKPayment *)payment
                                   completion:(void (^)(PKPaymentAuthorizationStatus))completion
{
    [Stripe createTokenWithPayment:payment
                        completion:^(STPToken *token, NSError *error) {
                            if (error) {
                                completion(PKPaymentAuthorizationStatusFailure);
                                return;
                            }
                            
                        }];
}


- (void)hasError:(NSError *)error
{
    [[UtilityClass sharedObject] showAlertWithTitle:NSLocalizedString(@"Error", @"Error") andMessage:[error localizedDescription]];
    [APPDELEGATE hideLoadingView];
}

#pragma mark -hide pview :

- (IBAction)onClickforHidePview:(id)sender
{
    // hide payment view :
    self.pvew.hidden=YES;
    [self.txtCreditCard resignFirstResponder];
    [self.txtCvv resignFirstResponder];
    [self.txtmm resignFirstResponder];
    [self.txtyy resignFirstResponder];
}
- (IBAction)addPaymentBtnPressed:(id)sender
{
    if(self.txtCreditCard.text.length<1 || self.txtmm.text.length<1 || self.txtyy.text.length<1 || self.txtCvv.text.length<1)
    {
        if(self.txtCreditCard.text.length<1)
        {
            [[UtilityClass sharedObject]showAlertWithTitle:@"" andMessage:NSLocalizedString(@"PLEASE_CREDIT_CARD_NUMBER", nil)];
        }
        else if(self.txtmm.text.length<1)
        {
            [[UtilityClass sharedObject]showAlertWithTitle:@"" andMessage:NSLocalizedString(@"PLEASE_MONTH", nil)];
        }
        else if(self.txtyy.text.length<1)
        {
            [[UtilityClass sharedObject]showAlertWithTitle:@"" andMessage:NSLocalizedString(@"PLEASE_YEAR", nil)];
        }
        else if(self.txtCvv.text.length<1)
        {
            [[UtilityClass sharedObject]showAlertWithTitle:@"" andMessage:NSLocalizedString(@"PLESE_CVV", nil)];
        }
    }
    else
    {
        [self onClickforHidePview:nil];
        [[AppDelegate sharedAppDelegate]showLoadingWithTitle:@"Adding Card..."];
        if (![self.paymentView isValid])
        {
            // return;
        }

        PSTCKCardParams *cardParams = [[PSTCKCardParams alloc] init];
        
        cardParams.number =self.txtCreditCard.text;
        cardParams.expMonth =[self.txtmm.text integerValue];
        cardParams.expYear = [self.txtyy.text integerValue];
        cardParams.cvc = self.txtCvv.text;
    
        strForLastFour=[self.txtCreditCard.text substringFromIndex:[self.txtCreditCard.text length] - 4];
        
        NSMutableDictionary *dictInfo=[PREF objectForKey:PREF_LOGIN_OBJECT];
        
        PSTCKTransactionParams *transactionParams = [[PSTCKTransactionParams alloc] init];
        transactionParams.amount = 1;
        transactionParams.email =[dictInfo valueForKey:@"email"];
        transactionParams.currency=@"NGN";
        
        // resuming a transaction initialized by backend
        
        //transactionParams.access_code = '{access code from server}';

        [[PSTCKAPIClient sharedClient] chargeCard:cardParams forTransaction:transactionParams onViewController:self didEndWithError:^(NSError * _Nonnull error)
        {
            NSLog(@"error = %@", error);
        }
        didRequestValidation:^(NSString * _Nonnull reference)
        {
            
        }
        didTransactionSuccess:^(NSString * _Nonnull reference)
        {
            [[AppDelegate sharedAppDelegate] hideLoadingView];
            [self verifyCharge:reference];
            [self addCardOnServer:reference];

        }];
   }
}

- (void)verifyCharge:(NSString *)reference
{
    NSURL *url = [NSURL URLWithString:@"https://example.com/verify"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = @"POST";
    NSString *body     = [NSString stringWithFormat:@"reference=%@", reference];
    request.HTTPBody   = [body dataUsingEncoding:NSUTF8StringEncoding];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    NSURLSessionDataTask *task =
    [session dataTaskWithRequest:request
               completionHandler:^(NSData *data,
                                   NSURLResponse *response,
                                   NSError *error) {
                   if (error)
                   {
                       NSLog(@"error = %@", error);
                   }
                   else
                   {
                       NSLog(@"===> SUCCESS");
                       [self addCardOnServer:reference];

                      
                   }
               }];
    [task resume];
}



#pragma mark -
#pragma mark - WS Methods

-(void)addCardOnServer:(NSString *)reference
{
    
    NSMutableDictionary *dictInfo=[PREF objectForKey:PREF_LOGIN_OBJECT];
    
    [[AppDelegate sharedAppDelegate]showLoadingWithTitle:@"Adding Card"];
    NSMutableDictionary *dictParam=[[NSMutableDictionary alloc]init];
    [dictParam setObject:[PREF objectForKey:PREF_USER_ID] forKey:PARAM_ID];
    [dictParam setObject:[PREF objectForKey:PREF_USER_TOKEN] forKey:PARAM_TOKEN];
    [dictParam setObject:reference forKey:@"payment_token"];
    [dictParam setObject:strForLastFour forKey:@"last_four"];
    [dictParam setObject:[dictInfo valueForKey:@"email"] forKey:PARAM_EMAIL];
    [dictParam setObject:[PREF objectForKey:PREF_REQ_ID] forKey:PARAM_REQUEST_ID];
    [dictParam setObject:@"100" forKey:@"total"];
    
    NSLog(@"dictparam for payemnt :%@",dictParam);
    
    AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:POST_METHOD];
    [afn getDataFromPath:FILE_ADD_CARD withParamData:dictParam withBlock:^(id response, NSError *error)
     {
         [APPDELEGATE hideLoadingView];
         if(response)
         {
             if ([[response valueForKey:@"success"] boolValue])
             {
                 [[AppDelegate sharedAppDelegate] hideLoadingView];
                 [APPDELEGATE showToastMessage:@"Card added successfully."];
                 [self.navigationController popToRootViewControllerAnimated:YES];
             }
             else
             {
                 //[[AppDelegate sharedAppDelegate] hideLoadingView];
                 //[APPDELEGATE showToastMessage:@"Failed to add card."];
                 
                 NSString *str=[NSString stringWithFormat:@"%@",[response valueForKey:@"error_code"]];
                 if([str isEqualToString:@"21"])
                 {
                     //[self performSegueWithIdentifier:SEGUE_TO_UNWIND sender:self];
                 }
                 else
                 {
                     [[UtilityClass sharedObject] showAlertWithTitle:@"" andMessage:[response valueForKey:@"strip_msg"]];
                 }
             }
         }
     }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (IBAction)addCardBtnPressed:(id)sender
{
    self.txtCreditCard.text=@"";
    self.txtCvv.text=@"";
    self.txtmm.text=@"";
    self.txtyy.text=@"";
    self.pvew.hidden=NO;
    [self.txtCreditCard becomeFirstResponder];
}
#pragma mark -
#pragma mark - UITableView Delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrForCards.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DispalyCardCell *cell=(DispalyCardCell *)[self.tableView dequeueReusableCellWithIdentifier:@"cardcell"];
    if (cell==nil) {
        cell=[[DispalyCardCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellSlider"];
    }
    if(arrForCards.count>0)
    {
        NSMutableDictionary *dict=[arrForCards objectAtIndex:indexPath.row];
        cell.lblcardNUmber.text=[NSString stringWithFormat:@"***%@",[dict valueForKey:@"last_four"]];
        if([card_id isEqualToString:@"0"])
        {
            card_id= [NSString stringWithFormat:@"%@",[dict valueForKey:@"id"]];
        }
        if([card_id isEqualToString:[dict valueForKey:@"id"]])
        {
           // cell.btnSelect.hidden=NO;
            cell.imgPayment.image=[UIImage imageNamed:@"card_sileted_payment"];
            cell.lblcardNUmber.textColor=[UIColor blackColor];
        }
        else
        {
            cell.imgPayment.image=[UIImage imageNamed:@"Card_deselect"];
           // cell.btnSelect.hidden=YES;
            cell.lblcardNUmber.textColor=[UIColor grayColor];

        }
        [cell.btnSelect setTag:indexPath.row];
        [cell.btnSelect addTarget:self action:@selector(deleteCard:) forControlEvents:UIControlEventTouchUpInside];
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *dict=[arrForCards objectAtIndex:indexPath.row];
    card_id=[NSString stringWithFormat:@"%@",[dict valueForKey:@"id"] ];
    // delete card :
  //  self.deleteCardView.hidden=NO;
    [self SelectCard];
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1.0f;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView=[[UIView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 1.0f)];
    footerView.backgroundColor=[UIColor colorWithRed:96.0f/255.0f green:201.0f/255.0f blue:255.0/255.0f alpha:1.0f];
    
    return footerView;
}

-(IBAction)deleteCard:(UIButton*)sender
{
    cardTag = sender.tag;
    self.deleteCardView.hidden = NO;
}

#pragma  mark -
#pragma mark- Card WS

-(void)SelectCard
{
    if([[AppDelegate sharedAppDelegate]connected])
    {
        // [[AppDelegate sharedAppDelegate]showLoadingWithTitle:NSLocalizedString(@"LOADING", nil)];
        NSString * strForUserId=[PREF objectForKey:PREF_USER_ID];
        NSString * strForUserToken=[PREF objectForKey:PREF_USER_TOKEN];
        
        NSMutableDictionary *dictParam=[[NSMutableDictionary alloc]init];
        
        [dictParam setValue:strForUserId forKey:PARAM_ID];
        [dictParam setValue:strForUserToken forKey:PARAM_TOKEN];
        [dictParam setValue:card_id forKey:PARAM_DEFAULT_CARD];

        AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:POST_METHOD];
            [afn getDataFromPath:FILE_SELECT_CARD withParamData:dictParam withBlock:^(id response, NSError *error)
             {
             NSLog(@"History Data= %@",response);
            // [APPDELEGATE hideLoadingView];
             if (response)
             {
                 if([[response valueForKey:@"success"] intValue]==1)
                 {
                     arrForCards = [response valueForKey:@"payments"];
                     [self.tableView reloadData];
                      NSLog(@"%@",response);
                 }else{
                    
                     NSString *str=[NSString stringWithFormat:@"%@",[response valueForKey:@"error"]];
                     UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:[afn getErrorMessage:str] delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil, nil];
                     [alert show];
                 }
             }
         }];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Network Status", nil) message:NSLocalizedString(@"NO_INTERNET", nil) delegate:self cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"OK", nil), nil];
        [alert show];
    }
}

-(void)getAllMyCards
{
    if([[AppDelegate sharedAppDelegate]connected])
    {
        NSString * strForUserId=[PREF objectForKey:PREF_USER_ID];
        NSString * strForUserToken=[PREF objectForKey:PREF_USER_TOKEN];
        
        
        NSMutableString *pageUrl=[NSMutableString stringWithFormat:@"%@?%@=%@&%@=%@",FILE_GET_CARDS,PARAM_ID,strForUserId,PARAM_TOKEN,strForUserToken];
        AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:GET_METHOD];
        [afn getDataFromPath:pageUrl withParamData:nil withBlock:^(id response, NSError *error)
         {

             NSLog(@"History Data= %@",response);
             if (response)
             {
                 if([[response valueForKey:@"success"] intValue]==1)
                 {
                     [APPDELEGATE hideLoadingView];
                     [arrForCards removeAllObjects];
                     [arrForCards addObjectsFromArray:[response valueForKey:@"payments"]];
                     if (arrForCards.count==0)
                     {
                         self.tableView.hidden=YES;
                         self.headerView.hidden=YES;
                         self.lblNoCards.hidden=NO;
                         self.imgNoItems.hidden=NO;
                     }
                     else
                     {
                         
                         self.tableView.hidden=NO;
                         self.headerView.hidden=NO;
                         self.lblNoCards.hidden=YES;
                         self.imgNoItems.hidden=YES;
                         [self.tableView reloadData];
                     }
                 }else
                 {
                     NSString *str=[NSString stringWithFormat:@"Please add card"];
                     UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:[afn getErrorMessage:str] delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil, nil];
                     [alert show];
                 }
             }
         }];
        
        
    }
    else
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"No Internet" message:NSLocalizedString(@"NO_INTERNET", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil, nil];
        [alert show];
    }
    [APPDELEGATE hideLoadingView];
    [self.tableView reloadData];
}

- (IBAction)backBtnPressed:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (IBAction)onClickForCancelDeleteCardView:(id)sender {

    self.deleteCardView.hidden=YES;

}

- (IBAction)onClickForDeleteCard:(id)sender {

    [[AppDelegate sharedAppDelegate]showLoadingWithTitle:@"Deleting Card..."];
    if ([APPDELEGATE connected])
    {
        NSDictionary *dictData = [arrForCards objectAtIndex:cardTag];
        
        NSMutableDictionary *dictParam = [[NSMutableDictionary alloc]init];
        [dictParam setObject:[PREF objectForKey:PREF_USER_ID] forKey:PARAM_ID];
        [dictParam setObject:[PREF objectForKey:PREF_USER_TOKEN] forKey:PARAM_TOKEN];
        [dictParam setObject:[dictData objectForKey:PARAM_ID] forKey:PARAM_CARD_ID];
        
        AFNHelper *helper = [[AFNHelper alloc]initWithRequestMethod:POST_METHOD];
        [helper getDataFromPath:FILE_DELETECARD withParamData:dictParam withBlock:^(id response, NSError *error) {
            if (response)
            {
                [[AppDelegate sharedAppDelegate] hideLoadingView];
                if ([[response valueForKey:@"success"] boolValue])
                {
                    arrForCards = [response valueForKey:@"payments"];
                    [self.tableView reloadData];
                    [self.deleteCardView setHidden:YES];
                    [[AppDelegate sharedAppDelegate] showToastMessage:@"Your card deleted successfully"];
                }else
                {
                    NSString *str=[NSString stringWithFormat:@"%@",[response valueForKey:@"error"]];
                    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:[helper getErrorMessage:str] delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil, nil];
                    [alert show];
                }
            }
        }];
         
    
    }
    
}

- (IBAction)onClcikForHideDeleteView:(id)sender {
    
    self.deleteCardView.hidden=YES;
}
- (void)paymentCardTextFieldDidChange:(PSTCKPaymentCardTextField *)textField  {
    // Toggle navigation, for example
    //self.saveButton.enabled = textField.isValid;
}
@end
