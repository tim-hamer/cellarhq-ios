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

@end
