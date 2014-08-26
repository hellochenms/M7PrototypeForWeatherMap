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

@interface RootView()
@property (nonatomic) NaviBarView   *naviBarView;
@property (nonatomic) LocationView  *locationView;
@property (nonatomic) DirectionView *directionView;
@property (nonatomic) BOOL          isShowingDirectionView;
@end

@implementation RootView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor lightGrayColor];//TODO:!
    }
    
    _naviBarView = [[NaviBarView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), 44 + (isIOS7 ? 20 : 0))];
    __weak typeof(self) weakSelf = self;
    _naviBarView.leftButtonTapHandler = ^{
        if (weakSelf.isShowingDirectionView) {
            [weakSelf bringSubviewToFront:weakSelf.locationView];
        } else {
            [weakSelf bringSubviewToFront:weakSelf.directionView];
        }
        weakSelf.isShowingDirectionView = !weakSelf.isShowingDirectionView;
    };
    [self addSubview:_naviBarView];
    
    CGRect contentAreaFrame = CGRectMake(0, CGRectGetMaxY(_naviBarView.frame), CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) - CGRectGetMaxY(_naviBarView.frame));
    
    _directionView = [[DirectionView alloc] initWithFrame:contentAreaFrame];
    [self addSubview:_directionView];
    
    _locationView = [[LocationView alloc] initWithFrame:contentAreaFrame];
    [self addSubview:_locationView];
    
    return self;
}

@end
