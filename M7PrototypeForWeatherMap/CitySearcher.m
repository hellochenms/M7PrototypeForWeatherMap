//
//  CitySearcher.m
//  M7PrototypeForWeatherMap
//
//  Created by Chen Meisong on 14-8-26.
//  Copyright (c) 2014年 chenms.m2. All rights reserved.
//


#import "CitySearcher.h"
#import "City.h"
#import "HotCitiesConfig.h"

@interface CitySearcher()
@property (nonatomic) NSArray *cities;
@end

@implementation CitySearcher
+ (instancetype)sharedInstance{
    static CitySearcher *s_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        s_instance = [CitySearcher new];
    });
    
    return s_instance;
}

- (id)init{
    self = [super init];
    if (self) {
        _cities = [HotCitiesConfig sharedInstance].fromJsonHotCities;
    }
    
    return self;
}

- (NSArray *)searchForKeyword:(NSString *)keyword{
    if ([keyword length] <= 0) {
        return nil;
    }
    
    keyword = [keyword stringByReplacingOccurrencesOfString:@"\\s" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, keyword.length)];
    keyword = [keyword lowercaseString];
    
    NSMutableArray *results = [NSMutableArray array];
    __block City *city = nil;
    [self.cities enumerateObjectsUsingBlock:^(NSDictionary *cityDic, NSUInteger idx, BOOL *stop) {
        BOOL isResult = NO;
        NSRange range = [[cityDic objectForKey:@"name"] rangeOfString:keyword options:NSAnchoredSearch];
        if (range.location != NSNotFound) {
            isResult = YES;
        } else {
            NSRange range = [[cityDic objectForKey:@"pinyin"] rangeOfString:keyword options:NSAnchoredSearch];
            if (range.location != NSNotFound) {
                isResult = YES;
            } else {
                NSRange range = [[cityDic objectForKey:@"py"] rangeOfString:keyword options:NSAnchoredSearch];
                if (range.location != NSNotFound) {
                    isResult = YES;
                }
            }
        }
        
        if (isResult) {
            city = [City new];
            city.name = [cityDic objectForKey:@"name"];
            [results addObject:city];
        }
    }];
    
    return ([results count] > 0 ? [results copy] : nil);
}

@end
