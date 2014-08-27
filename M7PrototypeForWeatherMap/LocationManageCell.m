//
//  LocationManageCell.m
//  M7PrototypeForWeatherMap
//
//  Created by Chen Meisong on 14-8-27.
//  Copyright (c) 2014年 chenms.m2. All rights reserved.
//

#import "LocationManageCell.h"
#import "City.h"

@interface LocationManageCell ()
@property (nonatomic) UILabel *nameLabel;
@end

@implementation LocationManageCell
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
    self.nameLabel.text = city.name;
}
    
@end
