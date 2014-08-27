//
//  LocationManageView.m
//  M7PrototypeForWeatherMap
//
//  Created by Chen Meisong on 14-8-27.
//  Copyright (c) 2014年 chenms.m2. All rights reserved.
//

#import "LocationManageView.h"
#import "NaviBarView.h"
#import "CityManager.h"
#import "LocationManageCell.h"

@interface LocationManageView()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic) NaviBarView   *naviBarView;
@property (nonatomic) UITableView   *tableView;
@end

@implementation LocationManageView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor lightGrayColor];//TODO:!
    }
    
    _naviBarView = [[NaviBarView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), 44 + (isIOS7 ? 20 : 0)) naviType:NBVNaviTypeTwoRightButton];
    __weak typeof(self) weakSelf = self;
    [_naviBarView.titleButton setTitle:@"城市管理" forState:UIControlStateNormal];
    [_naviBarView.leftButton setTitle:@"返回" forState:UIControlStateNormal];
    _naviBarView.leftButtonTapHandler = ^{
        weakSelf.tableView.editing = NO;
        [weakSelf refreshEditButton];
        if (weakSelf.tapBackButtonHandler) {
            weakSelf.tapBackButtonHandler();
        }
    };
    [_naviBarView.rightButton setTitle:@"编辑" forState:UIControlStateNormal];
    _naviBarView.rightButtonTapHandler = ^{
        weakSelf.tableView.editing = !weakSelf.tableView.editing;
        [weakSelf refreshEditButton];
    };
    [_naviBarView.rightRightButton setTitle:@"添加" forState:UIControlStateNormal];
    _naviBarView.rightRightButtonTapHandler = ^{
        if (weakSelf.tapAddButtonHandler) {
            weakSelf.tapAddButtonHandler();
        }
    };
    [self addSubview:_naviBarView];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_naviBarView.frame), CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) - CGRectGetMaxY(_naviBarView.frame)) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self addSubview:_tableView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onNotifyAddCity)
                                                 name:kGlobal_NotificationName_AddCity
                                               object:nil];
    
    return self;
}

- (void)refreshEditButton{
    [self.naviBarView.rightButton setTitle:(self.tableView.editing ? @"完成" : @"编辑") forState:UIControlStateNormal];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[CityManager sharedInstance].cities count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"cellIdentifier";
    LocationManageCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[LocationManageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    [cell reloadData:[[CityManager sharedInstance].cities objectAtIndex:indexPath.row]];

    return cell;
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    [[CityManager sharedInstance] removeCity:[[CityManager sharedInstance].cities objectAtIndex:indexPath.row]];
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [[NSNotificationCenter defaultCenter] postNotificationName:kGlobal_NotificationName_RemoveCity object:nil];
}

#pragma mark - 通知
- (void)onNotifyAddCity{
    [self.tableView reloadData];
}

#pragma mark - dealloc
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
