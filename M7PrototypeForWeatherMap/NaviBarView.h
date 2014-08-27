//
//  NaviBarView.h
//  M7PrototypeForWeatherMap
//
//  Created by Chen Meisong on 14-8-26.
//  Copyright (c) 2014年 chenms.m2. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    NBVNaviTypeNormal = 6000,
    NBVNaviTypeTwoRightButton,
} NBVNaviType;

@interface NaviBarView : UIView
@property (nonatomic, readonly) UIButton *titleButton;
@property (nonatomic, readonly) UIButton *leftButton;
@property (nonatomic, readonly) UIButton *rightButton;
@property (nonatomic, readonly) UIButton *rightRightButton;
@property (nonatomic, copy) VoidEventHandler titleButtonTapHandler;
@property (nonatomic, copy) VoidEventHandler leftButtonTapHandler;
@property (nonatomic, copy) VoidEventHandler rightButtonTapHandler;
@property (nonatomic, copy) VoidEventHandler rightRightButtonTapHandler;
- (id)initWithFrame:(CGRect)frame naviType:(NBVNaviType)naviType;
@end
