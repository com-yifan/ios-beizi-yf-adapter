//
//  AMPSDrawAdPlaceholderCollectionViewCell.m
//  AdScopeDemo
//
//  Created by nie adhub on 2025/1/3.
//

#import "AMPSDrawAdPlaceholderCollectionViewCell.h"

@implementation AMPSDrawAdPlaceholderCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.userInteractionEnabled = YES;
        UIImageView *placeholderImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [placeholderImageView setImage:[UIImage imageNamed:@"cell_placeholder_1.jpg"]];
        placeholderImageView.clipsToBounds = YES;
        placeholderImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.clipsToBounds = YES;
        [self addSubview:placeholderImageView];
    }
    return self;
}

@end
