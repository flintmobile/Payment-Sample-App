//
//  AppDelegate.m
//  SDKSandbox
//
//  Created by PC on 4/3/15.
//  Copyright (c) 2015 Flint. All rights reserved.
//

#import "AppDelegate.h"
#import <FlintConnectSDK/FlintConnectSDK.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

  [FlintAPIConfig sharedInstance].APIKey = @"4d72de8c70d3ba2e0fef18bd6231bdb7";
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
  
  return YES;
}

@end
