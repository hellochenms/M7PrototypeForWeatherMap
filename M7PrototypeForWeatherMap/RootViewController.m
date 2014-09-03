//
//  RootViewController.m
//  M7PrototypeForWeatherMap
//
//  Created by Chen Meisong on 14-8-26.
//  Copyright (c) 2014年 chenms.m2. All rights reserved.
//

#import "RootViewController.h"
#import "RootView.h"
#import "CityManageViewController.h"
#import "DirectionManageViewController.h"

@interface RootViewController()

@end

@implementation RootViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = YES;
    
    CGRect frame = [UIScreen mainScreen].bounds;
    frame.size.height -= (isIOS7 ? 0 : 20);
    
    RootView *rootView = [[RootView alloc] initWithFrame:frame];
    rootView.tapTitleButtonHandler = ^(BOOL isShowingDirectionView){
        if (!isShowingDirectionView) {
            CityManageViewController *controller = [CityManageViewController new];
            [self presentViewController:controller animated:YES completion:nil];
        } else {
            DirectionManageViewController *controller = [DirectionManageViewController new];
            [self presentViewController:controller animated:YES completion:nil];
        }
    };
    [self.view addSubview:rootView];
}

@end
