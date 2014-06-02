#import "BeerDetailViewController.h"
#import "NetworkRequestHandler.h"
#import "BeerSizePicker.h"
#import "BrewerySearchTableViewController.h"
#import "BeerSearchTableViewController.h"

@interface BeerDetailViewController () <BeerSizePickerDelegate,
                                        UITextFieldDelegate,
                                        BrewerySearchTableViewControllerDelegate,
                                        BeerSearchTableViewControllerDelegate>

@property (nonatomic) Beer *beer;
@property (nonatomic) Brewery *brewery;
@property (nonatomic) UIScrollView *scrollView;
@property (nonatomic) UITextField *beerField;
@property (nonatomic) UITextField *breweryField;
@property (nonatomic) UITextField *dateField;
@property (nonatomic) UILabel *quantityLabel;
@property (nonatomic) UITextField *quantityField;
@property (nonatomic) UILabel *sizeLabel;
@property (nonatomic) BeerSizePicker *sizePicker;
@property (nonatomic) UIButton *removeOneButton;
@property (nonatomic) UIButton *saveButton;
@property (nonatomic) UIButton *cancelButton;
@property (nonatomic) UIButton *editButton;
@property (nonatomic) UIGestureRecognizer *sizeLabelTouchRecognizer;
@property (nonatomic) BrewerySearchTableViewController *brewerySearchTableViewController;
@property (nonatomic) BeerSearchTableViewController *beerSearchTableViewController;

// TODO: nicer layout
// TODO: show table of other vintages of the same beer in your cellar
// TODO: personal tasting notes, link to public information

@end

@implementation BeerDetailViewController

- (id)initWithBeer:(Beer *)beer editing:(BOOL)editing {
    if (self = [super init]) {
        self.beer = beer;
        self.editMode = editing;
        
        self.breweryField = [[UITextField alloc] init];
        self.breweryField.delegate = self;
        self.beerField = [[UITextField alloc] init];
        self.beerField.delegate = self;
        self.dateField = [[UITextField alloc] init];
        self.quantityLabel = [[UILabel alloc] init];
        self.quantityLabel.text = @"Quantity: ";
        self.quantityField = [[UITextField alloc] init];
        self.sizeLabel = [[UILabel alloc] init];
        self.sizePicker = [[BeerSizePicker alloc] init];
        self.sizePicker.hidden = YES;
        
        self.breweryField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        self.breweryField.autocorrectionType = UITextAutocorrectionTypeNo;
        self.breweryField.spellCheckingType = UITextSpellCheckingTypeNo;

        self.beerField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        self.beerField.autocorrectionType = UITextAutocorrectionTypeNo;
        self.beerField.spellCheckingType = UITextSpellCheckingTypeNo;

        
        self.sizeLabelTouchRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                action:@selector(showSizePicker)];
        self.brewerySearchTableViewController =
            [[BrewerySearchTableViewController alloc] initWithStyle:UITableViewStylePlain];
        self.brewerySearchTableViewController.delegate = self;
        self.beerSearchTableViewController = [[BeerSearchTableViewController alloc] initWithStyle:UITableViewStylePlain];
        self.beerSearchTableViewController.delegate = self;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    
    self.scrollView = [[UIScrollView alloc] init];
    [self.view addSubview:self.scrollView];
    [self.scrollView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.scrollView addSubview:self.beerField];
    [self.scrollView addSubview:self.breweryField];
    [self.scrollView addSubview:self.dateField];
    [self.scrollView addSubview:self.quantityLabel];
    [self.scrollView addSubview:self.quantityField];
    [self.scrollView addSubview:self.sizeLabel];
    [self.scrollView addSubview:self.sizePicker];
    [self.scrollView addSubview:self.removeOneButton];
    [self.scrollView addSubview:self.saveButton];
    [self.scrollView addSubview:self.cancelButton];
    [self.scrollView addSubview:self.editButton];
    [self.scrollView addSubview:self.brewerySearchTableViewController.tableView];
    [self.scrollView addSubview:self.beerSearchTableViewController.tableView];
    
    [self.editButton makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView.top).offset(10);
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
        make.centerX.equalTo(self.scrollView.centerX);
        make.width.equalTo(self.view.width).offset(-40);
        make.height.equalTo(@30);
    }];
    
    [self.dateField makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.beerField.bottom).offset(20);
        make.left.equalTo(self.scrollView).offset(20);
        make.width.equalTo(@130);
    }];
    
    [self.sizeLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.dateField.centerY);
        make.left.equalTo(self.dateField.right).offset(30);
    }];
    
    [self.quantityLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.dateField.bottom).offset(20);
        make.left.equalTo(self.dateField.left);
    }];
    
    [self.quantityField makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.sizeLabel.bottom).offset(20);
        make.left.equalTo(self.quantityLabel.right).offset(10);
        make.width.equalTo(@60);
    }];
    
    [self.removeOneButton makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.quantityField.bottom).offset(30);
        make.left.equalTo(self.quantityLabel.left);
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
    
    [self.brewerySearchTableViewController.tableView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.breweryField.bottom);
        make.width.equalTo(self.breweryField.width);
        make.height.equalTo(@200);
    }];
    
    [self.beerSearchTableViewController.tableView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.beerField.bottom);
        make.width.equalTo(self.beerField.width);
        make.height.equalTo(@200);
    }];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = self.beer.name;
    
    self.beerField.text = self.beer.name;
    self.breweryField.text = self.beer.brewery;
    self.dateField.text = self.beer.bottleDate;
    self.quantityField.text = [NSString stringWithFormat:@"%d", self.beer.quantity];
    self.sizeLabel.text = [NSString stringWithFormat:@"%@", self.beer.size ?: @"< Select a Size >"];
    self.sizeLabel.userInteractionEnabled = YES;
    self.sizePicker.delegate = self;
    self.brewerySearchTableViewController.tableView.hidden = YES;
    self.beerSearchTableViewController.tableView.hidden = YES;
    
    [self enableEditing:self.editMode];
}

