#import "ViewController.h"


@interface ViewController ()

@property (nonatomic) UILabel *label;

@end

@implementation ViewController

- (instancetype) init {
    if (self = [super init]) {
        
        self.label = [[UILabel alloc] init];
        [self.view addSubview:self.label];
        
        [self.label makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@40);
            make.centerX.equalTo(self.view.centerX);
            make.top.equalTo(self.view.top).offset(20);
        }];
        
        self.view.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.label.text = @"Hello World";
}

@end
