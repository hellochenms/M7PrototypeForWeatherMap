//
//  DetailInfoView.m
//  M7PrototypeForWeatherMap
//
//  Created by Chen Meisong on 14-8-26.
//  Copyright (c) 2014年 chenms.m2. All rights reserved.
//

#import "DetailInfoView.h"

const static double kAroundViewHeight = 104;

@interface DetailInfoView()
@property (nonatomic) UIScrollView *scrollView;
@property (nonatomic) City      *city;
@property (nonatomic) UILabel   *nameLabel;
@property (nonatomic) UILabel   *temperatureLabel;
@property (nonatomic) UILabel   *publishDateLabel;
@property (nonatomic) UIButton  *aroundButton;
@property (nonatomic) BOOL      isShowingAroundInMap;
@property (nonatomic) BOOL      isShowingAroundDetail;
@property (nonatomic) City      *aroundCity;
@property (nonatomic) UIView    *aroundView;
@property (nonatomic) UILabel   *aroundNameLabel;
@property (nonatomic) UILabel   *aroundTemperatureLabel;
@property (nonatomic) UILabel   *aroundPublishDateLabel;
@property (nonatomic) CGRect    aroundViewOriginFrame;
@property (nonatomic) UILabel   *belowAroundArea;
@property (nonatomic) BOOL      aroundEnabled;
@end

@implementation DetailInfoView
- (id)initWithFrame:(CGRect)frame{
    return [self initWithFrame:frame aroundEnabled:YES];
}
- (id)initWithFrame:(CGRect)frame aroundEnabled:(BOOL)aroundEnabled{
    self = [super initWithFrame:frame];
    if (self) {
        _aroundEnabled = aroundEnabled;
        
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];//TODO:!
        
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        [self addSubview:_scrollView];
        
        // 城市名
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
        _nameLabel.backgroundColor = [UIColor clearColor];
        _nameLabel.font = [UIFont systemFontOfSize:16];
        _nameLabel.textColor = [UIColor whiteColor];
        [_scrollView addSubview:_nameLabel];
        
        if (aroundEnabled) {
            _aroundButton = [UIButton buttonWithType:UIButtonTypeCustom];
            _aroundButton.frame = CGRectMake(200, 0, 66, 44);
            [_aroundButton setTitle:@"显示周边" forState:UIControlStateNormal];
            _aroundButton.titleLabel.font = [UIFont systemFontOfSize:16];
            [_aroundButton addTarget:self action:@selector(onTapAroundButton) forControlEvents:UIControlEventTouchUpInside];
            [_scrollView addSubview:_aroundButton];
        }
        
        
        // 关闭按钮
        UIButton *hideButton = [UIButton buttonWithType:UIButtonTypeCustom];
        hideButton.frame = CGRectMake(CGRectGetWidth(self.bounds) - 44, 0, 44, 44);
        [hideButton setTitle:@"关闭" forState:UIControlStateNormal];
        hideButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [hideButton addTarget:self action:@selector(onTapHideButton) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:hideButton];
        
        // 温度
        _temperatureLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_nameLabel.frame), CGRectGetWidth(self.bounds), 30)];
        _temperatureLabel.backgroundColor = [UIColor clearColor];
        _temperatureLabel.font = [UIFont systemFontOfSize:16];
        _temperatureLabel.textColor = [UIColor whiteColor];
        [_scrollView addSubview:_temperatureLabel];
        
        // 发布时间
        _publishDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_temperatureLabel.frame), CGRectGetWidth(self.bounds), 30)];
        _publishDateLabel.backgroundColor = [UIColor clearColor];
        _publishDateLabel.font = [UIFont systemFontOfSize:14];
        _publishDateLabel.textColor = [UIColor whiteColor];
        [_scrollView addSubview:_publishDateLabel];
        
        if (aroundEnabled) {
            // 周边城市
            _aroundView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_publishDateLabel.frame), CGRectGetWidth(self.bounds), 0)];
            self.aroundViewOriginFrame = _aroundView.frame;
            _aroundView.clipsToBounds = YES;
            [_scrollView addSubview:_aroundView];
            
            // 城市名
            _aroundNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
            _aroundNameLabel.backgroundColor = [UIColor clearColor];
            _aroundNameLabel.font = [UIFont systemFontOfSize:16];
            _aroundNameLabel.textColor = [UIColor whiteColor];
            [_aroundView addSubview:_aroundNameLabel];
            
            // 温度
            _aroundTemperatureLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_aroundNameLabel.frame), CGRectGetWidth(self.bounds), 30)];
            _aroundTemperatureLabel.backgroundColor = [UIColor clearColor];
            _aroundTemperatureLabel.font = [UIFont systemFontOfSize:16];
            _aroundTemperatureLabel.textColor = [UIColor whiteColor];
            [_aroundView addSubview:_aroundTemperatureLabel];
            
            // 发布时间
            _aroundPublishDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_aroundTemperatureLabel.frame), CGRectGetWidth(self.bounds), 30)];
            _aroundPublishDateLabel.backgroundColor = [UIColor clearColor];
            _aroundPublishDateLabel.font = [UIFont systemFontOfSize:14];
            _aroundPublishDateLabel.textColor = [UIColor whiteColor];
            [_aroundView addSubview:_aroundPublishDateLabel];
        }
        
        // 其他
        _belowAroundArea = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(aroundEnabled ? _aroundView.frame : _publishDateLabel.frame), CGRectGetWidth(self.bounds), 200)];
        _belowAroundArea.backgroundColor = [UIColor blueColor];
        _belowAroundArea.font = [UIFont systemFontOfSize:16];
        _belowAroundArea.textColor = [UIColor whiteColor];
        [_scrollView addSubview:_belowAroundArea];
        
        //
        _scrollView.contentSize = CGSizeMake(CGRectGetWidth(_scrollView.bounds), CGRectGetMaxY(_belowAroundArea.frame));
    }

    return self;
}

