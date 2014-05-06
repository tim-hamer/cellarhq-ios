#import "BeerDetailViewController.h"
#import "NetworkRequestHandler.h"

@interface BeerDetailViewController ()

@property (nonatomic) Beer *beer;

@property (nonatomic) UILabel *beerLabel;
@property (nonatomic) UILabel *breweryLabel;
@property (nonatomic) UILabel *dateLabel;
@property (nonatomic) UILabel *quantityLabel;
@property (nonatomic) UIButton *removeOneButton;

// TODO: table of other vintages of the same beer in your cellar
// TODO: personal tasting notes, link to public information

@end

@implementation BeerDetailViewController

- (id)initWithBeer:(Beer *)beer {
    if (self = [super init]) {
        self.beer = beer;
        
        self.beerLabel = [[UILabel alloc] init];
        self.breweryLabel = [[UILabel alloc] init];
        self.dateLabel = [[UILabel alloc] init];
        self.quantityLabel = [[UILabel alloc] init];
        
        self.removeOneButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [self.removeOneButton setTitle:@"Drink One" forState:UIControlStateNormal];
        [self.removeOneButton addTarget:self
                                 action:@selector(removeOneButtonPressed)
                       forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:self.beerLabel];
        [self.view addSubview:self.breweryLabel];
        [self.view addSubview:self.dateLabel];
        [self.view addSubview:self.quantityLabel];
        [self.view addSubview:self.removeOneButton];
        
        [self.beerLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.top).offset(60);
            make.width.equalTo(self.view.width).offset(-40);
            make.centerX.equalTo(self.view.centerX);
            make.height.equalTo(@40);
        }];
        
        [self.breweryLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.beerLabel.bottom).offset(10);
            make.centerX.equalTo(self.view.centerX);
            make.width.equalTo(self.view.width).offset(-40);
            make.height.equalTo(@30);
        }];
        
        [self.dateLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.breweryLabel.bottom).offset(20);
            make.left.equalTo(self.view).offset(20);
        }];
        
        [self.quantityLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.dateLabel.bottom).offset(20);
            make.left.equalTo(self.dateLabel.left);
        }];
        
        [self.removeOneButton makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.quantityLabel.bottom).offset(30);
            make.left.equalTo(self.quantityLabel.left);
        }];
        
        self.view.backgroundColor = [UIColor whiteColor];
        self.navigationItem.title = beer.name;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.beerLabel.text = self.beer.name;
    self.breweryLabel.text = self.beer.brewery;
    self.dateLabel.text = self.beer.bottleDate;
    self.quantityLabel.text = [NSString stringWithFormat:@"Quantity: %d", self.beer.quantity];
}

- (void)removeOneButtonPressed {
    if (self.beer.quantity == 1) {
        [self deleteBeer];
    } else {
        [self updateBeerQuantity:self.beer.quantity newQuantity:(self.beer.quantity - 1)];
    }
}

- (void)deleteBeer {
    NetworkRequestHandler *network = [[NetworkRequestHandler alloc] init];
    NSURL *url = [NSURL URLWithString:@"http://www.cellarhq.com/yourcellar/delete"];
    NSDictionary *parameters = @{@"id":self.beer.uniqueId, @"beerId":self.beer.beerId, @"beer":self.beer.name, @"breweryId":self.beer.breweryId, @"brewery":self.beer.brewery};
    [network handleHttpPostRequestWithUrl:url
                               parameters:parameters
                               onComplete:^(NSInteger statusCode, NSError *error) {
                                   [self.navigationController popViewControllerAnimated:YES];
                                   NSLog(@"Deleted beer");
                               }];
}

- (void)updateBeerQuantity:(NSInteger)oldQuantity newQuantity:(NSInteger)newQuantity {
    NetworkRequestHandler *network = [[NetworkRequestHandler alloc] init];
    NSURL *url = [NSURL URLWithString:@"http://www.cellarhq.com/yourcellar/createOrUpdate"];
    NSDictionary *parameters = @{@"id":self.beer.uniqueId,
                                 @"beerId":self.beer.beerId,
                                 @"beer":self.beer.name,
                                 @"breweryId":self.beer.breweryId,
                                 @"brewery":self.beer.brewery,
                                 @"_action":@"update",
                                 @"quantity":[NSString stringWithFormat:@"%d", newQuantity],
                                 @"originalQuantity":[NSString stringWithFormat:@"%d", oldQuantity],
                                 @"size":self.beer.size,
                                 @"bottleDate":self.beer.bottleDate,
                                 @"notes":self.beer.notes};
    [network handleHttpPostRequestWithUrl:url
                               parameters:parameters
                               onComplete:^(NSInteger statusCode, NSError *error) {
                                   // TODO: update UI with new beer quantity
                                   [self.navigationController popViewControllerAnimated:YES];
                               }];
}


@end
