//
//  ViewController.m
//  SDKSandbox
//
//  Created by PC on 4/3/15.
//  Copyright (c) 2015 Flint. All rights reserved.
//

#import "PMTItemViewController.h"

#import <FlintConnectSDK/FlintConnectSDK.h>

@interface PMTItemViewController () <FlintTransactionDelegate, UITextFieldDelegate>

@property (strong, nonatomic) NSMutableArray *orderItems;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *priceTextField;
@property (weak, nonatomic) IBOutlet UITextField *taxTextField;
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;

@end

@implementation PMTItemViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  _orderItems = [NSMutableArray array];
}

- (IBAction)handleAddItemTapped:(id)sender
{
  [self dismissKeyboard];
  
  FlintOrderItem *orderItem = [FlintOrderItem new];
  orderItem.quantity = @(1);
  orderItem.name = self.nameTextField.text;
  orderItem.price = @([self.priceTextField.text floatValue]);
  orderItem.taxAmount = @([self.taxTextField.text floatValue]);
  
  [self.orderItems addObject:orderItem];
  [self refreshTotalLabel];
  self.nameTextField.text = @"";
  self.priceTextField.text = @"";
  self.taxTextField.text = @"";
}

- (IBAction)handleResetTapped:(id)sender
{
  [self.orderItems removeAllObjects];
  [self refreshTotalLabel];
}

- (IBAction)handleTakePaymentTapped:(id)sender
{
  [FlintUI takePaymentForOrderItems:self.orderItems fromViewController:self];
}

#pragma mark - Transaction Delegate

- (void)transactionDidCancel:(FlintTransactionCancelableStep)canceledStep autoTimeout:(BOOL)autoTimeOut
{
  [self handleResetTapped:nil];
  [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)transactionDidComplete:(NSDictionary *)userInfo
{
  FlintPayment *payment = [userInfo valueForKey:FlintTransactionPaymentKey];
  NSLog(@"Amount Paid: %@", payment.amount);
 
  [self handleResetTapped:nil];
  [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - UITextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
  [textField resignFirstResponder];
  return YES;
}

#pragma mark - Private

- (void)refreshTotalLabel
{
  CGFloat total = 0.0f;
  for (FlintOrderItem *orderItem in self.orderItems) {
    total += [[orderItem total] floatValue];
  }
  self.totalLabel.text = [NSString stringWithFormat:@"$%.2f", total];
}

- (void)dismissKeyboard
{
  for (UIView *view in self.view.subviews) {
    if ([view isKindOfClass:[UITextField class]] && [view isFirstResponder]) {
      [view resignFirstResponder];
    }
  }
}

@end
