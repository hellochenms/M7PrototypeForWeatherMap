//
//  HotCitiesConfig.m
//  M7PrototypeForWeatherMap
//
//  Created by Chen Meisong on 14-8-26.
//  Copyright (c) 2014年 chenms.m2. All rights reserved.
//

#import "HotCitiesConfig.h"
#import "City.h"

@interface HotCitiesConfig ()
@property (nonatomic) NSArray *fromJsonHotCities;
@property (nonatomic) NSArray *hotCities;
@end

@implementation HotCitiesConfig
+ (instancetype)sharedInstance{
    static HotCitiesConfig *s_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        s_instance = [HotCitiesConfig new];
    });
    
    return s_instance;
}

- (id)init{
    self = [super init];
    if (self) {
        NSData *hotCitiesJsonData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"hotcitiesConfigure" ofType:@"json"]];
        _fromJsonHotCities =  [NSJSONSerialization JSONObjectWithData:hotCitiesJsonData options:NSJSONReadingMutableContainers error:nil];
        
        NSArray *srcHotCities = _fromJsonHotCities;
        NSMutableArray *destHotCities = [NSMutableArray array];
        __block City *city = nil;
        [srcHotCities enumerateObjectsUsingBlock:^(NSDictionary *cityDic, NSUInteger idx, BOOL *stop) {
            city = [City new];
            city.name = [cityDic objectForKey:@"name"];
            city.address = [cityDic objectForKey:@"addr"];
            city.latitude = [[cityDic objectForKey:@"lat"] doubleValue];
            city.longitude = [[cityDic objectForKey:@"lng"] doubleValue];
            city.timeZone = [[NSTimeZone alloc] initWithName:[cityDic objectForKey:@"tz"]];
            [destHotCities addObject:city];
        }];
        _hotCities = destHotCities;
    }
    
    return self;
}

@end
