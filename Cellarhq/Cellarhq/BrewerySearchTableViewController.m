//
//  BrewerySearchTableViewController.m
//  Cellarhq
//
//  Created by Tim Hamer on 5/20/14.
//  Copyright (c) 2014 Arca Externa. All rights reserved.
//

#import "BrewerySearchTableViewController.h"
#import "NetworkRequestHandler.h"

#define CELL_IDENTIFIER @"BrewerySearchTableCell"

@interface BrewerySearchTableViewController () <NSURLConnectionDataDelegate>

@property (nonatomic) NSArray *searchResults;
@property (nonatomic) NSMutableData *responseData;

@end

@implementation BrewerySearchTableViewController

- (id)initWithStyle:(UITableViewStyle)style {
    if (self = [super initWithStyle:style]) {

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)searchWithString:(NSString *)searchString {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.cellarhq.com/brewery/find?q=%@&format=json", searchString]];
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
    Brewery *brewery = [[Brewery alloc] init];
    NSDictionary *searchResult = [self.searchResults objectAtIndex:indexPath.row];
    brewery.name = searchResult[@"name"];
    brewery.breweryId = searchResult[@"id"];
    [self.delegate brewerySelected:brewery];
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
        self.searchResults = [NSJSONSerialization JSONObjectWithData:self.responseData options:0 error:&error];
        if (error) {
            NSLog(@"ERROR parsing JSON response: %@", error.localizedDescription);
        } else {
            [self.tableView reloadData];
        }
    }
}

@end
