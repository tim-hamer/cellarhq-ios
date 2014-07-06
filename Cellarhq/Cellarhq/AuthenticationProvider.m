//
//  AuthenticationProvider.m
//  Cellarhq
//
//  Created by Tim Hamer on 5/4/14.
//  Copyright (c) 2014 Arca Externa. All rights reserved.
//

#import "AuthenticationProvider.h"
#import "NetworkRequestHandler.h"

@interface AuthenticationProvider () <NSURLConnectionDataDelegate>

@property (nonatomic, copy) AuthenticationProviderCompletionBlock completionBlock;

@end

@implementation AuthenticationProvider

- (void)loginWithUsername:(NSString *)username
                 password:(NSString *)password
               onComplete:(AuthenticationProviderCompletionBlock)onComplete {
    
    self.completionBlock = onComplete;
    
    NSURL *url = [NSURL URLWithString:@"http://www.cellarhq.com/signin/processEmail"];
    NSDictionary *parameters = @{@"email": username, @"password": password};
    
    NetworkRequestHandler *networkHandler = [[NetworkRequestHandler alloc] init];
    [networkHandler handleHttpPostRequestWithUrl:url
                                      parameters:parameters
                                      onComplete:^(NSInteger statusCode, NSError *error){
                                          if (!error && statusCode == 200) {
                                              self.completionBlock(YES);
                                          } else {
                                              self.completionBlock(NO);
                                          }
    }];
}

- (void)attemptAuthentication {
    for (NSHTTPCookie *cookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]) {
        if ([cookie.name isEqualToString:@"_token"]) {
            NSLog(@"expiration date: %@", cookie.expiresDate);
            NSLog(@"current date: %@", [NSDate dateWithTimeIntervalSinceNow:0]);
            if ([cookie.expiresDate compare:[NSDate dateWithTimeIntervalSinceNow:0]] == NSOrderedDescending) {
                NSLog(@"login success");
                [self.delegate authenticationFinished:AuthenticationSuccess];
            } else {
                NSLog(@"cookie expired");
                [self.delegate authenticationFinished:AuthenticationFailedTokenExpired];
            }
        }
    }
    [self.delegate authenticationFinished:AuthenticationFailedTokenNotFound];
}

- (void)logout {
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *cookie in [cookieStorage cookies]) {
        if ([cookie.name isEqualToString:@"_token"]) {
            [cookieStorage deleteCookie:cookie];
        }
    }
}

@end
