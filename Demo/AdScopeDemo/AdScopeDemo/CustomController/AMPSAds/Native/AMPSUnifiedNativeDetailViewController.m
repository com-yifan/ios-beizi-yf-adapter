//
//  AMPSUnifiedNativeDetailViewController.m
//  AdScopeDemo
//
//  Created by nie adhub on 2025/3/28.
//

#import "AMPSUnifiedNativeDetailViewController.h"
#import <AMPSAdSDK/AMPSAdSDK.h>
#import <YYWebImage/YYWebImage.h>
#import "AdScopeDemoMacro.h"

@interface AMPSUnifiedNativeDetailViewController () <AMPSUnifiedNativeManagerDelegate,AMPSUnifiedNativeViewDelegate,AMPSMediaVideoViewDelegate>

@property (nonatomic, strong) AMPSUnifiedNativeManager *nativeManager;

@property (nonatomic, strong) NSMutableArray *arr;

@property (nonatomic, strong) NSMutableArray *viewArr;

@end

@implementation AMPSUnifiedNativeDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2 - 50, 400, 100, 30)];
    [btn setTitle:@"request" forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor blueColor];
    [btn addTarget:self action:@selector(tapClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    AMPSAdConfiguration *cfg = [[AMPSAdConfiguration alloc] init];
    cfg.adCount = 1;
    _nativeManager = [[AMPSUnifiedNativeManager alloc] initWithSpaceId:_spaceId adConfiguration:cfg];
    _nativeManager.delegate = self;
    _viewArr = [[NSMutableArray alloc] init];
    [self requestUnifiedAd];
}

- (void)tapClick {
    [self requestUnifiedAd];
}

- (void)requestUnifiedAd {
    for (int i=0; i<_viewArr.count; i++) {
        AMPSUnifiedNativeView *view = _viewArr[i];
        [view unregisterNativeAdDataObject];
        [_viewArr removeObjectAtIndex:i];
    }
    [self.nativeManager loadUnifiedNativeManager];
}

- (void)ampsNativeAdLoadSuccess:(AMPSUnifiedNativeManager *)nativeAd {
    
    CookieAMPSLog(@"代理回调：NativeAdLoadSuccess");
    for (AMPSAdLoadedInfo *info in nativeAd.failAdInfoList.copy) {
        CookieAMPSLog(@"失败渠道：%@，原因：%@",info.adapterClassName, info.errorMsg);
    }
    AMPSUnifiedNativeAd *ad = nativeAd.adArray[0];
    AMPSUnifiedNativeView *adView = [[AMPSUnifiedNativeView alloc] initWithFrame:CGRectMake(10, 50, self.view.frame.size.width - 20, 230)];
    adView.backgroundColor = [UIColor lightGrayColor];
    adView.viewController = self;
    [adView refreshData:ad];
    adView.delegate = self;
    if (ad.nativeMode == AMPSUnifiedNativeModeUnifiedVideo) {
        adView.mediaView.delegate = self;
        [adView.mediaView resetLayoutWithRect:CGRectMake(5, 5, adView.frame.size.width - 10, 150)];
    } else if (ad.imageUrls.count > 0) {
        for (int i = 0; i < ad.imageUrls.count; i++) {
            CGFloat width = (adView.frame.size.width - 10 * (ad.imageUrls.count - 1)) / ad.imageUrls.count;
            UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(10 + i * width, 10, width, 150)];
            imgView.contentMode = UIViewContentModeScaleAspectFit;
            [imgView yy_setImageWithURL:[NSURL URLWithString:ad.imageUrls[i]] placeholder:nil];
            [adView addSubview:imgView];
        }
    } else if (ad.imageUrl.length > 0) {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 10, self.view.frame.size.width, 150)];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [imageView yy_setImageWithURL:[NSURL URLWithString:ad.imageUrl] placeholder:nil];
        [adView addSubview:imageView];
    }
    adView.adLogoImageView.frame = CGRectMake(adView.frame.size.width - 50, 140, 36, 14);
    adView.adLogoImageView.contentMode = UIViewContentModeScaleAspectFit;
    if (ad.adLogoUrl.length > 0) {
        [adView.adLogoImageView yy_setImageWithURL:[NSURL URLWithString:ad.adLogoUrl] placeholder:nil];
    }
    UIImageView *iconImageView = [[UIImageView alloc] init];
    if (ad.iconUrl.length > 0) {
        iconImageView.frame = CGRectMake(5, 165, 65, 65);
        iconImageView.contentMode = UIViewContentModeScaleAspectFit;
        [iconImageView yy_setImageWithURL:[NSURL URLWithString:ad.iconUrl] placeholder:nil];
    }
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.frame = CGRectMake(iconImageView.frame.size.width + 10, 165, self.view.frame.size.width - 85, 30);
    titleLabel.text = ad.title;
    titleLabel.font = [UIFont systemFontOfSize:21.0];
    titleLabel.textColor = [UIColor darkGrayColor];
    
    UILabel *descLabel = [[UILabel alloc] init];
    descLabel.frame = CGRectMake(iconImageView.frame.size.width + 10, 200, self.view.frame.size.width - 85, 30);
    descLabel.text = ad.desc;
    descLabel.font = [UIFont systemFontOfSize:21.0];
    descLabel.textColor = [UIColor grayColor];
    [adView addSubview:iconImageView];
    [adView addSubview:titleLabel];
    [adView addSubview:descLabel];
    if (ad.imageUrls.count > 0) {
        [adView registerClickableViews:@[titleLabel,adView.adLogoImageView]];
    } else {
        [adView registerClickableViews:@[titleLabel,adView.adLogoImageView]];
    }
    [_viewArr addObject:adView];
    [self.view addSubview:adView];
}

