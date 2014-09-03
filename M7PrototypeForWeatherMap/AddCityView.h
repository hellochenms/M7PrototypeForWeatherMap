//
//  AddLocationView.h
//  M7PrototypeForWeatherMap
//
//  Created by Chen Meisong on 14-8-27.
//  Copyright (c) 2014年 chenms.m2. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "City.h"

typedef void (^ALVDidSelectCityHandler) (City *);

typedef enum {
    ALVAddViewTypeDisableUsedCity = 6000,
    ALVAddViewTypeEnableAllCity,
} ALVAddViewType;

@interface AddCityView : UIView
@property (nonatomic, copy) VoidEventHandler tapBackButtonHandler;
@property (nonatomic, copy) ALVDidSelectCityHandler addFinishHandler;
- (id)initWithFrame:(CGRect)frame type:(ALVAddViewType)type;
@end