- (void)enableEditing:(BOOL)editing {
    if (editing) {
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

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
- (void)editButtonPressed {
    [self enableEditing:YES];
}

- (void)cancelButtonPressed {
    if (self.beer.uniqueId) {
        [self enableEditing:NO];
        self.breweryField.text = self.beer.brewery;
        self.beerField.text = self.beer.name;
        self.quantityField.text = [NSString stringWithFormat:@"%d", self.beer.quantity];
        self.dateField.text = self.beer.bottleDate;
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)removeOneButtonPressed {
    if (self.beer.quantity == 1) {
        [self deleteBeer];
    } else {
        self.quantityField.text = [NSString stringWithFormat:@"%d", self.beer.quantity - 1];
        [self updateBeer];
    }
}

- (void)saveButtonPressed {
    if (self.beer.uniqueId) {
        [self updateBeer];
    } else {
        [self createNewBeer];
    }
}

- (void)createNewBeer {
    self.beer.size = self.sizeLabel.text;
    self.beer.quantity = [self.quantityField.text intValue];
    self.beer.bottleDate = self.dateField.text;
    if ([self.beer validate]) {
        NetworkRequestHandler *network = [[NetworkRequestHandler alloc] init];
        NSURL *url = [NSURL URLWithString:@"http://www.cellarhq.com/yourcellar/createOrUpdate"];
        NSDictionary *parameters = @{@"beerId":self.beer.beerId,
                                     @"beer":self.beer.name,
                                     @"breweryId":self.beer.breweryId,
                                     @"brewery":self.beer.brewery,
                                     @"_action":@"create",
                                     @"quantity":[NSString stringWithFormat:@"%d", self.beer.quantity],
                                     @"size":self.beer.size,
                                     @"style":self.beer.style,
                                     @"styleId":self.beer.styleId,
                                     @"bottleDate":self.beer.bottleDate,
                                     @"notes":self.beer.notes ?: @""};
        [network handleHttpPostRequestWithUrl:url
                                   parameters:parameters
                                   onComplete:^(NSInteger statusCode, NSError *error) {
                                       if (!error) {
                                           [self enableEditing:NO];
                                       }
                                   }];
    } else {
        UIAlertView *errorView = [[UIAlertView alloc] initWithTitle:@"ERROR" message:@"Beer could not be added due to invalid data" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [errorView show];
    }
}

- (void)showSizePicker {
    [self.breweryField endEditing:YES];
    [self.beerField endEditing:YES];
    [self.quantityField endEditing:YES];
    [self.dateField endEditing:YES];
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

- (void)updateBeer {
    NetworkRequestHandler *network = [[NetworkRequestHandler alloc] init];
    NSURL *url = [NSURL URLWithString:@"http://www.cellarhq.com/yourcellar/createOrUpdate"];
    if ([self.beer validate]) {
        NSDictionary *parameters = @{@"id":self.beer.uniqueId,
                                     @"beerId":self.beer.beerId,
                                     @"beer":self.beerField.text,
                                     @"breweryId":self.beer.breweryId,
                                     @"brewery":self.breweryField.text,
                                     @"_action":@"update",
                                     @"quantity":self.quantityField.text,
                                     @"originalQuantity":[NSString stringWithFormat:@"%d", self.beer.quantity],
                                     @"size":self.sizeLabel.text,
                                     @"bottleDate":self.dateField.text,
                                     @"notes":self.beer.notes};
        [network handleHttpPostRequestWithUrl:url
                                   parameters:parameters
                                   onComplete:^(NSInteger statusCode, NSError *error) {
                                       if (!error) {
                                           // TODO: this isn't great. should refresh beer info from server
                                           self.beer.name = self.beerField.text;
                                           self.beer.brewery = self.breweryField.text;
                                           self.beer.size = self.sizeLabel.text;
                                           self.beer.quantity = [self.quantityField.text intValue];
                                           
                                           [self enableEditing:NO];
                                       }
                                   }];
    } else {
        UIAlertView *errorView = [[UIAlertView alloc] initWithTitle:@"ERROR" message:@"Beer could not be updated due to invalid data" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [errorView show];
    }
}

#pragma mark - BeerSizePickerDelegate

- (void)sizeSelected:(NSString *)size {
    self.beer.size = size;
    self.sizeLabel.text = size;
    self.sizePicker.hidden = YES;
}

#pragma mark - UITextFieldDelegate

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *searchText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (textField == self.breweryField) {
        if (searchText.length >= 3) {
            self.brewerySearchTableViewController.tableView.hidden = NO;
            [self.brewerySearchTableViewController searchWithString:searchText];
        } else {
            self.brewerySearchTableViewController.tableView.hidden = YES;
        }
    } else if (textField == self.beerField) {
        if (searchText.length > 0) {
            self.beerSearchTableViewController.tableView.hidden = NO;
            [self.beerSearchTableViewController searchWithBreweryId:self.brewery.breweryId searchString:searchText];
        } else {
            self.beerSearchTableViewController.tableView.hidden = YES;
        }
    }
        
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == self.breweryField) {
        self.brewerySearchTableViewController.tableView.hidden = YES;
    } else if (textField == self.beerField) {
        self.beerSearchTableViewController.tableView.hidden = YES;
    }
}

#pragma mark - BrewerySearchTableViewControllerDelegate

- (void)brewerySelected:(Brewery *)brewery {
    self.breweryField.text = brewery.name;
    self.brewery = brewery;
    self.brewerySearchTableViewController.tableView.hidden = YES;
}

#pragma mark - BeerSearchTableViewControllerDelegate

- (void)beerSelected:(Beer *)beer {
    self.beerField.text = beer.name;
    self.beer = beer;
    self.beerSearchTableViewController.tableView.hidden = YES;
}


@end
