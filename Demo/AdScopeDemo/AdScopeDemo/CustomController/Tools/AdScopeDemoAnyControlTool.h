//
//  AdScopeDemoAnyControlTool.h
//  AdScopeDemo
//
//  Created by Cookie on 2023/6/7.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AdScopeDemoAnyControlTool : NSObject

+ (UITextField *)fastTextFieldWithFrame:(CGRect)frame
                                  title:(NSString *)title
                            placeholder:(NSString *)placeholder;

+ (void)showAlertWithVC:(UIViewController *)viewController
                message:(NSString *)message;

@end

NS_ASSUME_NONNULL_END
