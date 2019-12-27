#include "AppDelegate.h"
#include "GeneratedPluginRegistrant.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [GeneratedPluginRegistrant registerWithRegistry:self];
  // Override point for customization after application launch.
  [GMSServices provideAPIKey: @AIzaSyB-ed7fvN577q8h7s7srJVqoTKO_srddAo];
  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

@end
