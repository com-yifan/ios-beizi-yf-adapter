//
//  AdScopeDemoMacro.h
//  AdScopeDemo
//
//  Created by Cookie on 2022/11/2.
//

#ifndef AdScopeDemoMacro_h
#define AdScopeDemoMacro_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AdScopeDemoLogger.h"

#define CookieCycle(format, ...) printf( "CookieCycles:[%f] %s %s (%d行)\n", [[NSDate date]timeIntervalSince1970], [[NSString stringWithFormat:(format), ##__VA_ARGS__] UTF8String], __PRETTY_FUNCTION__,  __LINE__  )
#define CookieADNLog(format, ...) printf( "CookieADNLog:[%f] %s %s (%d行)\n", [[NSDate date]timeIntervalSince1970], [[NSString stringWithFormat:(format), ##__VA_ARGS__] UTF8String], __PRETTY_FUNCTION__,  __LINE__ )

#define CookieAMPSLog(format, ...) \
({if (@available(iOS 11.0, *)) {\
printf( "CookieAMPSLog:[%f] %s %s (%d行)\n", [[NSDate date]timeIntervalSince1970], [[NSString stringWithFormat:(format), ##__VA_ARGS__] UTF8String], __PRETTY_FUNCTION__,  __LINE__ );\
NSString *log = [NSString stringWithFormat:@"%@", [NSString stringWithFormat:(format), ##__VA_ARGS__]];\
[AdScopeDemoLogger log:log];\
}\
})

#define kAdScopeLaunchInitAndRequestSplash @"AdScopeLaunchInitAndRequestSplash"
#define kAdScopeASMSAdSDKAppId @"AdScopeASMSAdSDKAppId"
#define AdScopeASNPNowEnvironment @"AdScopeASNPNowEnvironment"

#define ADSCOPEDEMO_IPHONE_X \
({BOOL isPhoneX = NO;\
if (@available(iOS 11.0, *)) {\
isPhoneX = [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.0;\
}\
(isPhoneX);})

#define kAdScopeDemoStatusBarHeight (CGFloat)(ADSCOPEDEMO_IPHONE_X ? 44.0 : 20.0)
#define kAdScopeDemoSafeAreaBottomHeight (CGFloat)(ADSCOPEDEMO_IPHONE_X ? 34.0 : 22.0)
#define kAdScopeDemoSafeAreaTopHeight (CGFloat)(ADSCOPEDEMO_IPHONE_X ? 44.0 : 22.0)

#define kAdScopeDemoNavHeight \
({CGFloat navHeight = 0.0f;\
if (@available(iOS 13.0, *)) {\
    NSSet *set = [UIApplication sharedApplication].connectedScenes;\
    UIWindowScene *windowScene = [set anyObject];\
    UIWindow *window = windowScene.windows.firstObject;\
    navHeight = window.safeAreaInsets.top + 44.0f;\
} else if (@available(iOS 11.0, *)) {\
    UIWindow *window = [UIApplication sharedApplication].windows.firstObject;\
    navHeight = window.safeAreaInsets.top + 44.0f;\
}\
(navHeight);})

#define kAdScopeDemoTabbarHeight (CGFloat)(ADSCOPEDEMO_IPHONE_X ? 80.0 : 49.0)

#endif /* AdScopeDemoMacro_h */
