//
//  AppDelegate.m
//  SDKSandbox
//
//  Created by PC on 4/3/15.
//  Copyright (c) 2015 Flint. All rights reserved.
//

#import "AppDelegate.h"
#import <FlintConnectSDK/FlintConnectSDK.h>
#import <UIKit/UIKit.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

  /**
   * Starting Flint Service By Providing the configuration
   * There are also option to start Flint Service and Authenticate user at a later point in time
   * Simply not providing the username and passord here and user loginWithUsername:password:completion: method on FlintService
   */
  [FlintAPIConfig sharedInstance].APIKey = @"6ab9de448dde5ac59240e1e95a7198d9";
  [FlintAPIConfig sharedInstance].environment = EnvironmentStaging;
  [FlintAPIConfig sharedInstance].username = @"test0001@mailinator.com";
  [FlintAPIConfig sharedInstance].password = @"T3st1ng1";
  
  [[FlintService sharedInstance] startServiceWithCompletion:^(FlintServiceStatus status, NSDictionary *userInfo) {
    
    NSError *error = [userInfo valueForKey:FlintServiceErrorKey];
    if (!error) {
      NSLog(@"==============SERVICE AUTHENTICATED AND START===================");
      
      FlintAccount *account = [userInfo valueForKey:FlintServiceAccountKey];
      NSLog(@"Authenticated Account:%@", account.key);
      
      FlintMerchant *merchant = [userInfo valueForKey:FlintServiceMerchantKey];
      NSLog(@"Merchant info:%@", [merchant businessName]);
      
      NSLog(@"====================END SERVICE INFO============================");
    } else {
      
      NSLog(@"Flint Service Error:%@", error);
    }
  }];
  
  /**
   * Providing the mechanism to customize the overall theme for the payment work flow
   * For individual component customization, use our Default.css in the SDK framework bundle
   */
  [FlintThemeEngine setThemeColor:[UIColor colorWithRed:20.0/255 green:255.0/255 blue:150.0/255 alpha:1.0f]];
  return YES;
}

@end
