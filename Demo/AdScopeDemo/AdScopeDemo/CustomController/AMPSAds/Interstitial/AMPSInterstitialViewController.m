//
//  AMPSInterstitialViewController.m
//  AdScopeDemo
//
//  Created by Cookie on 2023/5/29.
//

#import "AMPSInterstitialViewController.h"
#import <AdScopeFoundation/AdScopeFoundation.h>
#import <AMPSAdSDK/AMPSAdSDK.h>
#import "AdScopeDemoMacro.h"
#import "AdScopeDemoAnyControlTool.h"
#import "AdScopeDemoStatusObject.h"
#import "AdScopeDemoLogger.h"

@interface AMPSInterstitialViewController () <UITextFieldDelegate, AMPSInterstitialAdDelegate>

@property (nonatomic, strong) AMPSInterstitialAd *interstitialAd;

@property (nonatomic, strong) UILabel *resultsLabel;

@property (nonatomic, copy) NSString *spaceId;

@property (nonatomic, assign) uint64_t nowTime;

@end

@implementation AMPSInterstitialViewController

- (void)requestBtnClick {
    [self.view endEditing:YES];
    if (ADSCOPE_STRING_EMPTY(self.spaceId)) {
        return;
    }
    self.resultsLabel.text = @"广告请求中";
    self.nowTime = [[AdScopeDeviceInfo sharedInstance]adScopeMTimeStamp];
    [self.interstitialAd loadInterstitialAd];
}

- (void)isReadyBtnClick {
    [self.view endEditing:YES];
    NSString *message = @"广告未准备好";
    if (ADSCOPE_STRING_EMPTY(self.spaceId)) {
        message = @"请先输入广告位ID";
    } else if ([self.interstitialAd isReadyAd]) {
        message = @"广告已准备好";
    }
    [AdScopeDemoAnyControlTool showAlertWithVC:self message:message];
}

- (void)showBtnClick {
    [self.view endEditing:YES];
    if (ADSCOPE_STRING_EMPTY(self.spaceId)) {
        return;
    }
    [self.interstitialAd showInterstitialAdWithRootViewController:self];
}

- (void)preloadBtnClick {
    [self.view endEditing:YES];
    if (ADSCOPE_STRING_EMPTY(self.spaceId)) {
        return;
    }
    [self.interstitialAd preloadAd];
}

- (void)ampsInterstitialAdLoadSuccess:(AMPSInterstitialAd *)interstitialAd {
    CookieAMPSLog(@"代理回调：InterstitialAdLoadSuccess");
    self.resultsLabel.text = [NSString stringWithFormat:@"广告请求成功，耗时:%llu", [[AdScopeDeviceInfo sharedInstance]adScopeMTimeStamp]-self.nowTime];
    CookieAMPSLog(@"成功渠道：%@，价格：%ld", self.interstitialAd.successAdInfo.adapterClassName, (long)[self.interstitialAd eCPM]);
    for (AMPSAdLoadedInfo *info in self.interstitialAd.failAdInfoList.copy) {
        CookieAMPSLog(@"失败渠道：%@，原因：%@",info.adapterClassName, info.errorMsg);
    }
}

- (void)ampsInterstitialAdLoadFail:(AMPSInterstitialAd *)interstitialAd
                             error:(NSError *_Nullable)error {
    self.resultsLabel.text = [NSString stringWithFormat:@"广告请求失败，耗时:%llu", [[AdScopeDeviceInfo sharedInstance]adScopeMTimeStamp]-self.nowTime];
    CookieAMPSLog(@"代理回调：InterstitialAdLoadFail:%@", error);
    for (AMPSAdLoadedInfo *info in self.interstitialAd.failAdInfoList.copy) {
        CookieAMPSLog(@"失败渠道：%@，原因：%@",info.adapterClassName, info.errorMsg);
    }
}

- (void)ampsInterstitialAdDidShow:(AMPSInterstitialAd *)interstitialAd {
    CookieAMPSLog(@"代理回调：InterstitialAdDidShow");
}

- (void)ampsInterstitialAdDidClick:(AMPSInterstitialAd *)interstitialAd {
    CookieAMPSLog(@"代理回调：ampsInterstitialAdDidClick");
}

