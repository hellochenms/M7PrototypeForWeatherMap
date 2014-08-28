//
//  City.h
//  M7PrototypeForWeatherMap
//
//  Created by Chen Meisong on 14-8-26.
//  Copyright (c) 2014年 chenms.m2. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface City : NSObject
@property (nonatomic)       double      latitude;
@property (nonatomic)       double      longitude;
@property (nonatomic, copy) NSString    *name;
@property (nonatomic, copy) NSString    *address;
@property (nonatomic)       NSDate      *publishDate;
@property (nonatomic)       NSDate      *updateDate;
@property (nonatomic)       NSNumber    *temperature;
@property (nonatomic)       NSTimeZone  *timeZone;
@property (nonatomic)       NSArray     *aroundCities;
- (void)updateWeather;
@end

@interface LocalCity : City
@property (nonatomic)       NSDate      *locateDate;
@end
