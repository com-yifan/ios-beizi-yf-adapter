//
//  AdScopeBaseNavigationController.m
//  AdScopeDemo
//
//  Created by Cookie on 2022/9/6.
//

#import "AdScopeBaseNavigationController.h"
#import <AdScopeFoundation/AdScopeFoundation.h>
#import "AdScopeDemoMacro.h"

@interface AdScopeBaseNavigationController ()

@end

@implementation AdScopeBaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 15.0, *)) {
        UINavigationBarAppearance *appearance = [[UINavigationBarAppearance alloc]init];
        appearance.backgroundColor = [UIColor adScopeColorWithHexString:@"#6495ED"];
        self.navigationBar.standardAppearance = appearance;
        self.navigationBar.scrollEdgeAppearance = appearance;
        self.navigationBar.compactAppearance = appearance;
        self.navigationBar.compactScrollEdgeAppearance = appearance;
    }
    self.navigationBar.backgroundColor = [UIColor adScopeColorWithHexString:@"#6495ED"];
    
    NSString *changeClass = @"AdScopeADNStringResources";
    if ([[NSUserDefaults standardUserDefaults]boolForKey:AdScopeASNPNowEnvironment]) {
        [changeClass adScope_invokeClassMethod:@"adscope_adn_change_configure_development"];
        self.navigationItem.title = @"测试环境";
    } else {
        [changeClass adScope_invokeClassMethod:@"adscope_adn_change_configure_online"];
        self.navigationItem.title = @"正式环境";
    }
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.childViewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}

- (UIViewController *)childViewControllerForStatusBarStyle{
    return self.topViewController;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
