//
//  AddLocationView.m
//  M7PrototypeForWeatherMap
//
//  Created by Chen Meisong on 14-8-27.
//  Copyright (c) 2014年 chenms.m2. All rights reserved.
//

#import "AddLocationView.h"
#import "NaviBarView.h"
#import "CityAddCollectionViewCell.h"
#import "CityManager.h"
#import "CityAddSearchResultCell.h"
#import "CitySearcher.h"
#import "HotCitiesConfig.h"

//@interface AddLocationView()
//@property (nonatomic) NaviBarView   *naviBarView;
//@end

#define CAV_Cell_Identifier @"collectionCell"

@interface AddLocationView()<UICollectionViewDataSource, UICollectionViewDelegate, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>
@property (nonatomic) UIView                *naviView;
@property (nonatomic) UIImageView           *searchIconImageView;
@property (nonatomic) UITextField           *searchTextFiled;
@property (nonatomic) UIButton              *backButton;
@property (nonatomic) UITableView           *searchResultsTableView;
@property (nonatomic) NSArray               *searchResults;
@property (nonatomic) UICollectionView      *hotCitiesCollectionView;
@property (nonatomic) NSArray               *hotCities;
@property (nonatomic) UIControl             *coverView;
@property (nonatomic) NSMutableDictionary   *existHotCityIndexes;
@property (nonatomic) NSMutableDictionary   *existSearchCityIndexes;
@property (nonatomic) ALVAddViewType        type;
@end

@implementation AddLocationView
//- (id)initWithFrame:(CGRect)frame{
//    self = [super initWithFrame:frame];
//    if (self) {
//        self.backgroundColor = [UIColor lightGrayColor];//TODO:!
//    }
//    
//    _naviBarView = [[NaviBarView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), 44 + (isIOS7 ? 20 : 0))];
//    __weak typeof(self) weakSelf = self;
//    [_naviBarView.titleButton setTitle:@"添加城市" forState:UIControlStateNormal];
//    [_naviBarView.leftButton setTitle:@"返回" forState:UIControlStateNormal];
//    _naviBarView.leftButtonTapHandler = ^{
//        if (weakSelf.tapBackButtonHandler) {
//            weakSelf.tapBackButtonHandler();
//        }
//    };
//    [self addSubview:_naviBarView];
//    
//    return self;
//}

- (id)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame type:ALVAddViewTypeDisableUsedCity];
}

