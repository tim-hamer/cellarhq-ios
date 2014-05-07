#import "BeerDetailViewController.h"
#import "NetworkRequestHandler.h"

@interface BeerDetailViewController ()

@property (nonatomic) Beer *beer;

@property (nonatomic) UITextField *beerField;
@property (nonatomic) UITextField *breweryField;
@property (nonatomic) UITextField *dateField;
@property (nonatomic) UITextField *quantityField;
@property (nonatomic) UIPickerView *sizePicker;
@property (nonatomic) UIButton *removeOneButton;
@property (nonatomic) UIButton *saveButton;

// TODO: table of other vintages of the same beer in your cellar
// TODO: personal tasting notes, link to public information

@end

@implementation BeerDetailViewController

- (id)initWithBeer:(Beer *)beer {
    if (self = [super init]) {
        self.beer = beer;
        
        self.beerField = [[UITextField alloc] init];
        self.breweryField = [[UITextField alloc] init];
        self.dateField = [[UITextField alloc] init];
        UILabel *quantityLabel = [[UILabel alloc] init];
        self.quantityField = [[UITextField alloc] init];
        
        self.removeOneButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [self.removeOneButton setTitle:@"Drink One" forState:UIControlStateNormal];
        [self.removeOneButton addTarget:self
                                 action:@selector(removeOneButtonPressed)
                       forControlEvents:UIControlEventTouchUpInside];

        self.saveButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [self.saveButton setTitle:@"Save" forState:UIControlStateNormal];
        [self.saveButton addTarget:self
                                 action:@selector(saveButtonPressed)
                       forControlEvents:UIControlEventTouchUpInside];

        [self.view addSubview:self.beerField];
        [self.view addSubview:self.breweryField];
        [self.view addSubview:self.dateField];
        [self.view addSubview:quantityLabel];
        [self.view addSubview:self.quantityField];
        [self.view addSubview:self.removeOneButton];
        [self.view addSubview:self.saveButton];
        
        [self.beerField makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.top).offset(80);
            make.width.equalTo(self.view.width).offset(-40);
            make.centerX.equalTo(self.view.centerX);
            make.height.equalTo(@30);
        }];
        
        [self.breweryField makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.beerField.bottom).offset(10);
            make.centerX.equalTo(self.view.centerX);
            make.width.equalTo(self.view.width).offset(-40);
            make.height.equalTo(@30);
        }];
        
        [self.dateField makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.breweryField.bottom).offset(20);
            make.left.equalTo(self.view).offset(20);
            make.width.equalTo(@100);
        }];
        
        [quantityLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.dateField.bottom).offset(20);
            make.left.equalTo(self.dateField.left);
        }];
        
        [self.quantityField makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.dateField.bottom).offset(20);
            make.left.equalTo(quantityLabel.right).offset(10);
            make.width.equalTo(@60);
        }];
        
        [self.removeOneButton makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.quantityField.bottom).offset(30);
            make.left.equalTo(quantityLabel.left);
        }];

        [self.saveButton makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.quantityField.bottom).offset(30);
            make.left.equalTo(quantityLabel.left);
        }];

        self.view.backgroundColor = [UIColor whiteColor];
        self.navigationItem.title = beer.name;
        
        self.editMode = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.beerField.text = self.beer.name;
    self.breweryField.text = self.beer.brewery;
    self.dateField.text = self.beer.bottleDate;
    self.quantityField.text = [NSString stringWithFormat:@"Quantity: %d", self.beer.quantity];
}

-(void)setEditMode:(BOOL)editMode {
    if (editMode) {
        self.removeOneButton.hidden = YES;
        self.saveButton.hidden = NO;
        
        self.beerField.enabled = YES;
        self.breweryField.enabled = YES;
        self.quantityField.enabled = YES;
        self.dateField.enabled = YES;
        
        self.beerField.borderStyle = UITextBorderStyleBezel;
        self.breweryField.borderStyle = UITextBorderStyleBezel;
        self.quantityField.borderStyle = UITextBorderStyleBezel;
        self.dateField.borderStyle = UITextBorderStyleBezel;
    } else {
        self.removeOneButton.hidden = NO;
        self.saveButton.hidden = YES;
        
        self.beerField.enabled = NO;
        self.breweryField.enabled = NO;
        self.quantityField.enabled = NO;
        self.dateField.enabled = NO;
        
        self.beerField.borderStyle = UITextBorderStyleNone;
        self.breweryField.borderStyle = UITextBorderStyleNone;
        self.quantityField.borderStyle = UITextBorderStyleNone;
        self.dateField.borderStyle = UITextBorderStyleNone;
    }
}

- (void)removeOneButtonPressed {
    if (self.beer.quantity == 1) {
        [self deleteBeer];
    } else {
        [self updateBeerQuantity:self.beer.quantity newQuantity:(self.beer.quantity - 1)];
    }
}

- (void)saveButtonPressed {
    self.beer = [[Beer alloc] init];
    self.beer.name = self.beerField.text;
    self.beer.brewery = self.breweryField.text;
    self.beer.quantity = [self.quantityField.text intValue];
    self.beer.bottleDate = self.dateField.text;
    NetworkRequestHandler *network = [[NetworkRequestHandler alloc] init];
    NSURL *url = [NSURL URLWithString:@"http://www.cellarhq.com/yourcellar/createOrUpdate"];
    NSDictionary *parameters = @{@"beerId":self.beer.beerId,
                                 @"beer":self.beer.name,
                                 @"breweryId":self.beer.breweryId,
                                 @"brewery":self.beer.brewery,
                                 @"_action":@"create",
                                 @"quantity":[NSString stringWithFormat:@"%d", self.beer.quantity],
//                                 @"originalQuantity":[NSString stringWithFormat:@"%d", oldQuantity],
                                 @"size":self.beer.size,
                                 @"bottleDate":self.beer.bottleDate,
                                 @"notes":self.beer.notes};
    [network handleHttpPostRequestWithUrl:url
                               parameters:parameters
                               onComplete:^(NSInteger statusCode, NSError *error) {
                                   if (!error) {
                                       self.editMode = NO;
                                   }
                               }];

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
