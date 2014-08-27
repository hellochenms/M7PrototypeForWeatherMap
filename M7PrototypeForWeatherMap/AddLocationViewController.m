//
//  AddLocationViewController.m
//  M7PrototypeForWeatherMap
//
//  Created by Chen Meisong on 14-8-27.
//  Copyright (c) 2014年 chenms.m2. All rights reserved.
//

#import "AddLocationViewController.h"
#import "AddLocationView.h"

@interface AddLocationViewController ()
@property (nonatomic) AddLocationView *addView;
@end

@implementation AddLocationViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    CGRect frame = [UIScreen mainScreen].bounds;
    frame.size.height -= (isIOS7 ? 0 : 20);
    self.addView = [[AddLocationView alloc] initWithFrame:frame];
    __weak typeof(self) weakSelf = self;
    self.addView.tapBackButtonHandler = ^{
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    };
    self.addView.addFinishHandler = ^{
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    };
    [self.view addSubview:self.addView];
}

@end
