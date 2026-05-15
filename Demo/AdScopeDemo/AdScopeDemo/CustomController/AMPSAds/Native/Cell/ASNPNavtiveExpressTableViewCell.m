//
//  ASNPNavtiveExpressTableViewCell.m
//  AdScopeDemo
//
//  Created by Cookie on 2023/2/23.
//

#import "ASNPNavtiveExpressTableViewCell.h"

@interface ASNPNavtiveExpressTableViewCell ()

@property (nonatomic, strong) UIView *customImageView;

@end

@implementation ASNPNavtiveExpressTableViewCell

static NSString * identifier0 = @"kNativeAdTableViewCell";

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    
    ASNPNavtiveExpressTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier0];
    if (!cell) {
        cell = [[ASNPNavtiveExpressTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier0];
    }
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.userInteractionEnabled = YES;
        [self setSelectionStyle:UITableViewCellSelectionStyleDefault];
    }
    return self;
}

- (void)renderNativeAdView:(UIView *)nativeAdView {
    [self.customImageView removeFromSuperview];
    self.customImageView = nativeAdView;
    [self.contentView addSubview:nativeAdView];
}

@end
