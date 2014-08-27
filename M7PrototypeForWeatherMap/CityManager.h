//
//  CityManager.h
//  M7PrototypeForWeatherMap
//
//  Created by Chen Meisong on 14-8-26.
//  Copyright (c) 2014年 chenms.m2. All rights reserved.
//

#import <Foundation/Foundation.h>
@class City;

typedef void(^CMDirectionCompletionHandler)(NSArray *directionCities);
typedef void(^CMDirectionFailHandler)(NSError *error);

FOUNDATION_EXTERN const NSString * const kCMDictKeySrcCity;
FOUNDATION_EXTERN const NSString * const kCMDictKeyDestCity;

@interface CityManager : NSObject
@property (nonatomic, readonly) NSArray *cities;
@property (nonatomic)           NSArray *tempAroundCities;
@property (nonatomic, readonly) NSArray *directions;
+ (instancetype)sharedInstance;
- (void)addCity:(City *)city;
- (void)removeCity:(City *)city;
- (void)addDirection:(NSDictionary *)direction;
- (void)removeDirection:(NSDictionary *)direction;
- (void)requestDirectionWithSrcCity:(City *)srcCity destCity:(City *)destCity completionHandler:(CMDirectionCompletionHandler)completionHandler failHandler:(CMDirectionFailHandler)failHandler;
@end
