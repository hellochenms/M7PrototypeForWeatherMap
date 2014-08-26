//
//  NaviBarView.m
//  M7PrototypeForWeatherMap
//
//  Created by Chen Meisong on 14-8-26.
//  Copyright (c) 2014年 chenms.m2. All rights reserved.
//

#import "NaviBarView.h"

@interface NaviBarView()
@property (nonatomic) UILabel *titleLabel;
@property (nonatomic) UIButton *leftButton;
@property (nonatomic) UIButton *rightButton;
@end

@implementation NaviBarView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blueColor];//TODO:!
        
        double height = 44;
        double originY = CGRectGetHeight(self.bounds) - height;
        
        _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _leftButton.frame = CGRectMake(0, originY, 44, height);
        _leftButton.backgroundColor = [UIColor redColor];//TODO:!
        [_leftButton addTarget:self action:@selector(onTapLeftButton) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_leftButton];
        
        _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightButton.frame = CGRectMake(CGRectGetWidth(self.bounds) - 44, originY, 44, height);
        _rightButton.backgroundColor = [UIColor redColor];//TODO:!
        [_rightButton addTarget:self action:@selector(onTapRightButton) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_rightButton];
    }
    
    return self;
}

#pragma mark - event handler
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

@end
