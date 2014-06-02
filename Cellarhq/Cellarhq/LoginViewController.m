//
//  LoginViewController.m
//  Cellarhq
//
//  Created by Tim Hamer on 5/4/14.
//  Copyright (c) 2014 Arca Externa. All rights reserved.
//

#import "LoginViewController.h"
#import "AuthenticationProvider.h"
#import "CellarViewController.h"

@interface LoginViewController ()

@property (nonatomic) UITextField *usernameField;
@property (nonatomic) UITextField *passwordField;
@property (nonatomic) UIButton *loginButton;
@property (nonatomic) UIActivityIndicatorView *spinnerView;

@end

@implementation LoginViewController

- (id)init {
    if (self = [super init]) {
        self.usernameField = [[UITextField alloc] init];
        self.usernameField.placeholder = @"Email Address";
        self.usernameField.borderStyle = UITextBorderStyleBezel;
        self.usernameField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        self.usernameField.autocorrectionType = UITextAutocorrectionTypeNo;
        self.usernameField.spellCheckingType = UITextSpellCheckingTypeNo;

        [self.view addSubview:self.usernameField];
        
        self.passwordField = [[UITextField alloc] init];
        self.passwordField.placeholder = @"Password";
        self.passwordField.borderStyle = UITextBorderStyleBezel;
        self.passwordField.secureTextEntry = YES;
        [self.view addSubview:self.passwordField];
        
        self.loginButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [self.loginButton setTitle:@"Login" forState:UIControlStateNormal];
        [self.loginButton addTarget:self action:@selector(loginButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.loginButton];
        
        [self.usernameField makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.top).offset(80);
            make.centerX.equalTo(self.view.centerX);
            make.width.equalTo(self.view.width).offset(-50);
        }];
        
        [self.passwordField makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.usernameField.bottom).offset(40);
            make.centerX.equalTo(self.view.centerX);
            make.width.equalTo(self.view.width).offset(-50);
        }];
        
        [self.loginButton makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.passwordField.bottom).offset(30);
            make.left.equalTo(self.passwordField.left);
            make.width.equalTo(@75);
            make.height.equalTo(@40);
        }];
        
        self.navigationItem.title = @"Login";
        self.view.backgroundColor = [UIColor whiteColor];
        self.spinnerView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    }

    return self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.view addSubview:self.spinnerView];
    [self.spinnerView startAnimating];

    for (NSHTTPCookie *cookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]) {
        if ([cookie.name isEqualToString:@"_token"]) {
            NSLog(@"expiration date: %@", cookie.expiresDate);
            NSLog(@"current date: %@", [NSDate dateWithTimeIntervalSinceNow:0]);
            if ([cookie.expiresDate compare:[NSDate dateWithTimeIntervalSinceNow:0]] == NSOrderedDescending) {
                NSLog(@"login success");
                [self loginSuccess];
            } else {
                NSLog(@"cookie expired");
                [self.spinnerView stopAnimating];
                [self.spinnerView removeFromSuperview];
                UIAlertView *expiredView = [[UIAlertView alloc] initWithTitle:@"Session Expired" message:@"Please re-enter credentials to log in" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [expiredView show];
            }
        }
    }
}

- (void)loginButtonPressed {
    AuthenticationProvider *authProvider = [[AuthenticationProvider alloc] init];
    [self.view addSubview:self.spinnerView];
    [self.spinnerView startAnimating];
    [authProvider loginWithUsername:self.usernameField.text password:self.passwordField.text onComplete:^(BOOL success) {
        if (success) {
            [self loginSuccess];
        } else {
            NSLog(@"Failed to authenticate");
            UIAlertView *errorView = [[UIAlertView alloc] initWithTitle:@"ERROR" message:@"Failed to authenticate" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [errorView show];
        }
    }];
}

- (void)loginSuccess {
    [self.spinnerView stopAnimating];
    [self.spinnerView removeFromSuperview];
    
    Cellar *cellar = [[Cellar alloc] init];
    CellarViewController *cellarViewController = [[CellarViewController alloc] initWithCellar:cellar];
    [self.navigationController pushViewController:cellarViewController animated:YES];
}

@end
