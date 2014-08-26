//
//  DetailInfoView.h
//  M7PrototypeForWeatherMap
//
//  Created by Chen Meisong on 14-8-26.
//  Copyright (c) 2014年 chenms.m2. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "City.h"

typedef void(^DIVTapAroundButtonHandler)(BOOL, City*);

@interface DetailInfoView : UIView
@property (nonatomic, copy) VoidEventHandler            tapHideButtonHandler;
@property (nonatomic, copy) DIVTapAroundButtonHandler   tapAroundButtonHandler;
- (void)hideAround;
- (void)reloadData:(City *)city isAround:(BOOL)isAround;
- (void)clearData;
@end
