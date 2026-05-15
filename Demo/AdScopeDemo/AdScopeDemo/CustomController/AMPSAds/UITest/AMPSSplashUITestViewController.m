//
//  AMPSSplashUITestViewController.m
//  AdScopeDemo
//
//  Created by Cookie on 2023/5/26.
//

#import "AMPSSplashUITestViewController.h"
#import <AdScopeFoundation/AdScopeFoundation.h>
#import <AMPSAdSDK/AMPSAdSDK.h>
#import "AdScopeDemoMacro.h"

@interface AMPSSplashUITestViewController () <AMPSSplashAdDelegate>

@property (nonatomic, strong) AMPSSplashAd *splash;

@end

@implementation AMPSSplashUITestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    CookieAMPSLog(@"外部初始化开始");
    //12433
    [[AMPSAdSDKManager sharedInstance]startAsyncWithAppId:@"12433" results:^(AMPSAdSDKInitStatus statusResult) {
        CookieAMPSLog(@"外部初始化完成 %@", [NSThread currentThread]);
        adscope_back_main_queue_safe(^{
            [self loadSplashAd];
        });
    }];
    CookieAMPSLog(@"外部初始化结束");
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClick)]];
}

- (void)didClick {
    if (self.splash.isReadyAd) {
        [self.splash showSplashViewInWindow:[UIApplication sharedApplication].keyWindow];
    } else {
        [self loadSplashAd];
    }
}

- (void)loadSplashAd {
    //12526
    self.splash = [[AMPSSplashAd alloc]initWithSpaceId:@"12526" adConfiguration:[AMPSAdConfiguration new]];
    self.splash.delegate = self;
    [self.splash loadSplashAd];
}

- (void)ampsSplashAdLoadSuccess:(AMPSSplashAd *)splashAd {
    CookieAMPSLog(@"ampsSplashAdLoadSuccess");
    [self.splash showSplashViewInWindow:[UIApplication sharedApplication].keyWindow];
}
- (void)ampsSplashAdLoadFail:(AMPSSplashAd *)splashAd error:(NSError *_Nullable)error {
    CookieAMPSLog(@"ampsSplashAdLoadFail:%@", error);
}
- (void)ampsSplashAdDidShow:(AMPSSplashAd *)splashAd {
    CookieAMPSLog(@"ampsSplashAdDidShow");
}
- (void)ampsSplashAdExposured:(AMPSSplashAd *)splashAd {
    CookieAMPSLog(@"ampsSplashAdExposured");
}
- (void)ampsSplashAdDidClick:(AMPSSplashAd *)splashAd {
    CookieAMPSLog(@"ampsSplashAdDidClick");
}
- (void)ampsSplashAdDidClose:(AMPSSplashAd *)splashAd {
    CookieAMPSLog(@"ampsSplashAdDidClose");
}

@end

