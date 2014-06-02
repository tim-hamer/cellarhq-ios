//
//  BeerSearchTableViewController.m
//  Cellarhq
//
//  Created by Tim Hamer on 5/20/14.
//  Copyright (c) 2014 Arca Externa. All rights reserved.
//

#import "BeerSearchTableViewController.h"
#import "NetworkRequestHandler.h"

#define CELL_IDENTIFIER @"BeerSearchTableCell"

@interface BeerSearchTableViewController () <NSURLConnectionDataDelegate>

@property (nonatomic) NSArray *searchResults;
@property (nonatomic) NSMutableData *responseData;

@end

@implementation BeerSearchTableViewController

- (id)initWithStyle:(UITableViewStyle)style {
    if (self = [super initWithStyle:style]) {

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)searchWithBreweryId:(NSString *)breweryId searchString:(NSString *)searchString {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.cellarhq.com/beer/find?breweryId=%@&q=%@", breweryId, [searchString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    [NSURLConnection connectionWithRequest:request delegate:self];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.searchResults ? self.searchResults.count : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                   reuseIdentifier:CELL_IDENTIFIER];
    
    NSDictionary *searchResult = [self.searchResults objectAtIndex:indexPath.row];
    cell.textLabel.text = searchResult[@"name"];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *searchResult = [self.searchResults objectAtIndex:indexPath.row];

    Beer *beer = [[Beer alloc] init];
    beer.name = searchResult[@"name"];
    beer.brewery = searchResult[@"brewery"];
    beer.beerId = searchResult[@"beerId"];
    beer.breweryId = searchResult[@"breweryId"];
    beer.style = searchResult[@"style"];
    beer.styleId = searchResult[@"styleId"];
    
    [self.delegate beerSelected:beer];
    self.searchResults = nil;
    [self.tableView reloadData];
}

#pragma mark - NSURLConnectionDataDelegate

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    if (!self.responseData) {
        self.responseData = [[NSMutableData alloc] init];
    }
    [self.responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    if (self.responseData) {
        NSError *error;
        NSArray *searchResults = [NSJSONSerialization JSONObjectWithData:self.responseData options:0 error:&error];
        if (error) {
            NSLog(@"ERROR parsing JSON response: %@", error.localizedDescription);
            self.searchResults = nil;
        } else {
            self.searchResults = searchResults;
        }
        [self.tableView reloadData];
        self.responseData = nil;
    }
}

@end