- (void)ampsNativeAdLoadFail:(AMPSUnifiedNativeManager *)nativeAd error:(NSError *)error {
    CookieAMPSLog(@"------------%@",error);
}

- (void)ampsNativeAdExposured:(AMPSUnifiedNativeView *)nativeView {
    CookieAMPSLog(@"-----------ampsNativeAdExposured----%@",nativeView.nativeAd.class);
}

- (void)ampsNativeAdDidClick:(AMPSUnifiedNativeView *)nativeView {
    CookieAMPSLog(@"-----------ampsNativeAdDidClick");
}

- (void)ampsNativeAdDidCloseOtherController:(AMPSUnifiedNativeView *)nativeView {
    CookieAMPSLog(@"-----------ampsNativeAdDidCloseOtherController");
}

- (void)ampsMediaVideoViewDidPlay:(AMPSMediaView *)mediaView {
    CookieAMPSLog(@"-----------ampsMediaVideoViewDidPlay");
}

- (void)ampsMediaVideoViewDidPause:(AMPSMediaView *)mediaView {
    CookieAMPSLog(@"-----------ampsMediaVideoViewDidPause");
}

- (void)ampsMediaVideoViewDidFailedToPlay:(AMPSMediaView *)mediaView {
    CookieAMPSLog(@"-----------ampsMediaVideoViewDidFailedToPlay");
}

- (void)ampsMediaVideoViewDidFinishPlay:(AMPSMediaView *)mediaView {
    CookieAMPSLog(@"-----------ampsMediaVideoViewDidFinishPlay");
}

- (void)dealloc {
    for (int i=0; i<_viewArr.count; i++) {
        AMPSUnifiedNativeView *view = _viewArr[i];
        [view unregisterNativeAdDataObject];
        [_viewArr removeObjectAtIndex:i];
    }
    if (_nativeManager) {
        [_nativeManager removeUnifiedNativeManager];
        _nativeManager = nil;
    }
    CookieAMPSLog(@"AMPSUnifiedNativeDetailViewController dealloc");
}

@end
