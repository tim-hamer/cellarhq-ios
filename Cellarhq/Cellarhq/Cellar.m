//
//  Cellar.m
//  Cellarhq
//
//  Created by Tim Hamer on 6/1/14.
//  Copyright (c) 2014 Arca Externa. All rights reserved.
//

#import "Cellar.h"
#import "TFHpple.h"
#import "Beer.h"

@interface Cellar ()

@property (nonatomic) NSArray *allBeers;
@property (nonatomic) NSArray *searchResults;

@end


@implementation Cellar

- (instancetype)init {
    if (self = [super init]) {
        self.allBeers = [self beersInYourCellar];
    }
    return self;
}

- (NSArray *)beers {
    if (self.searchResults) {
        return self.searchResults;
    }
    return self.allBeers;
}

- (NSArray *)beersInYourCellar {
    NSURL *url = [NSURL URLWithString:@"http://www.cellarhq.com/yourcellar"];
    NSData *urlData = [NSData dataWithContentsOfURL:url];
    NSArray *beers = [self parseBeersFromWebData:urlData];
    self.allBeers = beers;
    return beers;
}

- (NSArray *)beersInCellarWithName:(NSString *)cellarName {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.cellarhq.com/cellar/%@", cellarName]];
    NSData *urlData = [NSData dataWithContentsOfURL:url];
    NSArray *beers = [self parseBeersFromWebData:urlData];
    self.allBeers = beers;
    return beers;
}

- (NSArray *)parseBeersFromWebData:(NSData *)data {
    TFHpple *parser = [TFHpple hppleWithHTMLData:data];
    
    NSString *tableRowQuery = @"//tbody/tr";
    NSArray *tableRows = [parser searchWithXPathQuery:tableRowQuery];
    
    NSMutableArray *beers = [NSMutableArray array];
    
    for (TFHppleElement *tableRow in tableRows) {
        NSDictionary *attributes = tableRow.attributes;
        NSString *uniqueId = [attributes[@"id"] substringFromIndex:5];
        NSString *beerId = attributes[@"data-beerid"];
        NSString *breweryId = attributes[@"data-breweryid"];
        
        TFHppleElement *breweryElement = [[tableRow searchWithXPathQuery:@"//td[@class='brewery']/a"] objectAtIndex:0];
        NSString *breweryName = [breweryElement text];
        
        TFHppleElement *beerElement = [[tableRow searchWithXPathQuery:@"//td[@class='beer']/a"] objectAtIndex:0];
        NSString *beerName = [beerElement text];
        
        TFHppleElement *sizeElement = [[tableRow searchWithXPathQuery:@"//td[@class='size']"] objectAtIndex:0];
        NSString *size = [sizeElement text];
        
        TFHppleElement *quantityElement = [[tableRow searchWithXPathQuery:@"//td[@class='quantity']"] objectAtIndex:0];
        int quantity = [[quantityElement text] intValue];
        
        NSArray *dateCellSearchResults = [tableRow searchWithXPathQuery:@"//td[@class='date']"];
        if (dateCellSearchResults.count == 0) {
            dateCellSearchResults = [tableRow searchWithXPathQuery:@"//td[@class='date notes-icon']"];
        }
        
        TFHppleElement *styleElement = [[tableRow searchWithXPathQuery:@"//td[@class='style']"] objectAtIndex:0];
        NSString *style = [styleElement text];
        
        TFHppleElement *dateElement = [dateCellSearchResults objectAtIndex:0];
        NSString *date = [[dateElement text]
                          stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        Beer *beer = [[Beer alloc] init];
        beer.name = beerName;
        beer.brewery = breweryName;
        beer.size = size;
        beer.quantity = quantity;
        beer.bottleDate = date;
        beer.uniqueId = uniqueId;
        beer.beerId = beerId;
        beer.breweryId = breweryId;
        beer.style = style;
        
        [beers addObject:beer];
    }
    return beers;
}

- (void)performSearch:(NSString *)searchText {
    if (searchText) {
        NSPredicate *searchPredicate =
        [NSPredicate predicateWithFormat:@"name CONTAINS[cd] %@ || brewery CONTAINS[cd] %@", searchText, searchText];
        self.searchResults = [self.allBeers filteredArrayUsingPredicate:searchPredicate];
    } else {
        self.searchResults = nil;
    }
}

@end
