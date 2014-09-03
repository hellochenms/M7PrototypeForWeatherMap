//
//  DirectionManager.h
//  M7PrototypeForWeatherMap
//
//  Created by Chen Meisong on 14-8-26.
//  Copyright (c) 2014年 chenms.m2. All rights reserved.
//

#import <Foundation/Foundation.h>
@class City;

typedef void(^DMDirectionCompletionHandler)(NSArray *directionCities);
typedef void(^DMDirectionFailHandler)(NSError *error);

FOUNDATION_EXTERN const NSString * const kDMDictKeySrcCity;
FOUNDATION_EXTERN const NSString * const kDMDictKeyDestCity;

@interface DirectionManager : NSObject
@property (nonatomic, readonly) NSArray *directions;
@property (nonatomic)           NSDictionary *defaultDirection;
+ (instancetype)sharedInstance;
- (void)addDirection:(NSDictionary *)direction;
- (void)removeDirection:(NSDictionary *)direction;
- (void)requestDirectionWithSrcCity:(City *)srcCity destCity:(City *)destCity completionHandler:(DMDirectionCompletionHandler)completionHandler failHandler:(DMDirectionFailHandler)failHandler;
@end
