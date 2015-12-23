# Payment-Sample-App
A Demonstration of how Flint Drop in Payment work flow can be used

### Starting Flint Service
This is the entrance to the SDK whether you use the drop-in payment work flow or use the individual objects in the SDK. It is recommended to make this call in appDidFinishLaunchingWithOption: within your AppDelegate
``` Objc
  [FlintAPIConfig sharedInstance].APIKey = API_KEY;
  [FlintAPIConfig sharedInstance].environment = EnvironmentStaging;
  [FlintAPIConfig sharedInstance].username = OWNER_USERNAME;
  [FlintAPIConfig sharedInstance].password = OWNER_PASSWORD;
  [FlintAPIConfig sharedInstance].logLevel = APILogLevelDebug;
  
  [[FlintService sharedInstance] startServiceWithCompletion:^(FlintServiceStatus status, NSDictionary *userInfo) {
    // notify Flint Service start
  }];
```

The environment property is where you want to test your transaction. In staging mode, the transaction will passed through but the card won't be processed.
Username and password properties are optional. If you don't pass in the username and password, we simply start FlintService without a merchant account and you can always call loginWithUsername:password:completion: later on.

### Starting Drop-in Payment Workflow
- First create a FlintOrderItem (or many of them)
``` Objc
  FlintOrderItem *transactionItem = [FlintOrderItem new];
  transactionItem.quantity = @(2);
  transactionItem.price = @(50.0);
  transactionItem.name = @"Super Cool Dress";
```
- You also have the option to specify the tax amount. This is the tax on a single item
``` Objc
  transactionItem.taxAmount = @(3.00);
```
- Then pass the array of FlintOrderItem to FlintUI, this is the entrance for the payment workflow
``` Objc
[FlintUI takePaymentForOrderItems:@[transactionItem] fromViewController:self];
```
##### Transaction Status
To receive transaction status at the end of the payment work flow, you will need to implement FlintTransactionDelegate protocol on your view controller. This give you the option to know whether the payment successfully processed or at which point the user cancel out of the flow (or leave it idle and get time out)
``` Objc
- (void)transactionDidCancel:(FlintTransactionCancelableStep)canceledStep autoTimeout:(BOOL)autoTimeOut
{
  [self dismissViewControllerAnimated:YES completion:^{}];
}

- (void)transactionDidComplete:(NSDictionary *)userInfo
{
  [FlintUI restartPaymentFlowWithOrderItems:@[transaction] delegate:self];
}
```
Upon completion delegate call back, the userInfo dictionary will contain FlintTransactionOrderKey that store the FlintOrder object with your order information, FlintTransactionPaymentKey that store FlintPayment object if the user do a payment transaction, or FlintTransactionInvoiceKey that store FlintInvoice object if the user do an invoice transaction.

### Integrate the SDK into your app
- You will need to have minimum target for iOS 8+
- In your project settings > General tab > Embedded Binaries. Click the + sign to add FlintConnectSDK.framework to your project
- import \<FlintConnectSDK/FlintConnectSDK.h\> wherever you use the framework
- Happy taking payment! :)
