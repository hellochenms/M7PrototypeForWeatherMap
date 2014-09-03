//
//  LocationManageCell.m
//  M7PrototypeForWeatherMap
//
//  Created by Chen Meisong on 14-8-27.
//  Copyright (c) 2014年 chenms.m2. All rights reserved.
//

#import "CityManageCell.h"
#import "City.h"

@interface CityManageCell ()
@property (nonatomic) UILabel *nameLabel;
@property (nonatomic) City  *city;
@end

@implementation CityManageCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, CGRectGetHeight(self.bounds))];
        _nameLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        _nameLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_nameLabel];
    }
    
    return self;
}

#pragma mark -
- (void)reloadData:(City *)city{
    [self.city removeObserver:self forKeyPath:@"name"];
    self.city = city;
    [self.city addObserver:self
                forKeyPath:@"name"
                   options:NSKeyValueObservingOptionNew
                   context:nil];
    self.nameLabel.text = city.name;
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if ([keyPath isEqualToString:@"name"]) {
        self.nameLabel.text = self.city.name;
    }
}

#pragma mark - dealloc
- (void)dealloc{
    [self.city removeObserver:self forKeyPath:@"name"];
}
    
@end
