//
//  photoCell.m
//  test
//
//  Created by renwen on 2017/9/22.
//  Copyright © 2017年 renWenWang. All rights reserved.
//

#import "PhotoCell.h"

@implementation PhotoCell

-(instancetype)initWithFrame:(CGRect)frame
{
	if ([super initWithFrame:frame]) {
		[self initViews];
	}
	return self;
}

-(void)initViews
{
//	CGFloat screenWid = [UIScreen mainScreen].bounds.size.width;
	CGFloat wid = self.contentView.frame.size.width;
//	CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
	self.photo = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, wid, wid)];
	[self.contentView addSubview:self.photo];

	self.coverImg = [[UIImageView alloc] initWithFrame:self.photo.frame];
	[self.contentView addSubview:self.coverImg];
	self.coverImg.backgroundColor = [UIColor colorWithWhite:1 alpha:0.8];
	self.coverImg.hidden = YES;

	self.selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	self.selectBtn.frame = CGRectMake(wid-25, 5, 20, 20);
	[self.selectBtn.layer setCornerRadius:10];
	self.selectBtn.layer.masksToBounds = YES;
	self.selectBtn.alpha = 0.6;
	[self.contentView addSubview:self.selectBtn];
	[self.selectBtn setBackgroundImage:[UIImage imageNamed:@"pic_select"] forState:UIControlStateNormal];
}



@end
