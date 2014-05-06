#import "BeerDetailViewController.h"

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
    
}


@end
