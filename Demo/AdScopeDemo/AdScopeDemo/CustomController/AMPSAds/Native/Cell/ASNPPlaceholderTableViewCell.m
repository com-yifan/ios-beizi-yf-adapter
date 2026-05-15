//
//  ASNPPlaceholderTableViewCell.m
//  AdScopeDemo
//
//  Created by Cookie on 2023/2/26.
//

#import "ASNPPlaceholderTableViewCell.h"

@implementation ASNPPlaceholderTableViewCell

static NSString * identifier0 = @"kNativeInfoTableViewCell";

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    
    ASNPPlaceholderTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier0];
    if (!cell) {
        cell = [[ASNPPlaceholderTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier0];
    }
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.userInteractionEnabled = YES;
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        NSInteger index = arc4random() % 3;
        UIImageView *placeholderImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"cell_placeholder_%ld.jpg", index]]];
        placeholderImageView.frame = CGRectMake(15, 15, CGRectGetWidth([UIScreen mainScreen].bounds)-30, 170);
        placeholderImageView.clipsToBounds = YES;
        placeholderImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.clipsToBounds = YES;
        [self addSubview:placeholderImageView];
    }
    return self;
}

@end
