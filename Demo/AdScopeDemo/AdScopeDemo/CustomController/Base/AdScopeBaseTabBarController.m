//
//  AdScopeBaseTabBarController.m
//  AdScopeDemo
//
//  Created by Cookie on 2022/9/6.
//

#import "AdScopeBaseTabBarController.h"
#import "AdScopeBaseNavigationController.h"
#import "AMPSHomeViewController.h"
#import <AdScopeFoundation/AdScopeFoundation.h>

@interface AdScopeBaseTabBarController ()<UITabBarControllerDelegate>

@end

@implementation AdScopeBaseTabBarController

- (BOOL)shouldAutorotate {
    return NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setDelegate:self];
    [self RootViewController];
    [self setAnimation];
}

- (void)RootViewController {
    AMPSHomeViewController *apmsHomeVC = [[AMPSHomeViewController alloc]init];
    [apmsHomeVC.tabBarItem setTitlePositionAdjustment:UIOffsetMake(0, -3)];
//    settingVC.tabBarItem.image = [[UIImage imageNamed:@"tab_me_off"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    settingVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"tab_me_on"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    apmsHomeVC.title = @"AMPS测试";
    AdScopeBaseNavigationController *ampsHomeNav = [[AdScopeBaseNavigationController alloc]initWithRootViewController:apmsHomeVC];
    
    [UITabBar appearance].translucent = NO;
    self.tabBar.tintColor = [UIColor whiteColor];
    self.tabBar.unselectedItemTintColor = [UIColor lightGrayColor];
    self.tabBar.backgroundColor = [UIColor adScopeColorWithHexString:@"#6495ED"];
    self.tabBar.barTintColor = [UIColor adScopeColorWithHexString:@"#6495ED"];
    self.viewControllers = @[ampsHomeNav];
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    if ([viewController isKindOfClass:[UINavigationController class]]) {
        
    }
    return YES;
}

- (void)setAnimation {
    for (UIControl * tabBarButton in self.tabBar.subviews) {
        if ([tabBarButton isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            [tabBarButton addTarget:self action:@selector(tabBarButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
}

- (void)tabBarButtonClick:(UIControl *)tabBarButton {
    for (UIView * imageView in tabBarButton.subviews) {
        if ([imageView isKindOfClass:NSClassFromString(@"UITabBarSwappableImageView")]) {
            CAKeyframeAnimation * animation = [CAKeyframeAnimation animation];
            animation.keyPath = @"transform.scale";
            animation.values = @[@1.0,@1.2,@0.8,@1.0];
            animation.duration = 0.3;
            animation.calculationMode = kCAAnimationCubic;
            [imageView.layer addAnimation:animation forKey:nil];
        }
    }
}

@end
