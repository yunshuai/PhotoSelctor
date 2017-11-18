//
//  PhotoGroupCell.m
//  PhotoSelctor
//
//  Created by 贾小云 on 2017/11/5.
//  Copyright © 2017年 贾小云. All rights reserved.
//

#import "PhotoGroupCell.h"

@implementation PhotoGroupCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        CGFloat w = CGRectGetWidth(self.contentView.frame);
        CGFloat h = 100;
        self.img = [[UIImageView alloc] initWithFrame:CGRectMake(15, 5, h-10, h-10)];
        [self.contentView addSubview:self.img];
        
        self.name = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.img.frame)+10, 0, 100, h)];
        self.name.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:self.name];
        
        self.sum_count = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.name.frame)+10, 0, 80, h)];
        self.sum_count.font = [UIFont systemFontOfSize:15];
        self.sum_count.textColor = [UIColor grayColor];
        [self.contentView addSubview:self.sum_count];
        
        self.selected_count = [[UILabel alloc] initWithFrame:CGRectMake(w-70, h*0.5-15, 60, 30)];
        self.selected_count.font = [UIFont systemFontOfSize:13];
        self.selected_count.textColor = [UIColor whiteColor];
        [self.selected_count.layer setCornerRadius:10];
        self.selected_count.backgroundColor = [UIColor orangeColor];
        self.selected_count.layer.masksToBounds = YES;
        [self.contentView addSubview:self.selected_count];
    }
    return self;
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
