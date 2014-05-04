#import "ViewController.h"
#import "TFHpple.h"
#import "Beer.h"


@interface ViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) UILabel *label;
@property (nonatomic) UITableView *table;
@property (nonatomic) NSArray *beers;

@end

@implementation ViewController

- (instancetype) init {
    if (self = [super init]) {
        
        self.label = [[UILabel alloc] init];
        [self.view addSubview:self.label];
        
        self.table = [[UITableView alloc] init];
        self.table.delegate = self;
        self.table.dataSource = self;
        [self.view addSubview:self.table];
        
        [self.label makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@40);
            make.centerX.equalTo(self.view.centerX);
            make.top.equalTo(self.view.top).offset(20);
        }];
        
        [self.table makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view.centerX);
            make.width.equalTo(self.view.width).offset(-50);
            make.top.equalTo(self.label.bottom).offset(30);
            make.bottom.equalTo(self.view.bottom);
        }];
        
        self.view.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)loadView {
    [super loadView];
    
    self.beers = [self beersInCellarWithName:@"hansmoleman"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.label.text = @"My Cellar";
    
}

- (NSArray *)beersInCellarWithName:(NSString *)cellarName {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.cellarhq.com/cellar/%@", cellarName]];
    NSData *urlData = [NSData dataWithContentsOfURL:url];
    
    TFHpple *parser = [TFHpple hppleWithHTMLData:urlData];
    
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

@end
