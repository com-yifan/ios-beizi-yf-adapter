//
//  ASNPNavtiveExpressTableViewCell.h
//  AdScopeDemo
//
//  Created by Cookie on 2023/2/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ASNPNavtiveExpressTableViewCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

- (void)renderNativeAdView:(UIView *)nativeAdView;

@end

NS_ASSUME_NONNULL_END
