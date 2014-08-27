//
//  LocationView.m
//  M7PrototypeForWeatherMap
//
//  Created by Chen Meisong on 14-8-26.
//  Copyright (c) 2014年 chenms.m2. All rights reserved.
//

#import "LocationView.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "CityManager.h"
#import "WeatherAnnotation.h"
#import "WeatherAnnotationView.h"
#import "DetailInfoView.h"

@interface LocationView()<MKMapViewDelegate>
@property (nonatomic) MKMapView         *mapView;
@property (nonatomic) DetailInfoView    *detailView;
@property (nonatomic) NSMutableArray    *annos;
@property (nonatomic) NSMutableArray    *aroundAnnos;
@property (nonatomic) City              *lastSelectedCity;
@end

@implementation LocationView
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _annos = [NSMutableArray array];
        _aroundAnnos = [NSMutableArray array];
        
        self.backgroundColor = [UIColor orangeColor];//TODO:!
        
        _mapView = [[MKMapView alloc] initWithFrame:self.bounds];
        CLLocationCoordinate2D defalutMapCenter = CLLocationCoordinate2DMake(kGlobal_defaultMapCenter_lat, kGlobal_defaultMapCenter_long);
        _mapView.region = MKCoordinateRegionMake(defalutMapCenter, MKCoordinateSpanMake(kGlobal_defaultMapDelta, kGlobal_defaultMapDelta));
        _mapView.delegate = self;
        [self addSubview:_mapView];
        
        _detailView = [[DetailInfoView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.bounds), CGRectGetWidth(self.bounds), 200) aroundEnabled:YES];
        __weak typeof(self) weakSelf = self;
        _detailView.tapHideButtonHandler = ^{
            [weakSelf hideDetailView];
        };
        _detailView.tapAroundButtonHandler = ^(BOOL isShowingAroud, City *city){
            if (isShowingAroud) {
                [weakSelf reloadAroundCities:city.aroundCities];
            } else {
                [weakSelf reloadAroundCities:nil];
            }
        };
        [self addSubview:_detailView];
        
        [self reloadData];
    }
    
    return self;
}

#pragma mark - reload Data
- (void)reloadData{
    [self.mapView removeAnnotations:self.annos];
    [self.annos removeAllObjects];
    WeatherAnnotation *anno = nil;
    for (City *city in [CityManager sharedInstance].cities) {
        anno = [[WeatherAnnotation alloc] initWithCoordinate:CLLocationCoordinate2DMake(city.latitude, city.longitude)];
        anno.city = city;
        anno.cityType = WACityTypeNormal;
        [self.annos addObject:anno];
    }
    [self.mapView addAnnotations:self.annos];
}

- (void)reloadAroundCities:(NSArray *)cities{
    [self.mapView removeAnnotations:self.aroundAnnos];
    [self.aroundAnnos removeAllObjects];
    WeatherAnnotation *anno = nil;
    for (City *city in cities) {
        anno = [[WeatherAnnotation alloc] initWithCoordinate:CLLocationCoordinate2DMake(city.latitude, city.longitude)];
        anno.city = city;
        anno.isAround = YES;
        anno.cityType = WACityTypeAround;
        [self.aroundAnnos addObject:anno];
    }
    if ([self.aroundAnnos count] > 0) {
        [self.mapView addAnnotations:self.aroundAnnos];
    }
    
    [CityManager sharedInstance].tempAroundCities = [cities copy];
}

#pragma mark - MKMapViewDelegate
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation{
    static NSString *cityAnnoCellIdentifier = @"cityAnnoCellIdentifier";
    if ([annotation isKindOfClass:[WeatherAnnotation class]]) {
        WeatherAnnotationView * annoView = (WeatherAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:cityAnnoCellIdentifier];
        if (!annoView) {
            annoView = [[WeatherAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:cityAnnoCellIdentifier];
        }
        annoView.annotation = annotation;
        [annoView reloadData:((WeatherAnnotation *)annotation).city cityType:((WeatherAnnotation *)annotation).cityType];
        
        return annoView;
    }
    
    return nil;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view{
    if ([view isKindOfClass:[WeatherAnnotationView class]]) {//TODO:!
        WeatherAnnotation *anno = (WeatherAnnotation *)view.annotation;
        if (!anno.isAround && self.lastSelectedCity != anno.city) {
            [self reloadAroundCities:nil];
            [self.detailView hideAround];//TODO:!
            self.lastSelectedCity = anno.city;
        }
        City *city = ((WeatherAnnotation *)view.annotation).city;
        [self showDetailViewWithCity:city isAround:anno.isAround];
    }
}

#pragma mark - detail view
- (void)showDetailViewWithCity:(City *)city isAround:(BOOL)isAround{
    [self.detailView reloadData:city isAround:isAround];
    if (CGRectGetMinY(self.detailView.frame) + 0.5 >= CGRectGetHeight(self.bounds)) {
        __weak typeof(self) weakSelf = self;
        CGRect detailFrame = self.detailView.frame;
        detailFrame.origin.y = CGRectGetHeight(self.bounds) - CGRectGetHeight(self.detailView.bounds);
        [UIView animateWithDuration:0.25
                         animations:^{
                             weakSelf.detailView.frame = detailFrame;
                         }];
    }
}
- (void)hideDetailView{
    __weak typeof(self) weakSelf = self;
    CGRect detailFrame = self.detailView.frame;
    detailFrame.origin.y = CGRectGetHeight(self.bounds);
    [UIView animateWithDuration:0.25
                     animations:^{
                         weakSelf.detailView.frame = detailFrame;
                     } completion:^(BOOL finished) {
                         [weakSelf.detailView clearData];
                         [self.mapView selectAnnotation:nil animated:NO];
                     }];
}


@end
