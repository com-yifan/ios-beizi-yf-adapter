//
//  AMPSDrawAdViewController.m
//  AdScopeDemo
//
//  Created by nie adhub on 2024/12/10.
//

#import "AMPSDrawAdViewController.h"
#import <AdScopeFoundation/AdScopeFoundation.h>
#import <AMPSAdSDK/AMPSAdSDK.h>
#import "AdScopeDemoMacro.h"
#import "AdScopeDemoAnyControlTool.h"
#import "AdScopeDemoStatusObject.h"
#import "AdScopeDemoLogger.h"
#import "AMPSDrawAdListViewController.h"

@interface AMPSDrawAdViewController () <UITextFieldDelegate>

@property (nonatomic, strong) UILabel *resultsLabel;

@property (nonatomic, strong) UITextField *spaceIdTextField;

@end

@implementation AMPSDrawAdViewController

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
    
    self.spaceIdTextField = [AdScopeDemoAnyControlTool fastTextFieldWithFrame:CGRectMake(15, appIdTextField.adScopeFrameBottom+15, self.view.frame.size.width-30, 40) title:@"spaceId" placeholder:@"请输入spaceId"];
    self.spaceIdTextField.text = @"116122";
    self.spaceIdTextField.tag = 1;
    self.spaceIdTextField.delegate = self;
    if ([[NSUserDefaults standardUserDefaults] objectForKey:kAdScopeDemoAMPSSDKNativeID]) {
        self.spaceIdTextField.text = [[NSUserDefaults standardUserDefaults] objectForKey:kAdScopeDemoAMPSSDKNativeID];
    }
    [self.view addSubview:self.spaceIdTextField];
    
    self.resultsLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, self.spaceIdTextField.adScopeFrameBottom+15, self.view.frame.size.width-30, 30)];
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
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.hidden = NO;
}

- (void)requestBtnClick {
    [self.view endEditing:YES];
//    AMPSUnifiedNativeViewController *viewController = [[AMPSUnifiedNativeViewController alloc]init];

    AMPSDrawAdListViewController *viewController = [[AMPSDrawAdListViewController alloc]init];
    viewController.spaceId = self.spaceIdTextField.text;
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = touches.anyObject;
    if (![touch.view isKindOfClass:[UITextField class]]) {
        [self.view endEditing:YES];
    }
}

- (void)dealloc {
    CookieAMPSLog(@"ampsDrawAdViewController dealloc");
}

@end
