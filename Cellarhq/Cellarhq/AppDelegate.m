#import "AppDelegate.h"
#import "CellarViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

    
    CellarViewController *viewController = [[CellarViewController alloc] init];
    UINavigationController *navigationController =
            [[UINavigationController alloc] initWithRootViewController:viewController];
    
    [navigationController setNavigationBarHidden:NO];
    self.window.rootViewController = navigationController;
    [self.window makeKeyAndVisible];

    return YES;
}
							

@end
