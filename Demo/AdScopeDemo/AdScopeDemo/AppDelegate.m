//
//  AppDelegate.m
//  AdScopeDemo
//
//  Created by Cookie on 2022/2/7.
//

#import "AppDelegate.h"
#import "AdScopeBaseTabBarController.h"
#import "AdScopeDemoMacro.h"
#import <AppTrackingTransparency/AppTrackingTransparency.h>
#import "AdScopeDemoStatusObject.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window.rootViewController = [[AdScopeBaseTabBarController alloc]init];
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    if (@available(iOS 14, *)) {
        [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
            
        }];
    }
}

@end