- (void)ampsInterstitialAdDidClose:(AMPSInterstitialAd *)interstitialAd {
    CookieAMPSLog(@"代理回调：InterstitialAdDidClose");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view = self.scrollView;
    
    self.view.backgroundColor = [UIColor whiteColor];
    UITextField *appIdTextField = [AdScopeDemoAnyControlTool fastTextFieldWithFrame:CGRectMake(15, 15, self.view.frame.size.width-30, 40) title:@"当前初始化的appId" placeholder:@"appId"];
    if (kAdScopeDemoAMPSInitSDKAPPID.length == 0) {
        appIdTextField.text = @"请先进行初始化";
    } else {
        appIdTextField.text = kAdScopeDemoAMPSInitSDKAPPID;
    }
    appIdTextField.enabled = NO;
    [self.view addSubview:appIdTextField];
    
    UITextField *spaceIdTextField = [AdScopeDemoAnyControlTool fastTextFieldWithFrame:CGRectMake(15, appIdTextField.adScopeFrameBottom+15, self.view.frame.size.width-30, 40) title:@"spaceId" placeholder:@"请输入spaceId"];
    spaceIdTextField.tag = 1;
    spaceIdTextField.text = @"139136";
    self.spaceId = spaceIdTextField.text;
    spaceIdTextField.delegate = self;
    if ([[NSUserDefaults standardUserDefaults] objectForKey:kAdScopeDemoAMPSSDKInterstitialID]) {
        self.spaceId = [[NSUserDefaults standardUserDefaults] objectForKey:kAdScopeDemoAMPSSDKInterstitialID];
        spaceIdTextField.text = self.spaceId;
    }
    [self.view addSubview:spaceIdTextField];
    
    self.resultsLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, spaceIdTextField.adScopeFrameBottom+15, self.view.frame.size.width-30, 30)];
    self.resultsLabel.textColor = [UIColor redColor];
    self.resultsLabel.text = @"确保初始化完成后在请求广告";
    self.resultsLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.resultsLabel];
    
    if (ADSCOPE_STRING_EMPTY(kAdScopeDemoAMPSInitSDKAPPID)) {
        return;
    }
    
    UIButton *requestBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [requestBtn setTitleColor:[UIColor adScopeColorWithHexString:@"#000000"] forState:UIControlStateNormal];
    [requestBtn setTitle:@"请求广告" forState:UIControlStateNormal];
    requestBtn.frame = CGRectMake(15, self.resultsLabel.adScopeFrameBottom + 15, self.view.frame.size.width-30, 40);
    requestBtn.layer.masksToBounds = YES;
    requestBtn.layer.borderWidth = 1;
    requestBtn.layer.borderColor = [UIColor adScopeColorWithHexString:@"999999"].CGColor;
    requestBtn.layer.cornerRadius = 3;
    [requestBtn addTarget:self action:@selector(requestBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:requestBtn];
    
    UIButton *isReadyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [isReadyBtn setTitleColor:[UIColor adScopeColorWithHexString:@"#000000"] forState:UIControlStateNormal];
    [isReadyBtn setTitle:@"广告是否Ready" forState:UIControlStateNormal];
    isReadyBtn.frame = CGRectMake(15, requestBtn.adScopeFrameBottom + 15, self.view.frame.size.width-30, 40);
    isReadyBtn.layer.masksToBounds = YES;
    isReadyBtn.layer.borderWidth = 1;
    isReadyBtn.layer.borderColor = [UIColor adScopeColorWithHexString:@"999999"].CGColor;
    isReadyBtn.layer.cornerRadius = 3;
    [isReadyBtn addTarget:self action:@selector(isReadyBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:isReadyBtn];
    
    UIButton *showBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [showBtn setTitleColor:[UIColor adScopeColorWithHexString:@"#000000"] forState:UIControlStateNormal];
    [showBtn setTitle:@"显示广告" forState:UIControlStateNormal];
    showBtn.frame = CGRectMake(15, isReadyBtn.adScopeFrameBottom + 15, self.view.frame.size.width-30, 40);
    showBtn.layer.masksToBounds = YES;
    showBtn.layer.borderWidth = 1;
    showBtn.layer.borderColor = [UIColor adScopeColorWithHexString:@"999999"].CGColor;
    showBtn.layer.cornerRadius = 3;
    [showBtn addTarget:self action:@selector(showBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:showBtn];
    
    UIButton *preloadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [preloadBtn setTitleColor:[UIColor adScopeColorWithHexString:@"#000000"] forState:UIControlStateNormal];
    [preloadBtn setTitle:@"预加载广告" forState:UIControlStateNormal];
    preloadBtn.frame = CGRectMake(15, showBtn.adScopeFrameBottom + 15, self.view.frame.size.width-30, 40);
    preloadBtn.layer.masksToBounds = YES;
    preloadBtn.layer.borderWidth = 1;
    preloadBtn.layer.borderColor = [UIColor adScopeColorWithHexString:@"999999"].CGColor;
    preloadBtn.layer.cornerRadius = 3;
    [preloadBtn addTarget:self action:@selector(preloadBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:preloadBtn];
    
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, preloadBtn.adScopeFrameBottom+15);
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.spaceId = textField.text;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = touches.anyObject;
    if (![touch.view isKindOfClass:[UITextField class]]) {
        [self.view endEditing:YES];
    }
}

- (AMPSInterstitialAd *)interstitialAd {
    if (!_interstitialAd) {
        _interstitialAd = [[AMPSInterstitialAd alloc]initWithSpaceId:self.spaceId adConfiguration:[AMPSAdConfiguration new]];
        _interstitialAd.delegate = self;
    }
    return _interstitialAd;
}

- (void)dealloc {
    if (_interstitialAd) {
        [_interstitialAd removeInterstitialAd];
        _interstitialAd = nil;
    }
}

@end