#pragma mark - reload Data
- (void)reloadData:(City *)city isAround:(BOOL)isAround{
    if (!isAround) {
        [self.city removeObserver:self forKeyPath:@"updateDate"];
        self.city = city;
        [self.city addObserver:self
                    forKeyPath:@"updateDate"
                       options:NSKeyValueObservingOptionNew
                       context:@"city"];
        if (self.isShowingAroundDetail) {
            __weak typeof(self) weakSelf = self;
            CGRect belowAroundAreaFrame = self.belowAroundArea.frame;
            belowAroundAreaFrame.origin.y = CGRectGetMaxY(self.aroundEnabled ? self.aroundViewOriginFrame : self.publishDateLabel.frame);
            [UIView animateWithDuration:0.25
                             animations:^{
                                 weakSelf.aroundView.frame = weakSelf.aroundViewOriginFrame;
                                 weakSelf.belowAroundArea.frame = belowAroundAreaFrame;
                                 weakSelf.scrollView.contentSize = CGSizeMake(CGRectGetWidth(weakSelf.scrollView.bounds), CGRectGetMaxY(belowAroundAreaFrame));
                             }];
        }
    } else {
        [self.aroundCity removeObserver:self forKeyPath:@"updateDate"];
        self.aroundCity = city;
        [self.aroundCity addObserver:self
                    forKeyPath:@"updateDate"
                       options:NSKeyValueObservingOptionNew
                       context:@"aroundCity"];
        if (!self.isShowingAroundDetail) {
            __weak typeof(self) weakSelf = self;
            CGRect aroundViewFrame = self.aroundView.frame;
            aroundViewFrame.size.height = kAroundViewHeight;
            CGRect belowAroundAreaFrame = self.belowAroundArea.frame;
            belowAroundAreaFrame.origin.y = CGRectGetMaxY(self.aroundEnabled ? aroundViewFrame : self.publishDateLabel.frame);
            [UIView animateWithDuration:0.25
                             animations:^{
                                 weakSelf.aroundView.frame = aroundViewFrame;
                                 weakSelf.belowAroundArea.frame = belowAroundAreaFrame;
                                 weakSelf.scrollView.contentSize = CGSizeMake(CGRectGetWidth(weakSelf.scrollView.bounds), CGRectGetMaxY(belowAroundAreaFrame));
                             }];
        }
    }
    
    self.isShowingAroundDetail = isAround;
    [self refreshUI];
}

