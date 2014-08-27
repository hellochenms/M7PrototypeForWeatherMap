//
//  CitySearcher.h
//  M7PrototypeForWeatherMap
//
//  Created by Chen Meisong on 14-8-26.
//  Copyright (c) 2014年 chenms.m2. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CitySearcher : NSObject
+ (instancetype)sharedInstance;
- (NSArray *)searchForKeyword:(NSString *)keyword;
@end
