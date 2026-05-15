//
//  AdScopeDemoUITests.m
//  AdScopeDemoUITests
//
//  Created by Cookie on 2022/2/7.
//

#import <XCTest/XCTest.h>

@interface AdScopeDemoUITests : XCTestCase

@property (nonatomic, assign) int count;

@end

@implementation AdScopeDemoUITests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.

    // In UI tests it is usually best to stop immediately when a failure occurs.
    self.continueAfterFailure = NO;
    // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
//    [self testAllAd];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testExample {
    for ( ; self.count < 100000; self.count++) {
        [[[XCUIApplication alloc] init] launch];
        XCUIApplication *app = [[XCUIApplication alloc] init];
        [app.tables.staticTexts[@"UITest测试"] tap];
        if ((self.count % 2) == 0) {
            [self showSplashAd:app];
        } else {
            [self showNativeAd:app];
        }
    }
}

- (void)testLaunchPerformance {
    if (@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *)) {
        // This measures how long it takes to launch your application.
        [self measureWithMetrics:@[[[XCTApplicationLaunchMetric alloc] init]] block:^{
            for ( ; self.count < 100000; self.count++) {
                [[[XCUIApplication alloc] init] launch];
                XCUIApplication *app = [[XCUIApplication alloc] init];
                [app.tables.staticTexts[@"UITest测试"] tap];
                if ((self.count % 2) == 0) {
                    [self showSplashAd:app];
                } else {
                    [self showNativeAd:app];
                }
            }
        }];
    }
}

