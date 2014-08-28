//
//  WeatherAnnotationView.m
//  M7PrototypeForWeatherMap
//
//  Created by Chen Meisong on 14-8-26.
//  Copyright (c) 2014年 chenms.m2. All rights reserved.
//

#import "WeatherAnnotationView.h"
#import "WeatherAnnotation.h"

@interface WeatherAnnotationView()
@property (nonatomic) UILabel   *nameLabel;
@property (nonatomic) UILabel   *temperatureLabel;
@property (nonatomic) City      *city;
@end

@implementation WeatherAnnotationView
- (id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        CGRect frame = self.frame;
        frame.size.width = 30;
        frame.size.height = 30;
        self.frame = frame;
        
        _temperatureLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, 15)];
        _temperatureLabel.textAlignment = NSTextAlignmentCenter;
        _temperatureLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:_temperatureLabel];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, 30, 15)];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.font = [UIFont systemFontOfSize:10];
        [self addSubview:_nameLabel];
    }
    
    return self;
}

#pragma mark - reload Data
- (void)reloadData:(City *)city cityType:(WACityType)cityType{
    [self.city removeObserver:self forKeyPath:@"updateDate"];
    [self.city removeObserver:self forKeyPath:@"name"];
    self.city = city;
    [self.city addObserver:self
                forKeyPath:@"updateDate"
                   options:NSKeyValueObservingOptionNew
                   context:nil];
    [self.city addObserver:self
                forKeyPath:@"name"
                   options:NSKeyValueObservingOptionNew
                   context:nil];
    [self refreshUI];
    [self refreshColorWithCityType:cityType];
}

- (void)refreshUI{
    self.nameLabel.text = self.city.name;
    self.temperatureLabel.text = (self.city.temperature ? [NSString stringWithFormat:@"%d", [self.city.temperature integerValue]] : @"-");
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if ([keyPath isEqualToString:@"updateDate"]) {
        [self refreshUI];
    } else if ([keyPath isEqualToString:@"name"]) {
        self.nameLabel.text = self.city.name;
    }
}

#pragma mark - tools
- (void)refreshColorWithCityType:(WACityType)cityType{
    UIColor *temperatureColor = nil;
    UIColor *nameColor = nil;
    switch (cityType) {
        case WACityTypeNormal:{
            temperatureColor = [UIColor redColor];
            nameColor = [UIColor blueColor];
            break;
        }
        case WACityTypeAround:{
            temperatureColor = [UIColor orangeColor];
            nameColor = [UIColor brownColor];
            break;
        }
        case WACityTypeSrc:{
            temperatureColor = [UIColor redColor];
            nameColor = [UIColor lightGrayColor];
            break;
        }
        case WACityTypeDest:{
            temperatureColor = [UIColor blueColor];
            nameColor = [UIColor lightGrayColor];
            break;
        }
        case WACityTypeDirectionPoint:{
            temperatureColor = [UIColor orangeColor];
            nameColor = [UIColor brownColor];
            break;
        }
        case WACityTypeLocate:{
            temperatureColor = [UIColor yellowColor];
            nameColor = [UIColor greenColor];
            break;
        }
        default:
            break;
    }
    
    self.temperatureLabel.backgroundColor = temperatureColor;
    self.nameLabel.backgroundColor = nameColor;
}

#pragma mark - dealloc
- (void)dealloc{
    [self.city removeObserver:self forKeyPath:@"updateDate"];
    [self.city removeObserver:self forKeyPath:@"name"];
}

@end
