//
//  ForgetPasswordVC.m
//  UberforXOwner
//
//  Created by Elluminati on 14/11/14.
//  Copyright (c) 2014 Elluminati. All rights reserved.
//

#import "ForgetPasswordVC.h"

@interface ForgetPasswordVC ()

@end

@implementation ForgetPasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [super setBackBarItem];
    self.btnSend=[APPDELEGATE setBoldFontDiscriptor:self.btnSend];
    self.txtEmail.font=[UberStyleGuide fontRegularBold];
    self.navigationController.navigationBarHidden=NO;
	[self.btnSend setBackgroundColor:DarkBtnColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
}
-(void)dismissKeyboard
{
    [self.txtEmail resignFirstResponder];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBarHidden=YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)signBtnPressed:(id)sender
{
    if(self.txtEmail.text.length < 1)
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:NSLocalizedString(@"PLEASE_EMAIL", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil, nil];
        [alert show];
    }
    else
    {
        if([[UtilityClass sharedObject]isValidEmailAddress:self.txtEmail.text])
        {
            if([[AppDelegate sharedAppDelegate]connected])
            {
                [[AppDelegate sharedAppDelegate]showLoadingWithTitle:NSLocalizedString(@"SENDING MAIL", nil)];
                
                NSMutableDictionary *dictParam=[[NSMutableDictionary alloc]init];
                [dictParam setValue:self.txtEmail.text forKey:PARAM_EMAIL];
                [dictParam setValue:@"0" forKey:@"type"];

                AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:POST_METHOD];
                [afn getDataFromPath:FILE_FORGET_PASSWORD withParamData:dictParam withBlock:^(id response, NSError *error)
                 {
                     [[AppDelegate sharedAppDelegate]hideLoadingView];
                     if (response)
                     {
                         if([[response valueForKey:@"success"] boolValue])
                         {
                             [APPDELEGATE showToastMessage:NSLocalizedString(@"PASSWORD_SENT", nil)];
                             [self.navigationController popViewControllerAnimated:YES];
                         }
                         else
                         {
                             NSString *str=[NSString stringWithFormat:@"%@",[response valueForKey:@"error"]];
                             UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:[afn getErrorMessage:str] delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil, nil];
                             [alert show];
                             //[APPDELEGATE showToastMessage:NSLocalizedString(@"ERROR", nil)];
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
        else
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:NSLocalizedString(@"PLEASE_VALID_EMAIL", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil, nil];
            [alert show];
        }
    }
}

- (IBAction)backBtnPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];

}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
