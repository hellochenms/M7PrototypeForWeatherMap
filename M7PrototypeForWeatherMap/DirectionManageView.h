//
//  DirectionManageView.h
//  M7PrototypeForWeatherMap
//
//  Created by Chen Meisong on 14-8-27.
//  Copyright (c) 2014年 chenms.m2. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "City.h"

@interface DirectionManageView : UIView
@property (nonatomic, copy) VoidEventHandler tapBackButtonHandler;
@property (nonatomic, copy) VoidEventHandler tapAddSrcCityButtonHandler;
@property (nonatomic, copy) VoidEventHandler tapAddDestCityButtonHandler;
@property (nonatomic, copy) VoidEventHandler tapAddDirectionButtonHandler;
- (void)setupSrcCity:(City *)srcCity;
- (void)setupDestCity:(City *)destCity;
@end
