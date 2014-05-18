#import "BeerDetailViewController.h"
#import "NetworkRequestHandler.h"
#import "BeerSizePicker.h"

@interface BeerDetailViewController () <BeerSizePickerDelegate>

@property (nonatomic) Beer *beer;

@property (nonatomic) UITextField *beerField;
@property (nonatomic) UITextField *breweryField;
@property (nonatomic) UITextField *dateField;
@property (nonatomic) UITextField *quantityField;
@property (nonatomic) UILabel *sizeLabel;
@property (nonatomic) BeerSizePicker *sizePicker;
@property (nonatomic) UIButton *removeOneButton;
@property (nonatomic) UIButton *saveButton;
@property (nonatomic) UIButton *cancelButton;
@property (nonatomic) UIButton *editButton;
@property (nonatomic) UIGestureRecognizer *sizeLabelTouchRecognizer;

// TODO: nicer layout
// TODO: show table of other vintages of the same beer in your cellar
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
        quantityLabel.text = @"Quantity: ";
        self.quantityField = [[UITextField alloc] init];
        self.sizeLabel = [[UILabel alloc] init];
        self.sizePicker = [[BeerSizePicker alloc] init];
        self.sizePicker.hidden = YES;
        
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

        self.cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [self.cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
        [self.cancelButton addTarget:self
                            action:@selector(cancelButtonPressed)
                  forControlEvents:UIControlEventTouchUpInside];

        self.editButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [self.editButton setTitle:@"Edit" forState:UIControlStateNormal];
        [self.editButton addTarget:self
                            action:@selector(editButtonPressed)
                  forControlEvents:UIControlEventTouchUpInside];


        [self.view addSubview:self.beerField];
        [self.view addSubview:self.breweryField];
        [self.view addSubview:self.dateField];
        [self.view addSubview:quantityLabel];
        [self.view addSubview:self.quantityField];
        [self.view addSubview:self.sizeLabel];
        [self.view addSubview:self.sizePicker];
        [self.view addSubview:self.removeOneButton];
        [self.view addSubview:self.saveButton];
        [self.view addSubview:self.cancelButton];
        [self.view addSubview:self.editButton];
        
        [self.editButton makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.top).offset(70);
            make.right.equalTo(self.view.right).offset(-10);
        }];
        
        [self.breweryField makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.editButton.bottom).offset(10);
            make.width.equalTo(self.view.width).offset(-40);
            make.centerX.equalTo(self.view.centerX);
            make.height.equalTo(@30);
        }];
        
        [self.beerField makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.breweryField.bottom).offset(10);
            make.centerX.equalTo(self.view.centerX);
            make.width.equalTo(self.view.width).offset(-40);
            make.height.equalTo(@30);
        }];
        
        [self.dateField makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.beerField.bottom).offset(20);
            make.left.equalTo(self.view).offset(20);
            make.width.equalTo(@100);
        }];
        
        [self.sizeLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.dateField.bottom).offset(20);
            make.left.equalTo(self.dateField.left);
        }];
        
        [quantityLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.sizeLabel.bottom).offset(20);
            make.left.equalTo(self.sizeLabel.left);
        }];
        
        [self.quantityField makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.sizeLabel.bottom).offset(20);
            make.left.equalTo(quantityLabel.right).offset(10);
            make.width.equalTo(@60);
        }];
        
        [self.removeOneButton makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.quantityField.bottom).offset(30);
            make.left.equalTo(quantityLabel.left);
        }];

        [self.saveButton makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.quantityField.bottom).offset(30);
            make.left.equalTo(self.removeOneButton.left);
        }];
        
        [self.cancelButton makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.saveButton.top);
            make.left.equalTo(self.saveButton.right).offset(30);
        }];
        
        [self.sizePicker makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view.bottom);
            make.centerX.equalTo(self.view.centerX);
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
    self.quantityField.text = [NSString stringWithFormat:@"%d", self.beer.quantity];
    self.sizeLabel.text = [NSString stringWithFormat:@"%@", self.beer.size ?: @"Select a Size"];
    self.sizeLabel.userInteractionEnabled = YES;
    self.sizeLabelTouchRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showSizePicker)];
    self.sizePicker.delegate = self;
}

-(void)setEditMode:(BOOL)editMode {
    if (editMode) {
        self.removeOneButton.hidden = YES;
        self.saveButton.hidden = NO;
        self.cancelButton.hidden = NO;
        
        self.beerField.enabled = YES;
        self.breweryField.enabled = YES;
        self.quantityField.enabled = YES;
        self.dateField.enabled = YES;
        [self.sizeLabel addGestureRecognizer:self.sizeLabelTouchRecognizer];
        
        self.beerField.borderStyle = UITextBorderStyleBezel;
        self.breweryField.borderStyle = UITextBorderStyleBezel;
        self.quantityField.borderStyle = UITextBorderStyleBezel;
        self.dateField.borderStyle = UITextBorderStyleBezel;
        
        
        self.beerField.placeholder = @"Beer";
        self.breweryField.placeholder = @"Brewery";
        self.dateField.placeholder = @"Bottle Date";
        
    } else {
        self.removeOneButton.hidden = NO;
        self.saveButton.hidden = YES;
        self.cancelButton.hidden = YES;
        
        self.beerField.enabled = NO;
        self.breweryField.enabled = NO;
        self.quantityField.enabled = NO;
        self.dateField.enabled = NO;
        [self.sizeLabel removeGestureRecognizer:self.sizeLabelTouchRecognizer];
        
        self.beerField.borderStyle = UITextBorderStyleNone;
        self.breweryField.borderStyle = UITextBorderStyleNone;
        self.quantityField.borderStyle = UITextBorderStyleNone;
        self.dateField.borderStyle = UITextBorderStyleNone;
    }
}

- (void)editButtonPressed {
    self.editMode = YES;
}

- (void)cancelButtonPressed {
    self.editMode = NO;
    self.breweryField.text = self.beer.brewery;
    self.beerField.text = self.beer.name;
    self.quantityField.text = [NSString stringWithFormat:@"%d", self.beer.quantity];
    self.dateField.text = self.beer.bottleDate;
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

- (void)showSizePicker {
    self.sizePicker.hidden = NO;
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
                                   // TODO: this isn't great. should refresh state from database
                                   self.beer.quantity = newQuantity;
                                   self.quantityField.text = [NSString stringWithFormat:@"%d", newQuantity];
                               }];
}

#pragma mark - BeerSizePickerDelegate

- (void)sizeSelected:(NSString *)size {
    self.beer.size = size;
    self.sizeLabel.text = size;
    self.sizePicker.hidden = YES;
}


@end
