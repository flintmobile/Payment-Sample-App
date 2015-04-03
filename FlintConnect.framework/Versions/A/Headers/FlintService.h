//
//  FlintService.h
//  FlintConnect
//
//  Created by Nidhi on 3/4/15.
//  Copyright (c) 2015 Flint. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void (^FMCServiceHandler)(NSInteger status,
                                  NSError *error);



@interface FlintService : NSObject

+ (FlintService*)sharedInstance;

@property (assign, nonatomic, getter=isRunning) BOOL running;

@property (copy, nonatomic, readonly) NSString *authToken;

/**
 *  Start the Flint Service. It is recommended to call this from didFinishLaunchingWithOptions.
 *  All FLint SDK calls should be made after the Flint Service has been successfully started.
 *
 *  @param APIKey   The Api key provided on sign up
 *  @param environment  The environment for which flint service should be started - prod or staging. Defaults to prod
 *  @param completionHandler    The block to call when the Flint Service has started
 */
- (void)start:(NSString*)APIKey environment:(NSString*)environment completionHandler:(FMCServiceHandler)handler;

/**
 *  Request a new channel Id and a request number to make subsequent requests
 *
 */
- (void)connect;

/**
 *  Log into the flint account.
 *
 *  @param username   The flint account username
 *  @param password   The flint account password
 */
- (void)login:(NSString *)username password:(NSString *)password completionHandler:(FMCServiceHandler)handler;
@end
