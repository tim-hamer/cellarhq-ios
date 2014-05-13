//
//  BeerSizePicker.m
//  Cellarhq
//
//  Created by Tim Hamer on 5/6/14.
//  Copyright (c) 2014 Arca Externa. All rights reserved.
//

#import "BeerSizePicker.h"

@interface BeerSizePicker () <UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic) UIPickerView *pickerView;
@property (nonatomic) UIButton *doneButton;

@property (nonatomic) NSArray *sizes;
@property (nonatomic) NSString *selectedSize;

@end

@implementation BeerSizePicker

- (id)init {
    if (self = [super init]) {
        self.sizes = @[@"7 oz",
                       @"12 oz",
                       @"16 oz",
                       @"22 oz",
                       @"25 oz",
                       @"40 oz",
                       @"125 ml",
                       @"187 ml",
                       @"250 ml",
                       @"275 ml",
                       @"330 ml",
                       @"341 ml",
                       @"350 ml",
                       @"355 ml",
                       @"375 ml",
                       @"500 ml",
                       @"550 ml",
                       @"650 ml",
                       @"750 ml",
                       @"1 l",
                       @"1.5 l",
                       @"3 l"];
        
        self.pickerView = [[UIPickerView alloc] init];
        self.pickerView.delegate = self;
        self.pickerView.dataSource = self;
        [self addSubview:self.pickerView];
        self.pickerView.userInteractionEnabled = YES;
        
        self.doneButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [self.doneButton setTitle:@"Done" forState:UIControlStateNormal];
        [self.doneButton addTarget:self action:@selector(doneButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.doneButton];
        
        [self.pickerView makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.bottom);
            make.width.equalTo(self.width);
            make.top.equalTo(self.top).offset(-40);
            make.centerX.equalTo(self.centerX);
        }];
        
        [self.doneButton makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.top).offset(5);
            make.right.equalTo(self.right).offset(-5);
            make.height.equalTo(@30);
            make.width.equalTo(@50);
        }];
    }
    return self;
}

- (void)doneButtonPressed {
    [self.delegate sizeSelected:self.selectedSize];
}

#pragma mark - UIPickerViewDataSource and UIPickerViewDelegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return 22;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [self.sizes objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.selectedSize = [self.sizes objectAtIndex:row];
}

@end
