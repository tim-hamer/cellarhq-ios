//
//  NetworkRequestHandler.h
//  Cellarhq
//
//  Created by Tim Hamer on 5/5/14.
//  Copyright (c) 2014 Arca Externa. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^NetworkRequestHandlerCompletionBlock)(NSInteger statusCode, NSError *error);

@interface NetworkRequestHandler : NSObject

- (void)handleHttpPostRequestWithUrl:(NSURL *)url
                          parameters:(NSDictionary *)parameters
                          onComplete:(NetworkRequestHandlerCompletionBlock)onComplete;

- (void)handleHttpGetRequestWithUrl:(NSURL *)url
                         onComplete:(NetworkRequestHandlerCompletionBlock)onComplete;

@end
