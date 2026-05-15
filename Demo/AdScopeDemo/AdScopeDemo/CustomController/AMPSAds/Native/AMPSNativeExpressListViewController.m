//
//  AMPSNativeExpressListViewController.m
//  AdScopeDemo
//
//  Created by Cookie on 2023/6/11.
//

#import "AMPSNativeExpressListViewController.h"
#import <AdScopeFoundation/AdScopeFoundation.h>
#import <AMPSAdSDK/AMPSAdSDK.h>
#import "AdScopeDemoMacro.h"
#import "AdScopeDemoAnyControlTool.h"
#import "AdScopeDemoStatusObject.h"
#import "AdScopeDemoLogger.h"
#import "AdScopeProgressHUD.h"
#import "ASNPNavtiveExpressTableViewCell.h"
#import "ASNPPlaceholderTableViewCell.h"
#import "MJRefresh.h"

static NSString * const kNativeInfoTableViewCell = @"kNativeInfoTableViewCell";
static NSString * const kNativeAdTableViewCell = @"kNativeAdTableViewCell";

@interface AMPSNativeExpressListViewController () <UITextFieldDelegate, AMPSNativeExpressManagerDelegate, AMPSNativeExpressViewDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) AMPSNativeExpressManager *nativeExpressManager;

@property (nonatomic, strong) UITableView *infoTableView;

@property (nonatomic, strong) NSMutableArray *adArray;

@property (nonatomic, strong) AdScopeProgressHUD *loadHud;

@end

@implementation AMPSNativeExpressListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.infoTableView];
    self.infoTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshAction)];
    self.infoTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreAction)];
    [self loadAd];
}

- (void)refreshAction {
    [self.adArray removeAllObjects];
    [self loadAd];
}

- (void)loadMoreAction {
    [self loadAd];
}

- (void)loadAd {
    NSLog(@"ampsNative loadAd");
    [self.nativeExpressManager loadNativeExpressManager];
}

- (void)ampsNativeAdLoadSuccess:(AMPSNativeExpressManager *)nativeAd {
    CookieAMPSLog(@"ampsNativeAdLoadSuccess:%@", nativeAd.successAdInfo.adapterClassName);
    for (AMPSAdLoadedInfo *info in nativeAd.failAdInfoList.copy) {
        CookieAMPSLog(@"失败渠道：%@，原因：%@ code:%ld",info.adapterClassName, info.errorMsg,info.errorCode);
    }
    if (nativeAd.viewsArray.count == 0) {
        return;
    }
    for (int i = 0; i < nativeAd.viewsArray.count; i++) {
        AMPSNativeExpressView *expressView = [nativeAd.viewsArray objectAtIndex:i];
        expressView.delegate = self;
        expressView.viewController = self;
        expressView.tag = i;
        [expressView render];
    }
    [self.loadHud hideAnimated:YES];
    [self.infoTableView.mj_header endRefreshing];
    [self.infoTableView.mj_footer endRefreshing];
}

- (void)ampsNativeAdLoadFail:(AMPSNativeExpressManager *)nativeAd
                       error:(NSError *_Nullable)error {
    [self.infoTableView.mj_header endRefreshing];
    [self.infoTableView.mj_footer endRefreshing];
}

- (void)ampsNativeAdRenderSuccess:(AMPSNativeExpressView *)nativeView {
    CookieAMPSLog(@"ampsNativeAdRenderSuccess:%@", nativeView);
    [self.adArray adScopeSafeAddObject:nativeView];
    [self.infoTableView reloadData];
}

- (void)ampsNativeAdRenderFail:(AMPSNativeExpressView *)nativeView
                         error:(NSError *_Nullable)error {
    CookieAMPSLog(@"ampsNativeAdRenderFail");
}

- (void)ampsNativeAdExposured:(AMPSNativeExpressView *)nativeView {
    CookieAMPSLog(@"ampsNativeAdExposured");
}

