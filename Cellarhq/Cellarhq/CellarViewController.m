#import "CellarViewController.h"
#import "Beer.h"
#import "BeerDetailViewController.h"
#import "NetworkRequestHandler.h"


@interface CellarViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property (nonatomic) Cellar *cellar;
@property (nonatomic) UISearchBar *searchBar;
@property (nonatomic) UITableView *table;

@end

@implementation CellarViewController

- (instancetype) initWithCellar:(Cellar *)cellar {
    if (self = [super init]) {
        self.cellar = cellar;
        self.searchBar = [[UISearchBar alloc] init];
        self.searchBar.delegate = self;
        [self.view addSubview:self.searchBar];
        
        self.table = [[UITableView alloc] init];
        self.table.delegate = self;
        self.table.dataSource = self;
        [self.view addSubview:self.table];
        
        [self.searchBar makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.top).offset(65);
            make.left.equalTo(self.view.left);
            make.width.equalTo(self.view.width);
        }];
        
        [self.table makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view.centerX);
            make.width.equalTo(self.view.width).offset(-50);
            make.top.equalTo(self.searchBar.bottom);
            make.bottom.equalTo(self.view.bottom);
        }];
        
        self.view.backgroundColor = [UIColor whiteColor];
        self.navigationItem.title = @"My Cellar";
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addBeer)];
    }
    return self;
}

- (void)loadView {
    [super loadView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)addBeer {
    BeerDetailViewController *viewController = [[BeerDetailViewController alloc] initWithBeer:nil editing:YES];
    [self.navigationController pushViewController:viewController animated:YES];
}


#pragma mark - UITableViewDelegate & UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cellarhq"];
    Beer *beer = (Beer *)[self.cellar.beers objectAtIndex:indexPath.row];
    
    NSString *year = [beer.bottleDate substringToIndex:4];
    cell.textLabel.text = beer.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ - %@", beer.brewery, year];
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cellar.beers.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BeerDetailViewController *beerDetails = [[BeerDetailViewController alloc] initWithBeer:[self.cellar.beers objectAtIndex:indexPath.row] editing:NO];
    [self.navigationController pushViewController:beerDetails animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - UISearchBarDelegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    searchBar.showsCancelButton = YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    searchBar.showsCancelButton = NO;
    searchBar.text = nil;
    [self.cellar performSearch:nil];
    [self.table reloadData];
}

- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    NSString *searchText = [searchBar.text stringByReplacingCharactersInRange:range withString:text];
    [self.cellar performSearch:searchText];
    [self.table reloadData];
    
    return YES;
}

@end
