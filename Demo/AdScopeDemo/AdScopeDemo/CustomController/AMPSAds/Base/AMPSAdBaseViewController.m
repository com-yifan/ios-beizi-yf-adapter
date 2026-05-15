//
//  AMPSAdBaseViewController.m
//  AdScopeDemo
//
//  Created by Cookie on 2023/6/9.
//

#import "AMPSAdBaseViewController.h"
#import "AdScopeDemoMacro.h"
#import "AdScopeDemoAnyControlTool.h"
#import "AdScopeDemoStatusObject.h"

@interface AMPSAdBaseViewController ()

@end

@implementation AMPSAdBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)createAnyView {
    
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-kAdScopeDemoNavHeight)];
        [_scrollView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClick)]];
    }
    return _scrollView;
}

- (void)didClick {
    [self.view endEditing:YES];
}

@end
