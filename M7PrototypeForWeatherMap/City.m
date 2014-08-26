//
//  City.m
//  M7PrototypeForWeatherMap
//
//  Created by Chen Meisong on 14-8-26.
//  Copyright (c) 2014年 chenms.m2. All rights reserved.
//

#import "City.h"

@implementation City
- (void)updateWeather{
    NSInteger temperature = arc4random() % 41 - 20;
    self.temperature = @(temperature);
    self.publishDate = [[NSDate date] dateByAddingTimeInterval:-60 * 5];
    self.updateDate = [NSDate date];
}
@end
