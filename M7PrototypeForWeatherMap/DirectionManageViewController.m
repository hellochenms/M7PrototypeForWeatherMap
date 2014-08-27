//
//  DirectionManageViewController.m
//  M7PrototypeForWeatherMap
//
//  Created by Chen Meisong on 14-8-27.
//  Copyright (c) 2014年 chenms.m2. All rights reserved.
//

#import "DirectionManageViewController.h"
#import "DirectionManageView.h"

@interface DirectionManageViewController()
@property (nonatomic) DirectionManageView *manageView;
@end

@implementation DirectionManageViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    CGRect frame = [UIScreen mainScreen].bounds;
    frame.size.height -= (isIOS7 ? 0 : 20);
    self.manageView = [[DirectionManageView alloc] initWithFrame:frame];
    __weak typeof(self) weakSelf = self;
    self.manageView.tapBackButtonHandler = ^{
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    };
    [self.view addSubview:self.manageView];
}
@end
