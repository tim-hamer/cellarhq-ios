//
//  BeerSizePicker.h
//  Cellarhq
//
//  Created by Tim Hamer on 5/6/14.
//  Copyright (c) 2014 Arca Externa. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BeerSizePickerDelegate

- (void)sizeSelected:(NSString *)size;

@end

@interface BeerSizePicker : UIView

@property (nonatomic, weak) id<BeerSizePickerDelegate> delegate;

@end
