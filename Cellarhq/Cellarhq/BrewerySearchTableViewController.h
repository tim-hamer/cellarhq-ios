//
//  BrewerySearchTableViewController.h
//  Cellarhq
//
//  Created by Tim Hamer on 5/20/14.
//  Copyright (c) 2014 Arca Externa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Brewery.h"

@protocol BrewerySearchTableViewControllerDelegate

- (void)brewerySelected:(Brewery *)brewery;

@end

@interface BrewerySearchTableViewController : UITableViewController

@property (nonatomic, weak) id<BrewerySearchTableViewControllerDelegate> delegate;

- (void)searchWithString:(NSString *)searchString;

@end
