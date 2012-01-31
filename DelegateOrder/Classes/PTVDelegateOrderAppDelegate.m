//
//  PTVDelegateOrderAppDelegate.m
//  DelegateOrder
//
//  by Joe D'Andrea and Adrian Kosmaczewski
//

#import "PTVDelegateOrderAppDelegate.h"
#import "PTVRootViewController.h"

@implementation PTVDelegateOrderAppDelegate

@synthesize window = _window;
@synthesize navigationController = _navigationController;

#pragma mark - UIApplicationDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions 
{
    [self.window makeKeyAndVisible];
    return YES;
}

#pragma mark - NSObject

- (void)dealloc 
{
	[_navigationController release];
	[_window release];
	[super dealloc];
}

@end
