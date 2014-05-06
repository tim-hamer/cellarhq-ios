//
//  NetworkRequestHandler.m
//  Cellarhq
//
//  Created by Tim Hamer on 5/5/14.
//  Copyright (c) 2014 Arca Externa. All rights reserved.
//

#import "NetworkRequestHandler.h"

@interface NetworkRequestHandler ()

@property (nonatomic, copy) NetworkRequestHandlerCompletionBlock completionBlock;

@end

@implementation NetworkRequestHandler

- (void)handleHttpPostRequestWithUrl:(NSURL *)url
                          parameters:(NSDictionary *)parameters
                          onComplete:(NetworkRequestHandlerCompletionBlock)onComplete {

    self.completionBlock = onComplete;
    
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
    self.completionBlock(httpResponse.statusCode, nil);
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"Error on network request: %@", error.localizedDescription);
    self.completionBlock(0, error);
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
