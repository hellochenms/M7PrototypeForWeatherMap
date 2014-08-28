//
//  AddLocationViewController.h
//  M7PrototypeForWeatherMap
//
//  Created by Chen Meisong on 14-8-27.
//  Copyright (c) 2014年 chenms.m2. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddLocationView.h"

@interface AddLocationViewController : UIViewController
@property (nonatomic, copy) ALVDidSelectCityHandler didSelectCityHandler;
@property (nonatomic, copy) VoidEventHandler dismissCompletionHandler;
- (id)initWithType:(ALVAddViewType)type;
@end
