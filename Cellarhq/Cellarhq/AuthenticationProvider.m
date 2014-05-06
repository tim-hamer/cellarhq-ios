//
//  AuthenticationProvider.m
//  Cellarhq
//
//  Created by Tim Hamer on 5/4/14.
//  Copyright (c) 2014 Arca Externa. All rights reserved.
//

#import "AuthenticationProvider.h"

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
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    NSDictionary *headers = @{@"Content-Type": @"application/x-www-form-urlencoded"};
    request.HTTPMethod = @"POST";
    request.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    request.allHTTPHeaderFields = headers;
    request.HTTPBody = [[self generateUrlEncodedStringFromParameters:parameters withParameterStringPrefix:nil] dataUsingEncoding:NSUTF8StringEncoding];
    request.HTTPShouldHandleCookies = YES;
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:NO];
    [connection start];
}

#pragma mark - NSURLConnectionDataDelegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    NSLog(@"response code: %d", httpResponse.statusCode);
    if(httpResponse.statusCode == 200) {
        self.completionBlock(YES);
    } else {
        self.completionBlock(NO);
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"Error authenticating: %@", error.localizedDescription);
    self.completionBlock(NO);
}

- (NSString *)generateUrlEncodedStringFromParameters:(NSDictionary *)parameters withParameterStringPrefix:(NSString *)paramPrefix {
    if (parameters) {
        NSMutableString *body = [NSMutableString string];
        NSArray *keys = [parameters allKeys];
        for (NSString *key in keys) {
            NSString *value = [parameters objectForKey:key];
            NSString *keyString = key;
            
            if (paramPrefix) {
                keyString = [NSString stringWithFormat:@"%@[%@]", paramPrefix, key];
            }
            
            if ([value isKindOfClass:NSDictionary.class]) {
                [body appendString:[self generateUrlEncodedStringFromParameters:(NSDictionary *)value withParameterStringPrefix:keyString]];
            } else if (![value isKindOfClass:NSString.class]) {
                @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"Values in NSDictionary parameters should be NSStrings or NSDictionaries." userInfo:nil];
            } else {
                [body appendFormat:@"%@=%@", keyString, value];
            }
            
            BOOL notOnLastKey = [keys indexOfObject:key] != keys.count - 1;
            if (notOnLastKey) {
                [body appendString:@"&"];
            }
        }
        return body;
    }
    return nil;
}


@end
