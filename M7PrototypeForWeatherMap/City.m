//
//  City.m
//  M7PrototypeForWeatherMap
//
//  Created by Chen Meisong on 14-8-26.
//  Copyright (c) 2014年 chenms.m2. All rights reserved.
//

#import "City.h"
#import <CoreLocation/CoreLocation.h>

@implementation City
- (void)updateWeather{
    NSInteger temperature = arc4random() % 41 - 20;
    self.temperature = @(temperature);
    self.publishDate = [[NSDate date] dateByAddingTimeInterval:-60 * 5];
    self.updateDate = [NSDate date];
}

#pragma mark - 
- (BOOL)isEqual:(id)object{
    if (!object || ![object isKindOfClass:[City class]]) {
        return NO;
    }
    City *city = (City *)object;
    if ([self.name isEqualToString:city.name]
        && [self.address isEqualToString:city.address]) {
        return YES;
    }
    
    return NO;
}

@end


@interface LocalCity ()<CLLocationManagerDelegate>
@property (nonatomic) CLLocationManager *locationManager;
@property (nonatomic) CLGeocoder    *geocoder;
@property (nonatomic) BOOL          isLocating;
@end
@implementation LocalCity
- (id)init{
    self = [super init];
    if (self) {
        _geocoder = [CLGeocoder new];
        
        _locationManager = [CLLocationManager new];
        _locationManager.distanceFilter = 500;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        
        [self reset];
        
        [self startLocate];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(onNotifyApplicationDidBecomeActive)
                                                     name:UIApplicationDidBecomeActiveNotification
                                                   object:nil];
    }
    
    return self;
}

- (void)startLocate{
    if (!self.isLocating && [CLLocationManager locationServicesEnabled]) {
        self.isLocating = YES;
        [self reset];
        
        self.locationManager.delegate = self;
        [self.locationManager startUpdatingLocation];
    }
}

- (void)reset{
    self.latitude = 90 + 1;
    self.longitude = 180 + 1;
    self.timeZone = [NSTimeZone systemTimeZone];
    self.name = @"自动定位";
    self.address = @"自动定位";
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager
	 didUpdateLocations:(NSArray *)locations{
    if ([locations count] <= 0) {
        return;
    }
#warning TODO:chenms:有使用缓存问题，需要检查时间戳；
    self.locationManager.delegate = nil;
    [self.locationManager stopUpdatingLocation];
    CLLocation *location = [locations lastObject];

    [self.geocoder reverseGeocodeLocation:location
                        completionHandler:^(NSArray *placemarks, NSError *error) {
                            if (error) {
                                NSLog(@"locate error(%@)  %s", error, __func__);
                                self.isLocating = NO;
                            } else {
                                CLLocationCoordinate2D coordinate = location.coordinate;
//                                // TODO:chenms:修正坐标
//                                NSLog(@"修正前：%.6f, %.6f  %s", location.coordinate.latitude, location.coordinate.longitude, __func__);
//                                CLLocationCoordinate2D coordinate = [self correctGpsLocation:CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)];
//                                NSLog(@"修正后：%.6f, %.6f  %s", coordinate.latitude, coordinate.longitude, __func__);
                                
                                self.latitude = coordinate.latitude;
                                self.longitude = coordinate.longitude;
                                CLPlacemark * placemark = placemarks.firstObject;
                                self.name = placemark.subLocality;
                                
                                NSMutableString * address = [NSMutableString string];
                                if ([placemark.subLocality length] > 0) {
                                    [address appendFormat:@",%@", placemark.subLocality];
                                }
                                if ([placemark.locality length] > 0) {
                                    [address appendFormat:@",%@", placemark.locality];
                                }
                                if ([placemark.administrativeArea length] > 0) {
                                    [address appendFormat:@",%@", placemark.administrativeArea];
                                }
                                if ([placemark.subAdministrativeArea length] > 0) {
                                    [address appendFormat:@",%@", placemark.subAdministrativeArea];
                                }
                                if ([placemark.country length] > 0) {
                                    [address appendFormat:@",%@", placemark.country];
                                }
                                self.address = [address stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@","]];
                                
                                self.isLocating = NO;
                                self.locateDate = [NSDate date];
                                
                                [self updateWeather];
                            }
                        }];
}

#pragma mark - 通知
- (void)onNotifyApplicationDidBecomeActive{
    [self startLocate];
}

#pragma mark - tools
// private GPS定位修正为火星坐标
- (CLLocationCoordinate2D)correctGpsLocation:(CLLocationCoordinate2D)location{
    
    NSString* latText = [NSString stringWithFormat:@"%.1f",location.latitude];
    NSString* lngText = [NSString stringWithFormat:@"%.1f",location.longitude];
    NSInteger latIndex = floorf([latText floatValue] * 10.0);
    NSInteger lngIndex = floorf([lngText floatValue] * 10.0);
    
    float offset_latitude,offset_longitude;
    offset_latitude = offset_longitude = 0.0;
    
    
    if(latIndex >= 182 && latIndex <= 535 && lngIndex >= 736 && lngIndex <= 1347)
        
    {
        
        NSInteger location = (latIndex - 182)*(lngIndex - 736) * 8;
        
        NSFileHandle* fileHandle = [NSFileHandle fileHandleForReadingAtPath:[[NSBundle mainBundle] pathForResource:@"gps2gmap" ofType:@"data"]];
        
        [fileHandle seekToFileOffset:location];
        
        NSData* oData = [fileHandle readDataOfLength:sizeof(float)*2];
        
        [fileHandle closeFile];
        
        
        [oData getBytes:&offset_latitude range:NSMakeRange(0, 4)];
        
        [oData getBytes:&offset_longitude range:NSMakeRange(4, 4)];
        
    }
    
    CLLocationCoordinate2D locationAfterCorrect = CLLocationCoordinate2DMake(location.latitude + offset_latitude, location.longitude + offset_longitude);
    
    return locationAfterCorrect;
}

#pragma mark - dealloc
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.locationManager.delegate = nil;
    [self.locationManager stopUpdatingLocation];
}

@end
