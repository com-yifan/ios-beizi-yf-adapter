//
//  AMPSAdUITestViewController.m
//  AdScopeDemo
//
//  Created by Cookie on 2023/5/26.
//

#import "AMPSAdUITestViewController.h"
#import <AdScopeFoundation/AdScopeFoundation.h>
#import "AMPSBaseUITestViewController.h"

static NSString * const kHomeTableViewCell = @"kHomeTableViewCell";

@interface AMPSAdUITestViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *mainTableView;

@property (nonatomic, strong) NSArray *nameArray;

@end

@implementation AMPSAdUITestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.mainTableView];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dict = self.nameArray[indexPath.row];
    Class class = NSClassFromString(dict[@"controller"]);
    AMPSBaseUITestViewController *viewController = [[class alloc]init];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kHomeTableViewCell forIndexPath:indexPath];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.backgroundColor = [UIColor whiteColor];
    cell.textLabel.textColor = [UIColor blackColor];
    NSDictionary *dict = self.nameArray[indexPath.row];
    cell.textLabel.text = dict[@"name"];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.nameArray.count;
}

#pragma mark 懒加载
- (UITableView *)mainTableView {
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetHeight([UIScreen mainScreen].bounds)) style:UITableViewStylePlain];
        _mainTableView.backgroundColor = [UIColor whiteColor];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        [_mainTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kHomeTableViewCell];
        _mainTableView.tableHeaderView = [UIView new];
        _mainTableView.tableFooterView = [UIView new];
    }
    return _mainTableView;
}

- (NSArray *)nameArray {
    if (!_nameArray) {
        _nameArray = @[@{@"name":@"聚合开屏", @"controller":@"AMPSSplashUITestViewController"}
        ];
    }
    return _nameArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end


