//
//  DirectionView.m
//  M7PrototypeForWeatherMap
//
//  Created by Chen Meisong on 14-8-26.
//  Copyright (c) 2014年 chenms.m2. All rights reserved.
//

#import "DirectionView.h"
#import <MapKit/MapKit.h>
#import "DetailInfoView.h"
#import "CityManager.h"
#import "WeatherAnnotation.h"
#import "WeatherAnnotationView.h"


@interface DirectionView()<MKMapViewDelegate>
@property (nonatomic) MKMapView         *mapView;
@property (nonatomic) DetailInfoView    *detailView;
@property (nonatomic) WeatherAnnotation *srcAnno;
@property (nonatomic) WeatherAnnotation *destAnno;
@property (nonatomic) NSMutableArray    *directionAnnos;
@property (nonatomic) MKPolyline        *line;
@end

@implementation DirectionView
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _directionAnnos = [NSMutableArray array];
        
        self.backgroundColor = [UIColor brownColor];//TODO:!
        
        _mapView = [[MKMapView alloc] initWithFrame:self.bounds];
        CLLocationCoordinate2D defalutMapCenter = CLLocationCoordinate2DMake(kGlobal_defaultMapCenter_lat, kGlobal_defaultMapCenter_long);
        _mapView.region = MKCoordinateRegionMake(defalutMapCenter, MKCoordinateSpanMake(kGlobal_defaultMapDelta, kGlobal_defaultMapDelta));
        _mapView.delegate = self;
        [self addSubview:_mapView];
        
        _detailView = [[DetailInfoView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.bounds), CGRectGetWidth(self.bounds), 200) aroundEnabled:NO];
        __weak typeof(self) weakSelf = self;
        _detailView.tapHideButtonHandler = ^{
            [weakSelf hideDetailView];
        };
        [self addSubview:_detailView];
        
        [self reloadData];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(onNotifyRemoveDirection)
                                                     name:kGlobal_NotificationName_RemoveDirection
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(onNotifyAddDirection)
                                                     name:kGlobal_NotificationName_AddDirection
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(onNotifyChangeDefaultDirection)
                                                     name:kGlobal_NotificationName_ChangeDefaultDirection
                                                   object:nil];
        
        
    }
    
    return self;
}

#pragma mark - reload Data
- (void)reloadData{
    [self.mapView removeAnnotation:self.srcAnno];
    self.srcAnno = nil;
    [self.mapView removeAnnotation:self.destAnno];
    self.destAnno = nil;
    [self.mapView removeAnnotations:self.directionAnnos];
    [self.directionAnnos removeAllObjects];
    [self.mapView removeOverlay:self.line];
    self.line = nil;
    
#warning TODO:chenms:测试逻辑
    if ([[CityManager sharedInstance].directions count] <= 0) {
        return;
    }
    NSDictionary *directionSrcDest = [CityManager sharedInstance].defaultDirection;

    City *srcCity = [directionSrcDest objectForKey:kCMDictKeySrcCity];
    [srcCity updateWeather];
    self.srcAnno = [[WeatherAnnotation alloc] initWithCoordinate:CLLocationCoordinate2DMake(srcCity.latitude, srcCity.longitude)];
    self.srcAnno.city = srcCity;
    self.srcAnno.cityType = WACityTypeSrc;
    [self.mapView addAnnotation:self.srcAnno];
    City *destCity = [directionSrcDest objectForKey:kCMDictKeyDestCity];
    [destCity updateWeather];
    self.destAnno = [[WeatherAnnotation alloc] initWithCoordinate:CLLocationCoordinate2DMake(destCity.latitude, destCity.longitude)];
    self.destAnno.city = destCity;
    self.destAnno.cityType = WACityTypeDest;
    [self.mapView addAnnotation:self.destAnno];
    
    __weak typeof(self) weakSelf = self;
    [[CityManager sharedInstance] requestDirectionWithSrcCity:srcCity
                                                     destCity:destCity
                                            completionHandler:^(NSArray *directionCities) {
                                                [weakSelf reloadDirection:directionCities];
                                            } failHandler:^(NSError *error) {
                                                NSLog(@"error(%@)  %s", error, __func__);
                                            }];
}

- (void)reloadDirection:(NSArray *)directionCities{
    WeatherAnnotation *anno = nil;
    NSInteger directionPointCount = [directionCities count];
    MKMapPoint points[directionPointCount + 2];
    points[0] = MKMapPointForCoordinate(CLLocationCoordinate2DMake(self.srcAnno.city.latitude, self.srcAnno.city.longitude));
    City *city = nil;
    for (NSInteger i = 0; i < directionPointCount; i++) {
        city = [directionCities objectAtIndex:i];
        [city updateWeather];
        anno = [[WeatherAnnotation alloc] initWithCoordinate:CLLocationCoordinate2DMake(city.latitude, city.longitude)];
        anno.city = city;
        anno.cityType = WACityTypeDirectionPoint;
        [self.directionAnnos addObject:anno];
        points[i + 1] =  MKMapPointForCoordinate(CLLocationCoordinate2DMake(city.latitude, city.longitude));
    }
    points[directionPointCount + 1] = MKMapPointForCoordinate(CLLocationCoordinate2DMake(self.destAnno.city.latitude, self.destAnno.city.longitude));
    self.line = [MKPolyline polylineWithPoints:points count:directionPointCount + 2];
    [self.mapView addOverlay:self.line];
    [self.mapView addAnnotations:self.directionAnnos];
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
        City *city = ((WeatherAnnotation *)view.annotation).city;
        [self showDetailViewWithCity:city isAround:anno.isAround];
    }
}
#warning TODO: DEPRECATED
- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay NS_DEPRECATED_IOS(4_0, 7_0){
    MKPolylineView *lineView = [[MKPolylineView alloc] initWithOverlay:overlay];
    lineView.strokeColor = [UIColor blueColor];
    lineView.lineWidth = 10;

    return lineView;
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

#pragma mark - 通知
- (void)onNotifyRemoveDirection{
    [self reloadData];
}
- (void)onNotifyAddDirection{
    [self reloadData];
}
- (void)onNotifyChangeDefaultDirection{
    [self reloadData];
}

#pragma mark - dealloc
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
