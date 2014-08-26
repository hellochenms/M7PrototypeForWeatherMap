//
//  NaviBarView.h
//  M7PrototypeForWeatherMap
//
//  Created by Chen Meisong on 14-8-26.
//  Copyright (c) 2014年 chenms.m2. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NaviBarView : UIView
@property (nonatomic, readonly) UILabel *titleLabel;
@property (nonatomic, readonly) UIButton *leftButton;
@property (nonatomic, readonly) UIButton *rightButton;
@property (nonatomic, copy) VoidEventHandler leftButtonTapHandler;
@property (nonatomic, copy) VoidEventHandler rightButtonTapHandler;
@end
