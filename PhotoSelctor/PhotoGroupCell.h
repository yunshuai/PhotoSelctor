//
//  PhotoGroupCell.h
//  PhotoSelctor
//
//  Created by 贾小云 on 2017/11/5.
//  Copyright © 2017年 贾小云. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoGroupCell : UITableViewCell

@property (nonatomic,strong) UIImageView * img;
@property (nonatomic,strong) UILabel * name;
@property (nonatomic,strong) UILabel * sum_count;
@property (nonatomic,strong) UILabel * selected_count;

@end
