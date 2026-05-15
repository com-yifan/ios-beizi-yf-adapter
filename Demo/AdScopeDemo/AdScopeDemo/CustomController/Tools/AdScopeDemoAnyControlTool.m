//
//  AdScopeDemoAnyControlTool.m
//  AdScopeDemo
//
//  Created by Cookie on 2023/6/7.
//

#import "AdScopeDemoAnyControlTool.h"
#import <AdScopeFoundation/AdScopeFoundation.h>
#import "AdScopeDemoMacro.h"

@implementation AdScopeDemoAnyControlTool

+ (UITextField *)fastTextFieldWithFrame:(CGRect)frame
                                  title:(NSString *)title
                            placeholder:(NSString *)placeholder {
    UILabel *controlLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width - 60, 20)];
    controlLabel.textAlignment = NSTextAlignmentLeft;
    controlLabel.text = [NSString stringWithFormat:@"  %@：", title];
    controlLabel.textColor = [UIColor adScopeColorWithHexString:@"#000000"];
    UITextField *controlTextField = [[UITextField alloc]initWithFrame:frame];
    controlTextField.backgroundColor = [UIColor adScopeColorWithHexString:@"#FFFFFF"];
    controlTextField.textColor = [UIColor adScopeColorWithHexString:@"#000000"];
    controlTextField.textAlignment = NSTextAlignmentLeft;
    controlTextField.keyboardType = UIKeyboardTypeASCIICapable;
    controlTextField.attributedPlaceholder = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"  请输入%@", placeholder] attributes:@{NSForegroundColorAttributeName : [UIColor adScopeColorWithHexString:@"#CCCCCC"]}];
    controlTextField.leftView = controlLabel;
    controlTextField.leftViewMode = UITextFieldViewModeAlways;
    controlTextField.layer.masksToBounds = YES;
    controlTextField.layer.borderWidth = 1;
    controlTextField.layer.borderColor = [UIColor adScopeColorWithHexString:@"999999"].CGColor;
    controlTextField.layer.cornerRadius = 3;
    return controlTextField;
}

+ (void)showAlertWithVC:(UIViewController *)viewController
                message:(NSString *)message {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:message message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [viewController presentViewController:alertController animated:YES completion:nil];
}

@end