- (void)showNativeAd:(XCUIApplication *)app {
    sleep(5);
    for (int i = 0; i < 5; i++) {
        if (i == 4) {
            if ((self.count/2) % 2 == 0) {
                if (app.tables.staticTexts[@"国内原生"].exists) {
                    [app.tables.staticTexts[@"国内原生"] tap];
                }
                sleep(6);
                if ([[[[[[[[[[[[[[app.windows childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther] elementBoundByIndex:0] childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther].element.exists) {
                    [[[[[[[[[[[[[[[app.windows childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther] elementBoundByIndex:0] childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther].element tap];;
                }
                sleep(5);
            } else {
                if (app.tables.staticTexts[@"海外原生"].exists) {
                    [app.tables.staticTexts[@"海外原生"] tap];
                }
                sleep(6);
                if (app.buttons[@"VISIT SITE"].exists) {
                    [app.buttons[@"VISIT SITE"] tap];
                }
                sleep(5);
            }
        } else if (i < 2) {
            if (app.tables.staticTexts[@"国内原生"].exists) {
                [app.tables.staticTexts[@"国内原生"] tap];
            }
            sleep(5);
            if (app.navigationBars[@"ASNP测试"].buttons[@"Back"].exists) {
                [app.navigationBars[@"ASNP测试"].buttons[@"Back"] tap];
            }
            sleep(3);
        } else {
            if (app.tables.staticTexts[@"海外原生"].exists) {
                [app.tables.staticTexts[@"海外原生"] tap];
            }
            sleep(5);
            if (app.navigationBars[@"ASNP测试"].buttons[@"Back"].exists) {
                [app.navigationBars[@"ASNP测试"].buttons[@"Back"] tap];
            }
            sleep(3);
        }
    }
}

- (void)testAllAd {
    for ( ; self.count < 100000; self.count++) {
        [[[XCUIApplication alloc] init] launch];
        XCUIApplication *app = [[XCUIApplication alloc] init];
        [app.tables.staticTexts[@"UITest测试"] tap];
        if ((self.count % 2) == 0) {
            [self showSplashAd:app];
        } else {
            [self showNativeAd:app];
        }
    }
}

- (void)showSplashAd:(XCUIApplication *)app {
    sleep(5);
    for (int i = 0; i < 5; i++) {
        if (i == 4) {
            if ((self.count/2) % 2 == 0) {
                if (app.tables.staticTexts[@"国内开屏"].exists) {
                    [app.tables.staticTexts[@"国内开屏"] tap];
                }
                sleep(3);
                if (app.buttons[@"点击跳转网页或第三方应用"].exists) {
                    [app.buttons[@"点击跳转网页或第三方应用"] tap];
                }
                sleep(5);
            } else {
                if (app.tables.staticTexts[@"海外开屏"].exists) {
                    [app.tables.staticTexts[@"海外开屏"] tap];
                }
                sleep(3);
                if (app.buttons[@"GET"].exists) {
                    [app.buttons[@"GET"] tap];
                }
                sleep(5);
            }
        } else if (i < 2) {
            if (app.tables.staticTexts[@"国内开屏"].exists) {
                [app.tables.staticTexts[@"国内开屏"] tap];
            }
            sleep(10);
            if (app.navigationBars[@"ASNP测试"].buttons[@"Back"].exists) {
                [app.navigationBars[@"ASNP测试"].buttons[@"Back"] tap];
            }
            sleep(2);
        } else {
            if (app.tables.staticTexts[@"海外开屏"].exists) {
                [app.tables.staticTexts[@"海外开屏"] tap];
            }
            sleep(8);
            if (app.staticTexts[@"Continue to app"].exists) {
                [app.staticTexts[@"Continue to app"] tap];
            }
            sleep(2);
            if (app.navigationBars[@"ASNP测试"].buttons[@"Back"].exists) {
                [app.navigationBars[@"ASNP测试"].buttons[@"Back"] tap];
            }
            sleep(2);
        }
    }
}

- (void)testSplashAd {
    for (int i = 0; i < 10000; i++) {
        [[[XCUIApplication alloc] init] launch];
        XCUIApplication *app = [[XCUIApplication alloc] init];
        [app.tables.staticTexts[@"开屏广告"] tap];
        sleep(10);
        for (int i = 0; i < 4; i++) {
            [app.staticTexts[@"请求海外"] tap];
            sleep(5);
            XCUIElement *staticText = app.staticTexts[@"显示广告"];
            [staticText tap];
            sleep(5);
            if (i == 3) {
                XCUIElement *clickBtn = app.buttons[@"GET"];
                if (clickBtn.exists) {
                    [clickBtn tap];
                }
                sleep(5);
            } else {
                XCUIElement *closeBtn = app.staticTexts[@"Continue to app"];
                if (closeBtn.exists) {
                    [closeBtn tap];
                }
                sleep(10);
            }
        }
    }
}

- (void)testNativeAd {
    for (int i = 0; i < 10000; i++) {
        [[[XCUIApplication alloc] init] launch];
        XCUIApplication *app = [[XCUIApplication alloc] init];
        XCUIElement *pushBtn = app.tables.staticTexts[@"原生模版广告"];
        if (pushBtn.exists) {
            [pushBtn tap];
        }
        sleep(2);
        for (int i = 0; i < 20; i++) {
            XCUIElement *testBtn = app.staticTexts[@"海外脚本"];
            if (testBtn.exists) {
                [testBtn tap];
            }
            sleep(5);
            if (i == 19) {
                XCUIElement *clickBtn = app.buttons[@"VISIT SITE"];
                if (clickBtn.exists) {
                    [clickBtn tap];
                }
                sleep(5);
            } else {
                XCUIElement *backBtn = app.navigationBars[@"ASNP测试"].buttons[@"Back"];
                if (backBtn.exists) {
                    [backBtn tap];
                }
                sleep(2);
            }
        }
    }
}

- (void)testAMPSSplashAd {
    for (int i = 0; i < 10000; i++) {
        [[[XCUIApplication alloc] init] launch];
        XCUIApplication *app = [[XCUIApplication alloc] init];
        sleep(3);
        if (app.tabBars[@"Tab Bar"].buttons[@"AMPS测试"].exists) {
            [app.tabBars[@"Tab Bar"].buttons[@"AMPS测试"] tap];
        }
        sleep(3);
        if (app.tables.cells.staticTexts[@"UITest测试"].exists) {
            [app.tables.cells.staticTexts[@"UITest测试"] tap];
        }
        sleep(3);
        for (int j = 0; j < 20; j++) {
            if (app.tables.cells.staticTexts[@"聚合开屏"].exists) {
                [app.tables.cells.staticTexts[@"聚合开屏"] tap];
            }
            sleep(15);
            if (app.navigationBars[@"AMPS测试"].buttons[@"Back"].exists) {
                [app.navigationBars[@"AMPS测试"].buttons[@"Back"] tap];
            }
            sleep(5);
        }
    }
}

- (void)testAMPSCrash {
    for (int i = 0; i < 10000; i++) {
        [[[XCUIApplication alloc] init] launch];
        sleep(5);
    }
}

@end
