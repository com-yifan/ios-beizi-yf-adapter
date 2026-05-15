//
//  UIViewController+AdScopeCookieExtension.m
//  AdScopeDemo
//
//  Created by Cookie on 2023/3/10.
//

#import "UIViewController+AdScopeCookieExtension.h"
#import <AdScopeFoundation/AdScopeFoundation.h>
#import "AdScopeDemoStatusObject.h"
#import "AdScopeDemoMacro.h"

@implementation UIViewController (AdScopeCookieExtension)

- (void)changeNavtiveItemTitle {
    NSString *changeClass = @"AdScopeADNStringResources";
    if ([[NSUserDefaults standardUserDefaults]boolForKey:AdScopeASNPNowEnvironment]) {
        [changeClass adScope_invokeClassMethod:@"adscope_adn_change_configure_development"];
        self.navigationItem.title = @"测试环境";
    } else {
        [changeClass adScope_invokeClassMethod:@"adscope_adn_change_configure_online"];
        self.navigationItem.title = @"正式环境";
    }
}

@end
