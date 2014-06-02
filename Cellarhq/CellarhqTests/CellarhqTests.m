//
//  CellarhqTests.m
//  CellarhqTests
//
//  Created by Tim Hamer on 4/17/14.
//  Copyright (c) 2014 Arca Externa. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "AuthenticationProvider.h"
#import "Beer.h"
#import "Cellar.h"

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
    [testObject loginWithUsername:username
                         password:password
                       onComplete:^(BOOL success) {
                       XCTAssertTrue(success);
                   }];
}

- (void)testLoginFail {
    AuthenticationProvider *testObject = [[AuthenticationProvider alloc] init];
    
    NSString *username = @"blah";
    NSString *password = @"blah";
    [testObject loginWithUsername:username
                         password:password
                       onComplete:^(BOOL success) {
                           XCTAssertFalse(success);
                       }];
}

- (void)testCellarSearch {
    Beer *nameMatch = [[Beer alloc] init];
    nameMatch.name = @"Beer is Good";
    nameMatch.brewery = @"Bad Brewery";
    
    Beer *breweryMatch = [[Beer alloc] init];
    breweryMatch.name = @"stupid name";
    breweryMatch.brewery = @"we brewgoodbeer";
    
    Beer *noMatch = [[Beer alloc] init];
    noMatch.name = @"not a Match";
    noMatch.brewery = @"also no match here";
    
    Cellar *cellar = [[Cellar alloc] init];
    
    cellar.beers = @[nameMatch, breweryMatch, noMatch];
    
    [cellar beersContainingText:@"goo"];
    
    XCTAssertEqual(2, cellar.beers.count);
    XCTAssertFalse([cellar.beers containsObject:noMatch]);
}

@end
