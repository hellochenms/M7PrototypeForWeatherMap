//
//  LocationManageViewController.m
//  M7PrototypeForWeatherMap
//
//  Created by Chen Meisong on 14-8-27.
//  Copyright (c) 2014年 chenms.m2. All rights reserved.
//

#import "LocationManageViewController.h"
#import "LocationManageView.h"
#import "AddLocationViewController.h"

@interface LocationManageViewController()
@property (nonatomic) LocationManageView *manageView;
@end

@implementation LocationManageViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    CGRect frame = [UIScreen mainScreen].bounds;
    frame.size.height -= (isIOS7 ? 0 : 20);
    self.manageView = [[LocationManageView alloc] initWithFrame:frame];
    __weak typeof(self) weakSelf = self;
    self.manageView.tapBackButtonHandler = ^{
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    };
    self.manageView.tapAddButtonHandler = ^{
        AddLocationViewController *controller = [AddLocationViewController new];
        [weakSelf presentViewController:controller animated:YES completion:nil];
    };
    [self.view addSubview:self.manageView];
}

@end
