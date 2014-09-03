//
//  AddLocationViewController.m
//  M7PrototypeForWeatherMap
//
//  Created by Chen Meisong on 14-8-27.
//  Copyright (c) 2014年 chenms.m2. All rights reserved.
//

#import "AddCityViewController.h"
#import "AddCityView.h"
#import "CityManager.h"

@interface AddCityViewController ()
@property (nonatomic) AddCityView   *addView;
@property (nonatomic) ALVAddViewType    type;
@end

@implementation AddCityViewController

- (id)init{
    return [self initWithType:ALVAddViewTypeDisableUsedCity];
}

- (id)initWithType:(ALVAddViewType)type{
    self = [super init];
    if (self) {
        _type = type;
    }
    
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    CGRect frame = [UIScreen mainScreen].bounds;
    frame.size.height -= (isIOS7 ? 0 : 20);
    self.addView = [[AddCityView alloc] initWithFrame:frame type:self.type];
    __weak typeof(self) weakSelf = self;
    self.addView.tapBackButtonHandler = ^{
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    };
    self.addView.addFinishHandler = ^(City *city){
        if (weakSelf.didSelectCityHandler) {
            weakSelf.didSelectCityHandler(city);
        }
        [weakSelf dismissViewControllerAnimated:YES completion:weakSelf.dismissCompletionHandler];
    };
    [self.view addSubview:self.addView];
}

@end
