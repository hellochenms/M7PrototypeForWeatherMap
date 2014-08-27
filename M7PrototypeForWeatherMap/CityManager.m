//
//  CityManager.m
//  M7PrototypeForWeatherMap
//
//  Created by Chen Meisong on 14-8-26.
//  Copyright (c) 2014年 chenms.m2. All rights reserved.
//

#import "CityManager.h"
#import "City.h"

const NSString * const kCMDictKeySrcCity = @"SrcCity";
const NSString * const kCMDictKeyDestCity = @"DestCity";
const static NSInteger kCMUpdateTimeThreshold = 3;

@interface CityManager()
@property (nonatomic) NSMutableArray    *innerCities;
@property (nonatomic) NSMutableArray    *innerDirections;
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
        _innerDirections = [NSMutableArray array];
        [self _tempLoadDefaultCities];//TODO:!
        [self _tempLoadDefaultDirections];//TODO:!
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

- (NSArray *)directions{
    return [self.innerDirections copy];
}

- (void)setTempAroundCities:(NSArray *)tempAroundCities{
    _tempAroundCities = tempAroundCities;
    for (City *city in _tempAroundCities) {
        [city updateWeather];
    }
}

#pragma mark -
- (void)requestDirectionWithSrcCity:(City *)srcCity
                           destCity:(City *)destCity
                  completionHandler:(CMDirectionCompletionHandler)completionHandler
                        failHandler:(CMDirectionFailHandler)failHandler{
    NSMutableArray *directionCities = [NSMutableArray array];
    
    City *city = [City new];
    city.name = @"太原";
    city.latitude = 37.870662;
    city.longitude = 112.550619;
    city.timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    [directionCities addObject:city];
    
    city = [City new];
    city.name = @"济南";
    city.latitude = 36.665282;
    city.longitude = 116.994917;
    city.timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    [directionCities addObject:city];
    
    city = [City new];
    city.name = @"上海";
    city.latitude = 31.230708;
    city.longitude = 121.472916;
    city.timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    [directionCities addObject:city];
    
    city = [City new];
    city.name = @"南京";
    city.latitude = 32.060254;
    city.longitude = 118.796877;
    city.timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    [directionCities addObject:city];
    
    city = [City new];
    city.name = @"长沙";
    city.latitude = 28.228209;
    city.longitude = 112.938814;
    city.timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    [directionCities addObject:city];
    
    if (completionHandler) {
        completionHandler(directionCities);
    }
}

#pragma - _temp
- (void)_tempLoadDefaultCities{
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
}

- (void)_tempLoadDefaultDirections{
    // 北京-》广州
    NSMutableDictionary *direction = [NSMutableDictionary dictionary];
    City *city = [City new];
    city.name = @"北京";
    city.latitude = 39.904667;
    city.longitude = 116.408198;
    city.timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    [direction setObject:city forKey:kCMDictKeySrcCity];
    
    city = [City new];
    city.name = @"广州";
    city.latitude = 23.129163;
    city.longitude = 113.264435;
    city.timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    [direction setObject:city forKey:kCMDictKeyDestCity];
    
    [self.innerDirections addObject:direction];
}



@end
