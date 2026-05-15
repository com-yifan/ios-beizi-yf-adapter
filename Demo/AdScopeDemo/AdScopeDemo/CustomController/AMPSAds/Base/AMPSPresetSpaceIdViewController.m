//
//  AMPSPresetSpaceIdViewController.m
//  AdScopeDemo
//
//  Created by Cookie on 2023/6/13.
//

#import "AMPSPresetSpaceIdViewController.h"
#import "AdScopeDemoMacro.h"
#import "AdScopeDemoAnyControlTool.h"
#import "AdScopeDemoStatusObject.h"
#import <AdScopeFoundation/AdScopeFoundation.h>

@interface AMPSPresetSpaceIdViewController () <UITextFieldDelegate>

@end

@implementation AMPSPresetSpaceIdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view = self.scrollView;
    
    self.view.backgroundColor = [UIColor whiteColor];
    UITextField *splashTextField = [AdScopeDemoAnyControlTool fastTextFieldWithFrame:CGRectMake(15, 15, self.view.frame.size.width-30, 40) title:@"开屏" placeholder:@"spaceId"];
    splashTextField.tag = 1;
    splashTextField.delegate = self;
    if ([[NSUserDefaults standardUserDefaults] objectForKey:kAdScopeDemoAMPSSDKSplashID]) {
        splashTextField.text = [[NSUserDefaults standardUserDefaults] objectForKey:kAdScopeDemoAMPSSDKSplashID];
    }
    [self.view addSubview:splashTextField];
    
    UITextField *nativeTextField = [AdScopeDemoAnyControlTool fastTextFieldWithFrame:CGRectMake(15, splashTextField.adScopeFrameBottom+15, self.view.frame.size.width-30, 40) title:@"原生" placeholder:@"spaceId"];
    nativeTextField.tag = 2;
    nativeTextField.delegate = self;
    if ([[NSUserDefaults standardUserDefaults] objectForKey:kAdScopeDemoAMPSSDKNativeID]) {
        nativeTextField.text = [[NSUserDefaults standardUserDefaults] objectForKey:kAdScopeDemoAMPSSDKNativeID];
    }
    [self.view addSubview:nativeTextField];
    
    UITextField *videoTextField = [AdScopeDemoAnyControlTool fastTextFieldWithFrame:CGRectMake(15, nativeTextField.adScopeFrameBottom+15, self.view.frame.size.width-30, 40) title:@"激励视频" placeholder:@"spaceId"];
    videoTextField.tag = 3;
    videoTextField.delegate = self;
    if ([[NSUserDefaults standardUserDefaults] objectForKey:kAdScopeDemoAMPSSDKRewardedVideoID]) {
        videoTextField.text = [[NSUserDefaults standardUserDefaults] objectForKey:kAdScopeDemoAMPSSDKRewardedVideoID];
    }
    [self.view addSubview:videoTextField];

    UITextField *interstitialTextField = [AdScopeDemoAnyControlTool fastTextFieldWithFrame:CGRectMake(15, videoTextField.adScopeFrameBottom+15, self.view.frame.size.width-30, 40) title:@"插屏" placeholder:@"spaceId"];
    interstitialTextField.tag = 4;
    interstitialTextField.delegate = self;
    if ([[NSUserDefaults standardUserDefaults] objectForKey:kAdScopeDemoAMPSSDKInterstitialID]) {
        interstitialTextField.text = [[NSUserDefaults standardUserDefaults] objectForKey:kAdScopeDemoAMPSSDKInterstitialID];
    }
    [self.view addSubview:interstitialTextField];
    
    UITextField *bannerextField = [AdScopeDemoAnyControlTool fastTextFieldWithFrame:CGRectMake(15, interstitialTextField.adScopeFrameBottom+15, self.view.frame.size.width-30, 40) title:@"横幅" placeholder:@"spaceId"];
    bannerextField.tag = 5;
    bannerextField.delegate = self;
    if ([[NSUserDefaults standardUserDefaults] objectForKey:kAdScopeDemoAMPSSDKBannerID]) {
        bannerextField.text = [[NSUserDefaults standardUserDefaults] objectForKey:kAdScopeDemoAMPSSDKBannerID];
    }
    [self.view addSubview:bannerextField];
    
    UIButton *removeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [removeBtn setTitleColor:[UIColor adScopeColorWithHexString:@"#000000"] forState:UIControlStateNormal];
    [removeBtn setTitle:@"清空预设广告位ID" forState:UIControlStateNormal];
    removeBtn.frame = CGRectMake(15, bannerextField.adScopeFrameBottom + 15, self.view.frame.size.width-30, 40);
    removeBtn.layer.masksToBounds = YES;
    removeBtn.layer.borderWidth = 1;
    removeBtn.layer.borderColor = [UIColor adScopeColorWithHexString:@"999999"].CGColor;
    removeBtn.layer.cornerRadius = 3;
    [removeBtn addTarget:self action:@selector(removeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:removeBtn];
    
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, removeBtn.adScopeFrameBottom+15);
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.view endEditing:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField.text.length == 0) {
        return;
    }
    if (textField.tag == 1) {
        [[NSUserDefaults standardUserDefaults] setValue:textField.text forKey:kAdScopeDemoAMPSSDKSplashID];
    } else if (textField.tag == 2) {
        [[NSUserDefaults standardUserDefaults] setValue:textField.text forKey:kAdScopeDemoAMPSSDKNativeID];
    } else if (textField.tag == 3) {
        [[NSUserDefaults standardUserDefaults] setValue:textField.text forKey:kAdScopeDemoAMPSSDKRewardedVideoID];
    } else if (textField.tag == 4) {
        [[NSUserDefaults standardUserDefaults] setValue:textField.text forKey:kAdScopeDemoAMPSSDKInterstitialID];
    } else if (textField.tag == 5) {
        [[NSUserDefaults standardUserDefaults] setValue:textField.text forKey:kAdScopeDemoAMPSSDKBannerID];
    } else {
        
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = touches.anyObject;
    if (![touch.view isKindOfClass:[UITextField class]]) {
        [self.view endEditing:YES];
    }
}

- (void)removeBtnClick {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kAdScopeDemoAMPSSDKSplashID];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kAdScopeDemoAMPSSDKNativeID];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kAdScopeDemoAMPSSDKRewardedVideoID];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kAdScopeDemoAMPSSDKInterstitialID];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kAdScopeDemoAMPSSDKBannerID];
}

@end
