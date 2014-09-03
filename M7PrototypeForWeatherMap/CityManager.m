//
//  CityManager.m
//  M7PrototypeForWeatherMap
//
//  Created by Chen Meisong on 14-8-26.
//  Copyright (c) 2014年 chenms.m2. All rights reserved.
//

#import "CityManager.h"
#import "City.h"

const static NSInteger kCMUpdateTimeThreshold = 3;

@interface CityManager()
@property (nonatomic) NSMutableArray    *innerCities;
@property (nonatomic) NSDate            *lastUpdateDate;
@property (nonatomic) NSTimer           *updateWeatherTimer;
@end

@implementation CityManager
+ (instancetype)sharedInstance{
    static CityManager *s_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        s_instance = [CityManager new];
    });
    
    return s_instance;
}

- (id)init{
    self = [super init];
    if (self) {
        _innerCities = [NSMutableArray array];
        [self _tempLoadDefaultCities];//TODO:!
        [self handlerAfterInit];
    }
    
    return self;
}

- (void)handlerAfterInit{
    _updateWeatherTimer = [NSTimer scheduledTimerWithTimeInterval:1
                                                           target:self
                                                         selector:@selector(onWeatherTimerFire)
                                                         userInfo:nil
                                                          repeats:YES];
}

#pragma mark - update weather timer
- (void)onWeatherTimerFire{
    if (!self.lastUpdateDate || [[NSDate date] timeIntervalSinceDate:self.lastUpdateDate] > kCMUpdateTimeThreshold) {
        for (City *city in self.cities) {
            [city updateWeather];
        }
        self.lastUpdateDate = [NSDate date];
    }
}

#pragma - setter/getter
- (NSArray *)cities{
    return [self.innerCities copy];
}

- (void)setTempAroundCities:(NSArray *)tempAroundCities{
    _tempAroundCities = tempAroundCities;
    for (City *city in _tempAroundCities) {
        [city updateWeather];
    }
}

#pragma mark - 城市
- (void)addCity:(City *)city{
    __block BOOL isExits = NO;
    [self.innerCities enumerateObjectsUsingBlock:^(City *aCity, NSUInteger idx, BOOL *stop) {
        if ([aCity isEqual:city]) {
            isExits = YES;
            *stop = YES;
        }
    }];
    [self.innerCities addObject:city];
    self.defaultCity = city;
}
- (void)removeCity:(City *)city{
    [self.innerCities removeObject:city];
    if (city == self.defaultCity) {
        if ([self.innerCities count] <= 0) {
            self.defaultCity = nil;
        } else {
            self.defaultCity = [self.innerCities firstObject];
        }
    }
}

#pragma - _temp
- (void)_tempLoadDefaultCities{
    LocalCity *localCity = [LocalCity new];
    [self.innerCities addObject:localCity];
    
    // 北京
    City *city = [City new];
    NSMutableArray *aroundCities = [NSMutableArray array];
    City *aroundCity = [City new];
    city.name = @"北京";
    city.latitude = 39.904667;
    city.longitude = 116.408198;
    city.timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    
    aroundCity = [City new];
    aroundCity.name = @"太原";
    aroundCity.latitude = 37.870662;
    aroundCity.longitude = 112.550619;
    aroundCity.timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    [aroundCities addObject:aroundCity];
    
    aroundCity = [City new];
    aroundCity.name = @"济南";
    aroundCity.latitude = 36.665282;
    aroundCity.longitude = 116.994917;
    aroundCity.timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    [aroundCities addObject:aroundCity];
    
    city.aroundCities = [aroundCities copy];
    [self.innerCities addObject:city];
    
    
    // 上海
    city = [City new];
    aroundCities = [NSMutableArray array];
    city.name = @"上海";
    city.latitude = 31.230708;
    city.longitude = 121.472916;
    city.timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    
    aroundCity = [City new];
    aroundCity.name = @"南京";
    aroundCity.latitude = 32.060254;
    aroundCity.longitude = 118.796877;
    aroundCity.timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    [aroundCities addObject:aroundCity];
    
    city.aroundCities = [aroundCities copy];
    [self.innerCities addObject:city];
    
    
    // 广州
    city = [City new];
    aroundCities = [NSMutableArray array];
    city.name = @"广州";
    city.latitude = 23.129163;
    city.longitude = 113.264435;
    city.timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    
    aroundCity = [City new];
    aroundCity.name = @"长沙";
    aroundCity.latitude = 28.228209;
    aroundCity.longitude = 112.938814;
    aroundCity.timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    [aroundCities addObject:aroundCity];
    
    city.aroundCities = [aroundCities copy];
    [self.innerCities addObject:city];
    
    self.defaultCity = localCity;
}

@end
