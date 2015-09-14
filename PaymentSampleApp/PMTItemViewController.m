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

@property (assign, nonatomic) CGFloat total;

@end

@implementation PMTItemViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  _orderItems = [NSMutableArray array];
  _total = 0.0f;
}

- (IBAction)handleAddItemTapped:(id)sender
{
  CGFloat price = [[[[self class] numberFormatter] numberFromString:self.priceTextField.text] floatValue];
  CGFloat tax = [[[[self class] numberFormatter] numberFromString:self.taxTextField.text] floatValue];

  if (self.nameTextField.text.length == 0) {
    [self showAlertMessage:NSLocalizedString(@"Item Name is Required", nil)];
    return;
  }
  
  if (price <= 0) {
    [self showAlertMessage:NSLocalizedString(@"Item Price Have to be greater than 0", nil)];
    return;
  }
  
  [self dismissKeyboard];
  
  /*************************************************************************
   * A FlintOrderItem is the smallest unit of the payment work flow
   * By default, the item type is OrderItemTypeCustomAmount (addition)
   * To implement discount, set the item type to OrderItemTypeCustomDiscount (subtraction),
   * The other item types are for Flint internal usage.
   **************************************************************************/
  FlintOrderItem *orderItem = [FlintOrderItem new];
  orderItem.quantity = @(1);
  orderItem.name = self.nameTextField.text;
  orderItem.price = @(price);
  orderItem.taxAmount = @(tax);
  
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
  if (self.total > 0) {
    /******************************************************************************
     * FlintUI is the main entrance into the drop-in payment work flow
     * Configure an array of FlintOrderItem(s) and then
     * either use the convenient method to start the workflow as a modal view
     * or use the view controller method to implement your own navigation stack
     * Implement FlintTransactionDelegate to receive transaction status call back
     ******************************************************************************/
    [FlintUI takePaymentForOrderItems:self.orderItems fromViewController:self];
  } else {
    [self showAlertMessage:NSLocalizedString(@"Amount to take payment must be greater than 0. Try adding some items", nil)];
  }
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
  self.total = total;
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

- (void)showAlertMessage:(NSString *)message
{
  UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Error", nil)
                                                                           message:message
                                                                    preferredStyle:UIAlertControllerStyleAlert];
  UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Ok", nil) style:UIAlertActionStyleCancel handler:NULL];
  [alertController addAction:okAction];
  [self presentViewController:alertController animated:YES completion:NULL];
}

+ (NSNumberFormatter *)numberFormatter
{
  NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
  numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
  return numberFormatter;
}

@end
