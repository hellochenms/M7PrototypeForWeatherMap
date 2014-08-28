//
//  DirectionManageView.m
//  M7PrototypeForWeatherMap
//
//  Created by Chen Meisong on 14-8-27.
//  Copyright (c) 2014年 chenms.m2. All rights reserved.
//

#import "DirectionManageView.h"
#import "NaviBarView.h"
#import "DirectionManageCell.h"
#import "CityManager.h"

@interface DirectionManageView()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic) NaviBarView   *naviBarView;
@property (nonatomic) UIButton      *addSrcCityButton;
@property (nonatomic) UIButton      *addDestCityButton;
@property (nonatomic) UIButton      *addCityButton;
@property (nonatomic) UITableView   *tableView;
@property (nonatomic) City          *srcCity;
@property (nonatomic) City          *destCity;
@end

@implementation DirectionManageView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor lightGrayColor];//TODO:!
    }
    
    // 导航条
    _naviBarView = [[NaviBarView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), 44 + (isIOS7 ? 20 : 0))];
    __weak typeof(self) weakSelf = self;
    [_naviBarView.titleButton setTitle:@"路线管理" forState:UIControlStateNormal];
    [_naviBarView.leftButton setTitle:@"返回" forState:UIControlStateNormal];
    _naviBarView.leftButtonTapHandler = ^{
        if (weakSelf.tapBackButtonHandler) {
            weakSelf.tapBackButtonHandler();
        }
    };
    [self addSubview:_naviBarView];
    
    // 添加路线
    _addSrcCityButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _addSrcCityButton.frame = CGRectMake(0, CGRectGetMaxY(_naviBarView.frame), 100, 44);
    _addSrcCityButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [_addSrcCityButton setTitle:@"起点" forState:UIControlStateNormal];
    [_addSrcCityButton addTarget:self action:@selector(onTapAddSrcButton) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_addSrcCityButton];
    
    _addDestCityButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _addDestCityButton.frame = CGRectMake(100, CGRectGetMaxY(_naviBarView.frame), 100, 44);
    _addDestCityButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [_addDestCityButton setTitle:@"终点" forState:UIControlStateNormal];
    [_addDestCityButton addTarget:self action:@selector(onTapAddDestButton) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_addDestCityButton];
    
    _addCityButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _addCityButton.frame = CGRectMake(100 * 2, CGRectGetMaxY(_naviBarView.frame), 120, 44);
    _addCityButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [_addCityButton setTitle:@"添加" forState:UIControlStateNormal];
    [_addCityButton addTarget:self action:@selector(onTapAddCityButton) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_addCityButton];
    
    // 路线列表
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_addSrcCityButton.frame), CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) - CGRectGetMaxY(_addSrcCityButton.frame)) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self addSubview:_tableView];
    
    return self;
}

#pragma mark - public
- (void)setupSrcCity:(City *)srcCity{
    self.srcCity = srcCity;
    [self.addSrcCityButton setTitle:[NSString stringWithFormat:@"起点：%@", self.srcCity.name] forState:UIControlStateNormal];
}
- (void)setupDestCity:(City *)destCity{
    self.destCity = destCity;
    [self.addDestCityButton setTitle:[NSString stringWithFormat:@"终点：%@", self.destCity.name] forState:UIControlStateNormal];
}

#pragma mark - event handler
- (void)onTapAddSrcButton{
    if (self.tapAddSrcCityButtonHandler) {
        self.tapAddSrcCityButtonHandler();
    }
}

- (void)onTapAddDestButton{
    if (self.tapAddDestCityButtonHandler) {
        self.tapAddDestCityButtonHandler();
    }
}

- (void)onTapAddCityButton{
    if (!self.srcCity || !self.destCity) {
        return;
    }
    NSMutableDictionary *dirction = [NSMutableDictionary dictionary];
    [dirction setObject:self.srcCity forKey:kCMDictKeySrcCity];
    [dirction setObject:self.destCity forKey:kCMDictKeyDestCity];
    [[CityManager sharedInstance] addDirection:dirction];
    [self.tableView reloadData];
    [[NSNotificationCenter defaultCenter] postNotificationName:kGlobal_NotificationName_AddDirection object:nil];
    if (self.tapAddDirectionButtonHandler) {
        self.tapAddDirectionButtonHandler();
    }
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[CityManager sharedInstance].directions count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"cellIdentifier";
    DirectionManageCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[DirectionManageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    [cell reloadData:[[CityManager sharedInstance].directions objectAtIndex:indexPath.row]];
    
    return cell;
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    [[CityManager sharedInstance] removeDirection:[[CityManager sharedInstance].directions objectAtIndex:indexPath.row]];
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [[NSNotificationCenter defaultCenter] postNotificationName:kGlobal_NotificationName_RemoveDirection object:nil];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [CityManager sharedInstance].defaultDirection = [[CityManager sharedInstance].directions objectAtIndex:indexPath.row];
    [[NSNotificationCenter defaultCenter] postNotificationName:kGlobal_NotificationName_ChangeDefaultDirection object:nil];
    if (self.tapBackButtonHandler) {
        self.tapBackButtonHandler();
    }
}

- (void)dealloc{
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
}

@end
