//
//  CityManager.h
//  M7PrototypeForWeatherMap
//
//  Created by Chen Meisong on 14-8-26.
//  Copyright (c) 2014年 chenms.m2. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CityManager : NSObject
@property (nonatomic, readonly) NSArray *cities;
@property (nonatomic)           NSArray *tempAroundCities;
+ (instancetype)sharedInstance;
@end
