//
//  BeerSearchTableViewController.h
//  Cellarhq
//
//  Created by Tim Hamer on 5/20/14.
//  Copyright (c) 2014 Arca Externa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Beer.h"

@protocol BeerSearchTableViewControllerDelegate

- (void)beerSelected:(Beer *)beer;

@end

@interface BeerSearchTableViewController : UITableViewController

@property (nonatomic, weak) id<BeerSearchTableViewControllerDelegate> delegate;

- (void)searchWithBreweryId:(NSString *)breweryId searchString:(NSString *)searchString;

@end
