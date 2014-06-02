//
//  Cellar.h
//  Cellarhq
//
//  Created by Tim Hamer on 6/1/14.
//  Copyright (c) 2014 Arca Externa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Cellar : NSObject

@property (nonatomic) NSArray *beers;

- (void)performSearch:(NSString *)searchText;

@end
