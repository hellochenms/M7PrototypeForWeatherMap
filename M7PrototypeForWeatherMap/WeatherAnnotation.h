//
//  WeatherAnnotation.h
//  M7PrototypeForWeatherMap
//
//  Created by Chen Meisong on 14-8-26.
//  Copyright (c) 2014年 chenms.m2. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "City.h"

@interface WeatherAnnotation : NSObject<MKAnnotation>
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic)           City    *city;
@property (nonatomic)           BOOL    isAround;
- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate;
@end
