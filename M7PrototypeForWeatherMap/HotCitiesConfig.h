//
//  HotCitiesConfig.h
//  M7PrototypeForWeatherMap
//
//  Created by Chen Meisong on 14-8-26.
//  Copyright (c) 2014年 chenms.m2. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HotCitiesConfig : NSObject
+ (instancetype)sharedInstance;
@property (nonatomic, readonly) NSArray *fromJsonHotCities;
@property (nonatomic, readonly) NSArray *hotCities;

@end
