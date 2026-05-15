//
//  AMPSDrawAdListViewController.m
//  AdScopeDemo
//
//  Created by nie adhub on 2024/12/10.
//

#import "AMPSDrawAdListViewController.h"
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
#import "AMPSDrawAdCollectionViewCell.h"
#import "AMPSDrawAdPlaceholderCollectionViewCell.h"

static NSString * const kNativeInfoTableViewCell = @"kNativeInfoTableViewCell";
static NSString * const kNativeAdTableViewCell = @"kNativeAdTableViewCell";
static NSString * identifier0 = @"kDrawAdCollectionViewCell";
static NSString * identifier1 = @"kDrawAdCollectionViewCell1";


@interface AMPSDrawAdListViewController () <AMPSDrawAdManagerDelegate,AMPSDrawAdViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate>

@property (nonatomic, strong) AMPSDrawAdManager *drawAdManager;

@property (nonatomic, strong) AdScopeThreadSafeArray *adArray;

@property (nonatomic, strong) AdScopeProgressHUD *loadHud;

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation AMPSDrawAdListViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
    self.navigationController.navigationBar.translucent = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.minimumLineSpacing = 0;
    layout.itemSize = CGSizeMake(CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetHeight([UIScreen mainScreen].bounds));
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetHeight([UIScreen mainScreen].bounds)) collectionViewLayout:layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.pagingEnabled = YES;
    self.collectionView.bounces = NO;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectionView];
    [self.collectionView registerClass:[AMPSDrawAdCollectionViewCell class] forCellWithReuseIdentifier:identifier0];
    [self.collectionView registerClass:[AMPSDrawAdPlaceholderCollectionViewCell class] forCellWithReuseIdentifier:identifier1];
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
    [self.drawAdManager loadDrawAdManager];
}

- (void)ampsDrawAdLoadSuccess:(AMPSDrawAdManager *)drawVideoAd {
    CookieAMPSLog(@"ampsDrawAdLoadSuccess:%@", drawVideoAd.drawAdsArray);
    CookieAMPSLog(@"成功渠道：%@-----id---%@", drawVideoAd.successAdInfo.adapterClassName,drawVideoAd.successAdInfo.adapterSpaceId);
    for (AMPSAdLoadedInfo *info in drawVideoAd.failAdInfoList.copy) {
        CookieAMPSLog(@"失败渠道：%@，原因：%@",info.adapterClassName, info.errorMsg);
    }
    if (drawVideoAd.drawAdsArray.count == 0) {
        return;
    }
    for (int i = 0; i < drawVideoAd.drawAdsArray.count; i++) {
        AMPSDrawAdView *expressView = [drawVideoAd.drawAdsArray objectAtIndex:i];
        NSLog(@"---------%@",expressView);
        CookieAMPSLog(@"价格：%ld", expressView.eCPM);
        expressView.delegate = self;
        expressView.viewController = [UIApplication sharedApplication].keyWindow.rootViewController;
        expressView.tag = i;
        [expressView render];
    }
    [self.loadHud hideAnimated:YES];
    [self.collectionView.mj_header endRefreshing];
    [self.collectionView.mj_footer endRefreshing];
}

- (void)ampsDrawAdLoadFail:(AMPSDrawAdManager *)drawVideoAd error:(NSError *)error {
    [self.collectionView.mj_header endRefreshing];
    [self.collectionView.mj_footer endRefreshing];
    for (AMPSAdLoadedInfo *info in drawVideoAd.failAdInfoList.copy) {
        CookieAMPSLog(@"失败渠道：%@，原因：%@",info.adapterClassName, info.errorMsg);
    }
}

- (void)ampsDrawAdRenderSuccess:(AMPSDrawAdView *)drawAdView {
    [self.adArray adScopeSafeAddObject:drawAdView];
    [self.collectionView reloadData];
}

- (void)ampsDrawAdRenderFail:(AMPSDrawAdView *)drawAdView error:(NSError *)error {
    CookieAMPSLog(@"ampsDrawAdRenderFail");
}

- (void)ampsDrawAdExposured:(AMPSDrawAdView *)drawAdView {
    NSLog(@"-----------ampsDrawAdExposured");
}

- (void)ampsDrawAdDidClick:(AMPSDrawAdView *)drawAdView {
    NSLog(@"-----------ampsDrawAdDidClick");
}

- (void)ampsDrawAdDidCloseOtherController:(AMPSDrawAdView *)drawAdView {
    NSLog(@"-----------ampsDrawAdDidCloseOtherController");
}

- (void)ampsDrawAdDidPlayFinish:(AMPSDrawAdView *)drawAdView {
    NSLog(@"-----------ampsDrawAdDidPlayFinish");
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
 
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.adArray.count > 0) {
        return self.adArray.count*5;
    }
    return 4;
}
 
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if ((indexPath.row % 5) == 0 && indexPath.row/5 < self.adArray.count) {
        AMPSDrawAdCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier0 forIndexPath:indexPath];
        [cell renderNativeAdView:[self.adArray objectAtIndex:indexPath.row/5]];
        return cell;
    } else {
        AMPSDrawAdPlaceholderCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier1 forIndexPath:indexPath];
        return cell;
    }
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.adArray.count > 0 && indexPath.row == 0) {
        AMPSDrawAdView *nativeView = [self.adArray objectAtIndex:0];
        [nativeView play];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.adArray.count > 0 && indexPath.row == 0) {
        AMPSDrawAdView *nativeView = [self.adArray objectAtIndex:0];
        [nativeView pause];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self centerCurrentPage];
}
 
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        [self centerCurrentPage];
    }
}

- (void)centerCurrentPage {
    NSInteger currentPage = (NSInteger)(self.collectionView.contentOffset.x + self.collectionView.frame.size.width / 2) / self.collectionView.frame.size.width;
    if (currentPage >= 0 && currentPage < self.adArray.count*5) {
        CGPoint targetContentOffset = CGPointMake(currentPage * self.collectionView.frame.size.width, self.collectionView.contentOffset.y);
        [self.collectionView setContentOffset:targetContentOffset animated:YES];
    }
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
        _adArray = [[AdScopeThreadSafeArray alloc]init];
    }
    return _adArray;
}

- (AMPSDrawAdManager *)drawAdManager {
    if (!_drawAdManager) {
        AMPSAdConfiguration *cfg = [[AMPSAdConfiguration alloc]init];
//        cfg.adSize = CGSizeMake(self.view.frame.size.width, CGRectGetHeight([UIScreen mainScreen].bounds)-kAdScopeDemoStatusBarHeight);
        cfg.adSize = CGSizeMake(self.view.frame.size.width, CGRectGetHeight([UIScreen mainScreen].bounds));
        cfg.adCount = 1;
        cfg.templateTypes = @[@2];
        _drawAdManager = [[AMPSDrawAdManager alloc]initWithSpaceId:self.spaceId adConfiguration:cfg];
        _drawAdManager.delegate = self;
    }
    return _drawAdManager;
}

- (void)dealloc {
    for (int i=0; i<_adArray.count; i++) {
        AMPSDrawAdView *nativeView = [_adArray objectAtIndex:i];
        [self.adArray removeObject:nativeView];
    }
    if (_drawAdManager) {
        [_drawAdManager removeDrawAdManager];
        _drawAdManager = nil;
    }
}

@end
