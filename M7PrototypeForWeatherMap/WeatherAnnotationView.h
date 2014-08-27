//
//  WeatherAnnotationView.h
//  M7PrototypeForWeatherMap
//
//  Created by Chen Meisong on 14-8-26.
//  Copyright (c) 2014年 chenms.m2. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "City.h"
#import "WeatherAnnotation.h"

@interface WeatherAnnotationView : MKAnnotationView
- (void)reloadData:(City *)city cityType:(WACityType)cityType;
@end
