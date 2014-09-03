//
//  DirectionManager.m
//  M7PrototypeForWeatherMap
//
//  Created by Chen Meisong on 14-8-26.
//  Copyright (c) 2014年 chenms.m2. All rights reserved.
//

#import "DirectionManager.h"

#import "City.h"

const NSString * const kDMDictKeySrcCity = @"SrcCity";
const NSString * const kDMDictKeyDestCity = @"DestCity";
const static NSInteger kCMUpdateTimeThreshold = 3;

@interface DirectionManager()
@property (nonatomic) NSMutableArray    *innerDirections;
@property (nonatomic) NSDate            *lastUpdateDate;
@property (nonatomic) NSTimer           *updateWeatherTimer;
@end

@implementation DirectionManager
+ (instancetype)sharedInstance{
    static DirectionManager *s_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        s_instance = [DirectionManager new];
    });
    
    return s_instance;
}

- (id)init{
    self = [super init];
    if (self) {
        _innerDirections = [NSMutableArray array];
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
        self.lastUpdateDate = [NSDate date];
    }
}

#pragma - setter/getter
- (NSArray *)directions{
    return [self.innerDirections copy];
}

#pragma mark -
- (void)requestDirectionWithSrcCity:(City *)srcCity
                           destCity:(City *)destCity
                  completionHandler:(DMDirectionCompletionHandler)completionHandler
                        failHandler:(DMDirectionFailHandler)failHandler{
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

#pragma mark - 路线
- (void)addDirection:(NSDictionary *)direction{
    __block NSDictionary *targetDirection = nil;
    [self.innerDirections enumerateObjectsUsingBlock:^(NSDictionary *aDirection, NSUInteger idx, BOOL *stop) {
        if ([[direction objectForKey:kDMDictKeySrcCity] isEqual:[aDirection objectForKey:kDMDictKeySrcCity]]
            && [[direction objectForKey:kDMDictKeyDestCity] isEqual:[aDirection objectForKey:kDMDictKeyDestCity]]) {
            targetDirection = aDirection;
            *stop = YES;
        }
    }];
    if (targetDirection) {
        [self.innerDirections removeObject:targetDirection];
    }
    [self.innerDirections insertObject:direction atIndex:0];
    self.defaultDirection = direction;
}
- (void)removeDirection:(NSDictionary *)direction{
    __block NSDictionary *targetDirection = nil;
    [self.innerDirections enumerateObjectsUsingBlock:^(NSDictionary *aDirection, NSUInteger idx, BOOL *stop) {
        if ([[direction objectForKey:kDMDictKeySrcCity] isEqual:[aDirection objectForKey:kDMDictKeySrcCity]]
            && [[direction objectForKey:kDMDictKeyDestCity] isEqual:[aDirection objectForKey:kDMDictKeyDestCity]]) {
            targetDirection = aDirection;
            *stop = YES;
        }
    }];
    if (targetDirection) {
        [self.innerDirections removeObject:targetDirection];
    }
    
    if (targetDirection == self.defaultDirection) {
        if ([self.innerDirections count] <= 0) {
            self.defaultDirection = nil;
        } else {
            self.defaultDirection = [self.innerDirections firstObject];
        }
    }
}

#pragma - _temp
- (void)_tempLoadDefaultDirections{
    // 北京-》广州
    NSMutableDictionary *direction = [NSMutableDictionary dictionary];
    City *city = [City new];
    city.name = @"北京市";
    city.latitude = 39.904667;
    city.longitude = 116.408198;
    city.address = @"北京市,北京市,中国";
    city.timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    [direction setObject:city forKey:kDMDictKeySrcCity];
    
    city = [City new];
    city.name = @"广州市";
    city.latitude = 23.129163;
    city.longitude = 113.264435;
    city.address = @"广州市,广东省,中国";
    city.timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    [direction setObject:city forKey:kDMDictKeyDestCity];
    
    [self.innerDirections addObject:direction];
    self.defaultDirection = direction;
}

@end
