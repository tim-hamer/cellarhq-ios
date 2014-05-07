//
//  BeerDetailViewController.h
//  Cellarhq
//
//  Created by Tim Hamer on 5/4/14.
//  Copyright (c) 2014 Arca Externa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Beer.h"

@interface BeerDetailViewController : UIViewController

@property (nonatomic) BOOL editMode;

- (id)initWithBeer:(Beer *)beer;

@end
