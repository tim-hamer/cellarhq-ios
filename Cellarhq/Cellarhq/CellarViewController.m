#import "CellarViewController.h"
#import "TFHpple.h"
#import "Beer.h"
#import "BeerDetailViewController.h"


@interface CellarViewController () <UITableViewDataSource, UITableViewDelegate>

//@property (nonatomic) UILabel *label;
@property (nonatomic) UITableView *table;
@property (nonatomic) NSArray *beers;

@end

@implementation CellarViewController

- (instancetype) init {
    if (self = [super init]) {
        
        self.table = [[UITableView alloc] init];
        self.table.delegate = self;
        self.table.dataSource = self;
        [self.view addSubview:self.table];
        
        [self.table makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view.centerX);
            make.width.equalTo(self.view.width).offset(-50);
            make.top.equalTo(self.view.top);
            make.bottom.equalTo(self.view.bottom);
        }];
        
        self.view.backgroundColor = [UIColor whiteColor];
        self.navigationItem.title = @"My Cellar";
    }
    return self;
}

- (void)loadView {
    [super loadView];
    self.beers = [self beersInYourCellar];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (NSArray *)beersInYourCellar {
    NSURL *url = [NSURL URLWithString:@"http://www.cellarhq.com/yourcellar"];
    NSData *urlData = [NSData dataWithContentsOfURL:url];
    return [self parseBeersFromWebData:urlData];
}

- (NSArray *)beersInCellarWithName:(NSString *)cellarName {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.cellarhq.com/cellar/%@", cellarName]];
    NSData *urlData = [NSData dataWithContentsOfURL:url];
    return [self parseBeersFromWebData:urlData];
}

- (NSArray *)parseBeersFromWebData:(NSData *)data {
    TFHpple *parser = [TFHpple hppleWithHTMLData:data];
    
    NSString *tableRowQuery = @"//tbody/tr";
    NSArray *tableRows = [parser searchWithXPathQuery:tableRowQuery];
    
    NSMutableArray *beers = [NSMutableArray array];
    
    for (TFHppleElement *tableRow in tableRows) {
        TFHppleElement *breweryElement = [[tableRow searchWithXPathQuery:@"//td[@class='brewery']/a"] objectAtIndex:0];
        NSString *breweryName = [breweryElement text];
        
        TFHppleElement *beerElement = [[tableRow searchWithXPathQuery:@"//td[@class='beer']/a"] objectAtIndex:0];
        NSString *beerName = [beerElement text];
        
        TFHppleElement *quantityElement = [[tableRow searchWithXPathQuery:@"//td[@class='quantity']"] objectAtIndex:0];
        int quantity = [[quantityElement text] integerValue];
        
        NSArray *dateCellSearchResults = [tableRow searchWithXPathQuery:@"//td[@class='date']"];
        if (dateCellSearchResults.count == 0) {
            dateCellSearchResults = [tableRow searchWithXPathQuery:@"//td[@class='date notes-icon']"];
        }
        TFHppleElement *dateElement = [dateCellSearchResults objectAtIndex:0];
        NSString *date = [[dateElement text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSString *year = [date substringToIndex:4];
        
        Beer *beer = [[Beer alloc] init];
        beer.name = [NSString stringWithFormat:@"%@ %@", year, beerName];
        beer.brewery = breweryName;
        beer.quantity = quantity;
        beer.bottleDate = date;
        [beers addObject:beer];
    }
    return beers;
}

#pragma mark - UITableViewDelegate & UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cellarhq"];
    Beer *beer = (Beer *)[self.beers objectAtIndex:indexPath.row];
    cell.textLabel.text = beer.name;
    cell.detailTextLabel.text = beer.brewery;
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.beers.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BeerDetailViewController *beerDetails = [[BeerDetailViewController alloc] initWithBeer:[self.beers objectAtIndex:indexPath.row]];
    [self.navigationController pushViewController:beerDetails animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

@end
