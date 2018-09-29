//
//  LeftSectionTableViewCell.m
//  LeftSectionTable
//
//  Created by yangjuanping on 2018/9/30.
//  Copyright © 2018年 yangjuanping. All rights reserved.
//

#import "LeftSectionTableViewCell.h"

@implementation LeftSectionTableViewCell{
    CAGradientLayer * _gradientLayer;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _gradientLayer = [CAGradientLayer layer];
        _gradientLayer.colors = @[(id)[[ UIColor colorWithWhite:1.0f alpha:0.2f] CGColor],
                                  (id)[[ UIColor colorWithWhite:1.0f alpha:0.1f] CGColor],
                                  (id)[[ UIColor clearColor] CGColor],
                                  (id)[[ UIColor colorWithWhite:0.0f alpha:0.1f] CGColor]];
        _gradientLayer.locations = @[@0.00f,@0.01f,@0.95f,@1.00f];
        [self.layer insertSublayer:_gradientLayer atIndex:0];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.textLabel.frame = CGRectMake(110, 0, self.frame.size.width-110, self.frame.size.height);
    _gradientLayer.frame = CGRectMake(90, 0, self.frame.size.width-90, self.frame.size.height);
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
