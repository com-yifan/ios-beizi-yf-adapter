//
//  AMPSDrawAdCollectionViewCell.m
//  AdScopeDemo
//
//  Created by nie adhub on 2024/12/27.
//

#import "AMPSDrawAdCollectionViewCell.h"

@interface AMPSDrawAdCollectionViewCell ()

@property (nonatomic, strong) UIView *customImageView;

@end

@implementation AMPSDrawAdCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.userInteractionEnabled = YES;
        NSInteger index = arc4random() % 5;
        UIImageView *placeholderImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"cell_placeholder_%ld.jpg", index]]];
        placeholderImageView.frame = self.frame;
        placeholderImageView.clipsToBounds = YES;
        placeholderImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.clipsToBounds = YES;
        [self addSubview:placeholderImageView];
    }
    return self;
}

- (void)renderNativeAdView:(UIView *)nativeAdView {
    [self.customImageView removeFromSuperview];
    self.customImageView = nativeAdView;
    [self.contentView addSubview:self.customImageView];
}

@end
