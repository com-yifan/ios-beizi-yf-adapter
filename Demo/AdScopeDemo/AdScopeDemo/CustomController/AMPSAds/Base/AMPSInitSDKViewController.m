//
//  AMPSInitSDKViewController.m
//  AdScopeDemo
//
//  Created by Cookie on 2023/6/7.
//

#import "AMPSInitSDKViewController.h"
#import "UIViewController+AdScopeCookieExtension.h"
#import <AdScopeFoundation/AdScopeFoundation.h>
#import <AMPSAdSDK/AMPSAdSDK.h>
#import "AdScopeDemoStatusObject.h"
#import "AdScopeDemoMacro.h"
#import "AdScopeProgressHUD.h"

@interface AMPSInitSDKViewController () <UITextFieldDelegate>

@property (nonatomic, strong) AdScopeProgressHUD *loadHud;

@property (nonatomic, strong) UILabel *resultsLabel;

@end

@implementation AMPSInitSDKViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UILabel *appIdLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width - 60, 20)];
    appIdLabel.textAlignment = NSTextAlignmentLeft;
    appIdLabel.text = @"  appId：";
    appIdLabel.textColor = [UIColor adScopeColorWithHexString:@"#000000"];
    UITextField *appIdTextField = [[UITextField alloc]initWithFrame:CGRectMake(15, kAdScopeDemoNavHeight+15, self.view.frame.size.width-30, 40)];
    appIdTextField.delegate = self;
    appIdTextField.tag = 1;
    appIdTextField.backgroundColor = [UIColor adScopeColorWithHexString:@"#FFFFFF"];
    appIdTextField.textColor = [UIColor adScopeColorWithHexString:@"#000000"];
    appIdTextField.textAlignment = NSTextAlignmentLeft;
    appIdTextField.text = @"59123";
    kAdScopeDemoAMPSInitSDKAPPID = appIdTextField.text;
    appIdTextField.keyboardType = UIKeyboardTypeDecimalPad;
    appIdTextField.attributedPlaceholder = [[NSMutableAttributedString alloc]initWithString:@"请输入appId" attributes:@{NSForegroundColorAttributeName : [UIColor adScopeColorWithHexString:@"#CCCCCC"]}];
    appIdTextField.leftView = appIdLabel;
    appIdTextField.leftViewMode = UITextFieldViewModeAlways;
    appIdTextField.layer.masksToBounds = YES;
    appIdTextField.layer.borderWidth = 1;
    appIdTextField.layer.borderColor = [UIColor adScopeColorWithHexString:@"999999"].CGColor;
    appIdTextField.layer.cornerRadius = 3;
    [self.view addSubview:appIdTextField];
    
    self.resultsLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, appIdTextField.adScopeFrameBottom + 15, self.view.frame.size.width-30, 30)];
    self.resultsLabel.textColor = [UIColor redColor];
    self.resultsLabel.text = @"确保初始化成功后在退出此页面";
    self.resultsLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.resultsLabel];
    
    UIButton *initializeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [initializeBtn setTitleColor:[UIColor adScopeColorWithHexString:@"#000000"] forState:UIControlStateNormal];
    [initializeBtn setTitle:@"初始化SDK" forState:UIControlStateNormal];
    initializeBtn.frame = CGRectMake(15, self.resultsLabel.adScopeFrameBottom + 15, self.view.frame.size.width-30, 40);
    initializeBtn.layer.masksToBounds = YES;
    initializeBtn.layer.borderWidth = 1;
    initializeBtn.layer.borderColor = [UIColor adScopeColorWithHexString:@"999999"].CGColor;
    initializeBtn.layer.cornerRadius = 3;
    [initializeBtn addTarget:self action:@selector(initializeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:initializeBtn];
}

- (void)initializeBtnClick {
    [self.view endEditing:YES];
    if (kAdScopeDemoAMPSInitSDKAPPID.length == 0) {
        self.resultsLabel.text = @"请输入appId后在进行初始化";
        return;
    }
    [self startLoadHud];
    [AMPSAdSDKManager sharedInstance].sdkConfiguration.adapterName = @[kAMPSAdapterSDKManagerNameBZ];
    uint64_t now = [[AdScopeDeviceInfo sharedInstance]adScopeMTimeStamp];
    AMPSAdSDKConfiguration *config = [[AMPSAdSDKConfiguration alloc] init];
    config.customExtraDict = @{@"fg":@{@"clientSecret":@"2a27042c9649b9f618630cfba1bb0c28"},@"ptg":@{@"clientSecret":@"MlsVg73dqWE8mqbg"}};
    [AMPSAdSDKManager sharedInstance].sdkConfiguration.customExtraDict = config.customExtraDict;
    [[AMPSAdSDKManager sharedInstance]startAsyncWithAppId:kAdScopeDemoAMPSInitSDKAPPID results:^(AMPSAdSDKInitStatus statusResult) {
        uint64_t end = [[AdScopeDeviceInfo sharedInstance]adScopeMTimeStamp]-now;
        NSString *resultsMessage = @"";
        if (statusResult == kAMPSAdSDKInitStatusSuccess) {
            resultsMessage = [NSString stringWithFormat:@"初始化成功，耗时：%llu", end];
        } else {
            resultsMessage = [NSString stringWithFormat:@"初始化失败，耗时：%llu", end];
        }
        adscope_back_main_queue_safe(^{
            self.resultsLabel.text = resultsMessage;
            [self.loadHud hideAnimated:YES];
        });
    }];
}

- (void)startLoadHud {
    self.loadHud = [AdScopeProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    self.loadHud.contentColor = [UIColor adScopeColorWithHexString:@"FFFFFF"];
    self.loadHud.backgroundView.color = [UIColor adScopeColorWithHexString:@"99999999"];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    kAdScopeDemoAMPSInitSDKAPPID = textField.text;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = touches.anyObject;
    if (![touch.view isKindOfClass:[UITextField class]]) {
        [self.view endEditing:YES];
    }
}

@end
