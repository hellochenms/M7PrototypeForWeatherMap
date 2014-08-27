//
//  LocationManageCell.h
//  M7PrototypeForWeatherMap
//
//  Created by Chen Meisong on 14-8-27.
//  Copyright (c) 2014年 chenms.m2. All rights reserved.
//

#import <UIKit/UIKit.h>
@class City;

@interface LocationManageCell : UITableViewCell
- (void)reloadData:(City *)city;
@end
