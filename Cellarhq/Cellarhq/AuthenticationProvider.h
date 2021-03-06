//
//  AuthenticationProvider.h
//  Cellarhq
//
//  Created by Tim Hamer on 5/4/14.
//  Copyright (c) 2014 Arca Externa. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^AuthenticationProviderCompletionBlock)(BOOL);

typedef enum {
    AuthenticationFailedTokenNotFound,
    AuthenticationFailedTokenExpired,
    AuthenticationSuccess,
} AuthenticationStatus;

@protocol AuthenticationProviderDelegate

- (void)authenticationFinished:(AuthenticationStatus)status;

@end

@interface AuthenticationProvider : NSObject

@property (nonatomic, weak) id<AuthenticationProviderDelegate> delegate;

- (void)loginWithUsername:(NSString *)username
                 password:(NSString *)password
               onComplete:(AuthenticationProviderCompletionBlock)onComplete;
- (void)attemptAuthentication;
- (void)logout;

@end