- (id)initWithFrame:(CGRect)frame type:(ALVAddViewType)type{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _type = type;
        
        _hotCities = [HotCitiesConfig sharedInstance].hotCities;
        if (_type == ALVAddViewTypeDisableUsedCity) {
            _existHotCityIndexes = [NSMutableDictionary dictionary];
            [self filterItemsFromSrcArray:_hotCities toExistDictionary:_existHotCityIndexes];
            _existSearchCityIndexes = [NSMutableDictionary dictionary];
        }
        
        self.backgroundColor = [UIColor colorWithRed:0xea/255.0 green:0xea/255.0 blue:0xea/255.0 alpha:1];
        
        float yModifierY = (isIOS7 ? 20 : 0);
        
        _naviView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), 44 + yModifierY)];
        _naviView.backgroundColor = [UIColor colorWithRed:0x33 / 255.0 green:0x33 / 255.0 blue:0x33 / 255.0 alpha:1.0];
        [self addSubview:_naviView];
        
        UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, yModifierY, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) - yModifierY)];
        [self addSubview:contentView];
        
        // 搜索框
        UIButton *searchIconButton = [UIButton buttonWithType:UIButtonTypeCustom];
        searchIconButton.frame = CGRectMake(0, 0, 44, 44);
        [searchIconButton setImage:[UIImage imageNamed:@"search_icon"] forState:UIControlStateNormal];
        [searchIconButton addTarget:self action:@selector(onTapSearchIcon) forControlEvents:UIControlEventTouchUpInside];
        [contentView addSubview:searchIconButton];
        
        UILabel *searchTextBglabel = [[UILabel alloc] initWithFrame:CGRectMake(44, 0, 230, 44)];
        searchTextBglabel.backgroundColor = [UIColor clearColor];
        searchTextBglabel.textColor = [UIColor colorWithRed:119.0/255.0 green:119.0/255.0 blue:119.0/255.0 alpha:1];
        searchTextBglabel.font = [UIFont systemFontOfSize:15];
        searchTextBglabel.text = @"请输入城市的名称，全拼，简拼";
        [contentView addSubview:searchTextBglabel];
        
        _searchTextFiled = [[UITextField alloc] initWithFrame:CGRectMake(44, 0, 230, 44)];
        _searchTextFiled.backgroundColor = [UIColor clearColor];
        _searchTextFiled.textColor = [UIColor whiteColor];
        _searchTextFiled.font = [UIFont systemFontOfSize:15];
        _searchTextFiled.clearButtonMode = UITextFieldViewModeAlways;
        _searchTextFiled.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _searchTextFiled.delegate = self;
        [contentView addSubview:_searchTextFiled];
        
        // 返回按钮
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _backButton.frame = CGRectMake(270, 0, 50, 44);
        _backButton.titleLabel.font = [UIFont systemFontOfSize:18];
        [_backButton setTitle:@"取消" forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(onTapBackButton) forControlEvents:UIControlEventTouchUpInside];
        [contentView addSubview:_backButton];
        
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.itemSize = CGSizeMake(100, 40);
        layout.minimumInteritemSpacing = 5;
        _hotCitiesCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 44, 320, CGRectGetHeight(contentView.bounds) - 44) collectionViewLayout:layout];
        _hotCitiesCollectionView.backgroundColor = [UIColor clearColor];
        [_hotCitiesCollectionView registerClass:[CityAddCollectionViewCell class] forCellWithReuseIdentifier:CAV_Cell_Identifier];
        _hotCitiesCollectionView.dataSource = self;
        _hotCitiesCollectionView.delegate = self;
        [contentView addSubview:_hotCitiesCollectionView];
        
        // 遮罩
        _coverView = [[UIControl alloc] initWithFrame:CGRectMake(0, 44, 320, CGRectGetHeight(contentView.bounds) - 44)];
        _coverView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.382];
        [_coverView addTarget:self action:@selector(opTapCover) forControlEvents:UIControlEventTouchUpInside];
        [contentView addSubview:_coverView];
        _coverView.hidden = YES;
        
        // 搜索结果列表
        _searchResultsTableView = [[UITableView alloc] initWithFrame:_coverView.frame];
        _searchResultsTableView.backgroundColor = self.backgroundColor;
        _searchResultsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _searchResultsTableView.rowHeight = 64;
        _searchResultsTableView.dataSource = self;
        _searchResultsTableView.delegate = self;
        _searchResultsTableView.hidden = YES;
        [contentView addSubview:_searchResultsTableView];
    }
    return self;
}

