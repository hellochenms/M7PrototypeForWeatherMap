//
//  RootView.m
//  M7PrototypeForWeatherMap
//
//  Created by Chen Meisong on 14-8-26.
//  Copyright (c) 2014年 chenms.m2. All rights reserved.
//

#import "RootView.h"
#import "NaviBarView.h"
#import "LocationView.h"
#import "DirectionView.h"
#import "CityManager.h"
#import "City.h"

@interface RootView()
@property (nonatomic) NaviBarView   *naviBarView;
@property (nonatomic) LocationView  *locationView;
@property (nonatomic) DirectionView *directionView;
@property (nonatomic) BOOL          isShowingDirectionView;
@property (nonatomic) City          *defaultCity;
@end

@implementation RootView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor lightGrayColor];//TODO:!
    }
    
    _naviBarView = [[NaviBarView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), 44 + (isIOS7 ? 20 : 0))];
    [self bindDefaultCity];
    [_naviBarView.titleButton setTitle:[self defaultCityName] forState:UIControlStateNormal];
    [_naviBarView.leftButton setTitle:@"切换" forState:UIControlStateNormal];
    __weak typeof(self) weakSelf = self;
    _naviBarView.titleButtonTapHandler = ^{
        if (weakSelf.tapTitleButtonHandler) {
            weakSelf.tapTitleButtonHandler(weakSelf.isShowingDirectionView);
        }
    };
    _naviBarView.leftButtonTapHandler = ^{
        weakSelf.isShowingDirectionView = !weakSelf.isShowingDirectionView;
        if (!weakSelf.isShowingDirectionView) {
            [weakSelf bringSubviewToFront:weakSelf.locationView];
            [weakSelf bindDefaultCity];
            [weakSelf.naviBarView.titleButton setTitle:[weakSelf defaultCityName] forState:UIControlStateNormal];
        } else {
            [weakSelf bringSubviewToFront:weakSelf.directionView];
            [weakSelf.naviBarView.titleButton setTitle:[weakSelf defaultDirectionName] forState:UIControlStateNormal];
        }
        
    };
    [self addSubview:_naviBarView];
    
    CGRect contentAreaFrame = CGRectMake(0, CGRectGetMaxY(_naviBarView.frame), CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) - CGRectGetMaxY(_naviBarView.frame));
    
    _directionView = [[DirectionView alloc] initWithFrame:contentAreaFrame];
    [self addSubview:_directionView];
    
    _locationView = [[LocationView alloc] initWithFrame:contentAreaFrame];
    [self addSubview:_locationView];
    
    [[CityManager sharedInstance] addObserver:self
                                   forKeyPath:@"defaultCity"
                                      options:NSKeyValueObservingOptionNew
                                      context:nil];
    [[CityManager sharedInstance] addObserver:self
                                   forKeyPath:@"defaultDirection"
                                      options:NSKeyValueObservingOptionNew
                                      context:nil];
    
    return self;
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if ([keyPath isEqualToString:@"defaultCity"]) {
        [self bindDefaultCity];
        if (!self.isShowingDirectionView) {
            [self.naviBarView.titleButton setTitle:[self defaultCityName] forState:UIControlStateNormal];
        }
    } else if ([keyPath isEqualToString:@"defaultDirection"]) {
        if (self.isShowingDirectionView) {
            [self.naviBarView.titleButton setTitle:[self defaultDirectionName] forState:UIControlStateNormal];
        }
    } else if ([keyPath isEqualToString:@"name"]) {
        if (!self.isShowingDirectionView) {
            [self.naviBarView.titleButton setTitle:[self defaultCityName] forState:UIControlStateNormal];
        }
    }
}

- (NSString *)defaultCityName{
    NSString *cityName = @"暂无";
    if ([CityManager sharedInstance].defaultCity) {
        cityName = [CityManager sharedInstance].defaultCity.name;
    }
    return cityName;
}

- (NSString *)defaultDirectionName{
    NSString *directionName = @"暂无";
    if ([CityManager sharedInstance].defaultDirection) {
        directionName = [NSString stringWithFormat:@"%@到%@", ((City *)[[CityManager sharedInstance].defaultDirection objectForKey:kCMDictKeySrcCity]).name, ((City *)[[CityManager sharedInstance].defaultDirection objectForKey:kCMDictKeyDestCity]).name];
    }
    return directionName;
}

- (void)bindDefaultCity{
    [self.defaultCity removeObserver:self forKeyPath:@"name"];
    self.defaultCity = [CityManager sharedInstance].defaultCity;
    [self.defaultCity addObserver:self
                       forKeyPath:@"name"
                          options:NSKeyValueObservingOptionNew
                          context:nil];
}

#pragma mark - dealloc
- (void)dealloc{
    [[CityManager sharedInstance] removeObserver:self forKeyPath:@"defaultCity"];
    [[CityManager sharedInstance] removeObserver:self forKeyPath:@"defaultDirection"];
    [self.defaultCity removeObserver:self forKeyPath:@"name"];
}

@end