- (void)ampsNativeAdDidClick:(AMPSNativeExpressView *)nativeView {
    CookieAMPSLog(@"ampsNativeAdDidClick");
}

- (void)ampsNativeAdDidClose:(AMPSNativeExpressView *)nativeView {
    CookieAMPSLog(@"ampsNativeAdDidClose");
}

#pragma mark 懒加载
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ((indexPath.row % 5) == 0 && indexPath.row/5 < self.adArray.count) {
        ASNPNavtiveExpressTableViewCell *cell = [ASNPNavtiveExpressTableViewCell cellWithTableView:tableView];
        [cell renderNativeAdView:[self.adArray objectAtIndex:indexPath.row/5]];
        return cell;
    } else {
        ASNPPlaceholderTableViewCell *cell = [ASNPPlaceholderTableViewCell cellWithTableView:tableView];
        return cell;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.adArray.count*5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row % 5 == 0 && indexPath.row/5 < self.adArray.count) {
        UIView *view = [self.adArray objectAtIndex:indexPath.row/5];
        return view.adScopeFrameHeight;
    } else {
        return 200;
    }
}

#pragma mark 懒加载
- (UITableView *)infoTableView {
    if (!_infoTableView) {
        _infoTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetHeight([UIScreen mainScreen].bounds)-kAdScopeDemoStatusBarHeight) style:UITableViewStylePlain];
        _infoTableView.backgroundColor = [UIColor whiteColor];
        _infoTableView.delegate = self;
        _infoTableView.dataSource = self;
        [_infoTableView registerClass:[ASNPPlaceholderTableViewCell class] forCellReuseIdentifier:kNativeInfoTableViewCell];
        [_infoTableView registerClass:[ASNPNavtiveExpressTableViewCell class] forCellReuseIdentifier:kNativeAdTableViewCell];
        _infoTableView.tableHeaderView = [UIView new];
        _infoTableView.tableFooterView = [UIView new];
    }
    return _infoTableView;
}

- (void)startLoadHud {
    self.loadHud = [AdScopeProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    self.loadHud.contentColor = [UIColor adScopeColorWithHexString:@"FFFFFF"];
    self.loadHud.backgroundView.color = [UIColor adScopeColorWithHexString:@"99999999"];
}

- (AdScopeProgressHUD *)loadHud {
    if (!_loadHud) {
        _loadHud = [[AdScopeProgressHUD alloc]initWithView:self.navigationController.view];
        _loadHud.contentColor = [UIColor adScopeColorWithHexString:@"FFFFFF"];
        _loadHud.backgroundView.color = [UIColor adScopeColorWithHexString:@"99999999"];
    }
    return _loadHud;
}

- (NSMutableArray *)adArray {
    if (!_adArray) {
        _adArray = [[NSMutableArray alloc]init];
    }
    return _adArray;
}

- (AMPSNativeExpressManager *)nativeExpressManager {
    if (!_nativeExpressManager) {
        AMPSAdConfiguration *cfg = [[AMPSAdConfiguration alloc]init];
        cfg.adSize = CGSizeMake(self.view.frame.size.width, 0);
        cfg.adCount = 2;
        _nativeExpressManager = [[AMPSNativeExpressManager alloc]initWithSpaceId:self.spaceId adConfiguration:cfg];
        _nativeExpressManager.delegate = self;
    }
    return _nativeExpressManager;
}

- (void)dealloc {
    for (NSInteger i = self.adArray.count - 1; i >= 0; i--) {
        AMPSNativeExpressView *expressView = self.adArray[i];
        expressView.delegate = nil;
        [expressView removeFromSuperview];
        [self.adArray removeObject:expressView];
        expressView = nil;
    }
    if (_nativeExpressManager) {
//        _nativeExpressManager.delegate = nil;
        [_nativeExpressManager removeNativeExpressManager];
        _nativeExpressManager = nil;
    }
    CookieAMPSLog(@"ampsNativeViewController dealloc");
}

@end