- (void)refreshUI{
    self.nameLabel.text = self.city.name;
    self.temperatureLabel.text = (self.city.temperature ? [NSString stringWithFormat:@"温度：%d", [self.city.temperature integerValue]] : @"-");
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    dateFormatter.timeZone = self.city.timeZone;
    dateFormatter.dateFormat = @"发布时间：yyyy-MM-dd HH:mm:ss";
    NSString *publishDateString = [dateFormatter stringFromDate:self.city.publishDate];
    self.publishDateLabel.text = (publishDateString ? publishDateString : @"");
    
    self.aroundNameLabel.text = self.aroundCity.name;
    self.aroundTemperatureLabel.text = (self.aroundCity.temperature ? [NSString stringWithFormat:@"温度：%d", [self.aroundCity.temperature integerValue]] : @"-");
    NSString *aroundPublishDateString = [dateFormatter stringFromDate:self.aroundCity.publishDate];
    self.aroundPublishDateLabel.text = (aroundPublishDateString ? aroundPublishDateString : @"");
    
    if (!self.isShowingAroundDetail) {
        self.belowAroundArea.text = [NSString stringWithFormat:@"%@的其他信息", self.city.name];
    } else {
        self.belowAroundArea.text = [NSString stringWithFormat:@"%@的其他信息", self.aroundCity.name];
    }
    
}

#pragma mark - event handle
- (void)onTapHideButton{
    self.isShowingAroundInMap = NO;
    [self handlerWithIsShowingAroundInMap:self.isShowingAroundInMap];
    if (self.tapAroundButtonHandler) {
        self.tapAroundButtonHandler(NO, nil);
    }
    if (self.tapHideButtonHandler) {
        self.tapHideButtonHandler();
    }
}

- (void)onTapAroundButton{
    self.isShowingAroundInMap = !self.isShowingAroundInMap;
    [self handlerWithIsShowingAroundInMap:self.isShowingAroundInMap];
    if (!self.isShowingAroundInMap) {
       [self reloadData:self.city isAround:NO];
    }
    if (self.tapAroundButtonHandler) {
        self.tapAroundButtonHandler(self.isShowingAroundInMap, self.city);
    }
}

- (void)handlerWithIsShowingAroundInMap:(BOOL)isShowingAroundInMap{
    if (self.isShowingAroundInMap) {
        [self.aroundButton setTitle:@"隐藏周边" forState:UIControlStateNormal];
    } else{
        [self.aroundButton setTitle:@"显示周边" forState:UIControlStateNormal];
    }
}

#pragma mark - public
- (void)hideAround{
    self.isShowingAroundInMap = NO;
    [self handlerWithIsShowingAroundInMap:self.isShowingAroundInMap];
}

- (void)clearData{
    self.nameLabel.text = nil;
    self.temperatureLabel.text = nil;
    self.publishDateLabel.text = nil;
    self.aroundNameLabel.text = nil;
    self.aroundTemperatureLabel.text = nil;
    self.aroundPublishDateLabel.text = nil;
    self.belowAroundArea.text = nil;
    
    self.aroundView.frame = self.aroundViewOriginFrame;
    CGRect belowAroundAreaFrame = self.belowAroundArea.frame;
    belowAroundAreaFrame.origin.y = CGRectGetMaxY(self.aroundEnabled ? self.aroundViewOriginFrame : self.publishDateLabel.frame);
    self.belowAroundArea.frame = belowAroundAreaFrame;
    self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.scrollView.bounds), CGRectGetMaxY(self.belowAroundArea.frame));
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if ([keyPath isEqualToString:@"updateDate"] && [@"city" isEqualToString:CFBridgingRelease(context)]) {
        [self refreshUI];
    } else if([keyPath isEqualToString:@"updateDate"] && [@"aroundCity" isEqualToString:CFBridgingRelease(context)]) {
        [self refreshUI];
    }
}

#pragma mark - dealloc
- (void)dealloc{
    [self.city removeObserver:self forKeyPath:@"updateDate"];
    [self.aroundCity removeObserver:self forKeyPath:@"updateDate"];
}

@end
