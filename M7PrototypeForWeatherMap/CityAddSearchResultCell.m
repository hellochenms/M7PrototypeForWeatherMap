//
//  CityAddSearchResultCell.m
//  M7PrototypeForWeatherMap
//
//  Created by Chen Meisong on 14-8-27.
//  Copyright (c) 2014年 chenms.m2. All rights reserved.
//

#import "CityAddSearchResultCell.h"

@interface CityAddSearchResultCell()
@property (nonatomic) UILabel *addressLabel;
@end

@implementation CityAddSearchResultCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIImageView* normalBg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"city_cell_bg_normal"]];
        self.backgroundView = normalBg;
        
        UIImageView* selectBg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"city_cell_bg_highlight"]];
        self.selectedBackgroundView = selectBg;
        
        // Initialization code
        _addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 280, 64)];
        _addressLabel.backgroundColor = [UIColor clearColor];
        _addressLabel.textColor = [UIColor blackColor];
        _addressLabel.font = [UIFont systemFontOfSize:20];
        [self.contentView addSubview:_addressLabel];
        
        UIView *selectedBackgroundView = [UIView new];
        selectedBackgroundView.backgroundColor = [UIColor colorWithRed:0xd8/255.0 green:0xd8/255.0 blue:0xd8/255.0 alpha:1];
        self.selectedBackgroundView = selectedBackgroundView;
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)reloadData:(NSString *)address isExists:(BOOL)isExists{
    _addressLabel.text = address;
    _addressLabel.textColor = (isExists ? [UIColor lightGrayColor] : [UIColor colorWithRed:0x55/255.0 green:0x55/255.0 blue:0x55/255.0 alpha:1]);
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
