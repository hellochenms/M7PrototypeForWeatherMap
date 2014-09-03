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

typedef enum {
    WACityTypeNormal = 6000,
    WACityTypeAround,
    WACityTypeSrc,
    WACityTypeDest,
    WACityTypeDirectionPoint,
    WACityTypeLocate,
} WACityType;

@interface WeatherAnnotation : NSObject<MKAnnotation>
@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic)           City        *city;
@property (nonatomic)           BOOL        isAround;
@property (nonatomic)           WACityType  cityType;
- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate;
- (void)setupCoordinate:(CLLocationCoordinate2D)coordinate;
@end
