//
//  CellarhqTests.m
//  CellarhqTests
//
//  Created by Tim Hamer on 4/17/14.
//  Copyright (c) 2014 Arca Externa. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "AuthenticationProvider.h"

@interface CellarhqTests : XCTestCase

@end

@implementation CellarhqTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testLoginSuccess {
    AuthenticationProvider *testObject = [[AuthenticationProvider alloc] init];
    
    NSString *username = @"hamer.tim@gmail.com";
    NSString *password = @"reaper";
    BOOL status = [testObject loginWithUsername:username password:password];
    
    XCTAssertTrue(status);
}

- (void)testLoginFail {
    AuthenticationProvider *testObject = [[AuthenticationProvider alloc] init];
    
    NSString *username = @"blah";
    NSString *password = @"blah";
    BOOL status = [testObject loginWithUsername:username password:password];
    
    XCTAssertFalse(status);
}

@end
