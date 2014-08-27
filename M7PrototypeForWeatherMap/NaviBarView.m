//
//  NaviBarView.m
//  M7PrototypeForWeatherMap
//
//  Created by Chen Meisong on 14-8-26.
//  Copyright (c) 2014年 chenms.m2. All rights reserved.
//

#import "NaviBarView.h"

@interface NaviBarView()
@property (nonatomic) UIButton *titleButton;
@property (nonatomic) UIButton *leftButton;
@property (nonatomic) UIButton *rightButton;
@property (nonatomic) UIButton *rightRightButton;
@end

@implementation NaviBarView

- (id)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame naviType:NBVNaviTypeNormal];
}

- (id)initWithFrame:(CGRect)frame naviType:(NBVNaviType)naviType{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blueColor];//TODO:!
        
        double height = 44;
        double originY = CGRectGetHeight(self.bounds) - height;
        
        _titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _titleButton.frame = CGRectMake(44, originY, CGRectGetWidth(self.bounds) - 44 * 2, height);
        [_titleButton addTarget:self action:@selector(onTapTitleButton) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_titleButton];
        
        _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _leftButton.frame = CGRectMake(0, originY, 44, height);
        _leftButton.backgroundColor = [UIColor redColor];//TODO:!
        [_leftButton addTarget:self action:@selector(onTapLeftButton) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_leftButton];
        
        _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightButton.backgroundColor = [UIColor redColor];//TODO:!
        [_rightButton addTarget:self action:@selector(onTapRightButton) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_rightButton];
        
        if (naviType == NBVNaviTypeNormal) {
            _rightButton.frame = CGRectMake(CGRectGetWidth(self.bounds) - 44, originY, 44, height);
        } else if (naviType == NBVNaviTypeTwoRightButton) {
            _rightButton.frame = CGRectMake(CGRectGetWidth(self.bounds) - 44 * 2, originY, 44, height);
            
            _rightRightButton = [UIButton buttonWithType:UIButtonTypeCustom];
            _rightRightButton.frame = CGRectMake(CGRectGetWidth(self.bounds) - 44, originY, 44, height);
            _rightRightButton.backgroundColor = [UIColor orangeColor];//TODO:!
            [_rightRightButton addTarget:self action:@selector(onTapRightRightButton) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:_rightRightButton];
        }
    }
    
    return self;
}

#pragma mark - event handler
- (void)onTapTitleButton{
    if (self.titleButtonTapHandler) {
        self.titleButtonTapHandler();
    }
}
- (void)onTapLeftButton{
    if (self.leftButtonTapHandler) {
        self.leftButtonTapHandler();
    }
}
- (void)onTapRightButton{
    if (self.rightButtonTapHandler) {
        self.rightButtonTapHandler();
    }
}
- (void)onTapRightRightButton{
    if (self.rightRightButtonTapHandler) {
        self.rightRightButtonTapHandler();
    }
}

@end
