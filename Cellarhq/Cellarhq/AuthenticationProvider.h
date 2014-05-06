//
//  AuthenticationProvider.h
//  Cellarhq
//
//  Created by Tim Hamer on 5/4/14.
//  Copyright (c) 2014 Arca Externa. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^AuthenticationProviderCompletionBlock)(BOOL);

@interface AuthenticationProvider : NSObject

- (void)loginWithUsername:(NSString *)username
                 password:(NSString *)password
               onComplete:(AuthenticationProviderCompletionBlock)onComplete;

@end