#pragma mark - UICollectionViewDataSource, UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self.hotCities count];
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CityAddCollectionViewCell *cell = (CityAddCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CAV_Cell_Identifier forIndexPath:indexPath];
    City *city = [self.hotCities objectAtIndex:indexPath.row];
    BOOL isExists = (_type == ALVAddViewTypeDisableUsedCity ? ([self.existHotCityIndexes objectForKey:[NSString stringWithFormat:@"%d", indexPath.row]] != nil) : NO);
    [cell reloadData:city.name
            isExists:isExists];
    
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    City *city = [_hotCities objectAtIndex:indexPath.row];
    [self didSelectCity:city];
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    _coverView.hidden = NO;
    _coverView.alpha = 0;
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.15
                     animations:^{
                         weakSelf.coverView.alpha = 1;
                     }];
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    // TODO:!
//    NSMutableString *curText = [textField.text mutableCopy];
//    [curText replaceCharactersInRange:range withString:string];
//    //    NSLog(@"textField(%@) string(%@) curText(%@) %s", textField.text, string, curText, __func__);
//    if ([curText length] > 0) {
//        textField.backgroundColor = _naviView.backgroundColor;
//    } else {
//        textField.backgroundColor = [UIColor clearColor];
//        __weak typeof(self) weakSelf = self;
//        [UIView animateWithDuration:0.15
//                         animations:^{
//                             weakSelf.searchResultsTableView.alpha = 0;
//                         } completion:^(BOOL finished) {
//                             weakSelf.searchResultsTableView.hidden = YES;
//                             weakSelf.searchResultsTableView.alpha = 1;
//                         }];
//        return YES;
//    }
//    
//    self.searchResultsTableView.hidden = NO;
//    
//    __weak typeof(self) weakSelf = self;
//    
//    NSArray *results = [[CitySearcher sharedInstance] searchForKeyword:curText];
//    weakSelf.searchResults = results;
//    [weakSelf filterItemsFromSrcArray:weakSelf.searchResults toExistDictionary:weakSelf.existSearchCityIndexes];
//    [weakSelf.searchResultsTableView reloadData];
    
    return YES;
}
- (BOOL)textFieldShouldClear:(UITextField *)textField{
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.15
                     animations:^{
                         weakSelf.searchResultsTableView.alpha = 0;
                     } completion:^(BOOL finished) {
                         weakSelf.searchResultsTableView.hidden = YES;
                         weakSelf.searchResultsTableView.alpha = 1;
                     }];
    return YES;
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.searchResults count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"cell";
    CityAddSearchResultCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[CityAddSearchResultCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    City *city = [self.searchResults objectAtIndex:indexPath.row];
    BOOL isExists = (_type == ALVAddViewTypeDisableUsedCity ? [self.existSearchCityIndexes objectForKey:[NSString stringWithFormat:@"%d", indexPath.row]] != nil : NO);
    [cell reloadData:city.name isExists:isExists];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    City *city = [self.searchResults objectAtIndex:indexPath.row];
    [self didSelectCity:city];
}

#pragma mark -
- (void)opTapCover{
    __weak typeof(self) weakSelf = self;
    [self.searchTextFiled resignFirstResponder];
    [UIView animateWithDuration:0.15
                     animations:^{
                         weakSelf.coverView.alpha = 0;
                     }
                     completion:^(BOOL finished) {
                         weakSelf.coverView.hidden = YES;
                     }];
}

#pragma mark -
- (void)onTapBackButton{
    if ([[CityManager sharedInstance].cities count] <= 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                            message:@"请至少添加一个城市"
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
        [alertView show];
        return;
    }
    if (self.tapBackButtonHandler) {
        self.tapBackButtonHandler();
    }
}

- (void)didSelectCity:(City *)city{
    __block BOOL isExists = NO;
    [[CityManager sharedInstance].cities enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([city isEqual:obj]) {
            isExists = YES;
            *stop = YES;
        }
    }];
    
    if (isExists) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                            message:@"您已添加过这个城市"
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
        [alertView show];
    } else {
        if (self.addFinishHandler) {
            self.addFinishHandler(city);
        }
    }
}

#pragma mark -
- (void)onTapSearchIcon{
    // TODO:!
//    [_searchTextFiled becomeFirstResponder];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (scrollView == self.searchResultsTableView) {
        __weak typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.searchTextFiled resignFirstResponder];
        });
    }
}

#pragma mark - tools
- (void)filterItemsFromSrcArray:(NSArray *)srcArray toExistDictionary:(NSMutableDictionary *)existDictionary{
    [existDictionary removeAllObjects];
    [srcArray enumerateObjectsUsingBlock:^(City *srcObj, NSUInteger srcIdx, BOOL *srcStop) {
        [[CityManager sharedInstance].cities enumerateObjectsUsingBlock:^(City *obj, NSUInteger idx, BOOL *stop) {
            if ([srcObj isEqual:obj]){
                [existDictionary setObject:@(YES) forKey:[NSString stringWithFormat:@"%d", srcIdx]];
                *stop = YES;
            }
        }];
    }];
}
@end
