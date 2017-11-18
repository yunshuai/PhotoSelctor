//
//  SelectPicturesController.m
//  test
//
//  Created by renwen on 2017/9/22.
//  Copyright © 2017年 renWenWang. All rights reserved.
//

#import "SelectPicturesController.h"
#import "PhotoCell.h"
#import <Photos/Photos.h>

#define SCREEN_WIDTH  [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT  [UIScreen mainScreen].bounds.size.height
#define ColorRgb(R,G,B) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:1]

@interface SelectPicturesController () <UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong) UICollectionView * collection;
@property (nonatomic,strong) NSMutableArray * dataSource;
@property (nonatomic,strong) PHFetchResult * asset;
@property (nonatomic,assign) NSInteger count;
@property (nonatomic,strong) PHImageRequestOptions * imgOption;

@end

@implementation SelectPicturesController

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = self.photoData[@"groupName"];
	CGFloat screenWid = [UIScreen mainScreen].bounds.size.width;
	UILabel * groupName = [[UILabel alloc] initWithFrame:CGRectMake(0, 20,CGRectGetWidth(self.view.frame),30)];
	groupName.text = self.photoData[@"groupName"];
	groupName.textAlignment = NSTextAlignmentCenter;
	[self.view addSubview:groupName];
//    UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake(20,20,60,40)];
//    [button addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
//    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [self.view addSubview:button];
//    button.titleLabel.font = [UIFont systemFontOfSize:14];
//    [button.layer setCornerRadius:4];
//    [button setTitle:@"返回" forState:UIControlStateNormal];
    
    self.imgOption = [[PHImageRequestOptions alloc] init];
    self.imgOption.resizeMode = PHImageRequestOptionsResizeModeExact;//控制照片尺寸
    self.imgOption.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;//控制照片质量
    self.imgOption.synchronous = YES;
    self.imgOption.networkAccessAllowed = YES;
    self.asset = self.photoData[@"fetchResult"];
    
	UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc] init];
	CGFloat picWid = (screenWid-5*5)/4;
	flowLayout.itemSize = CGSizeMake(picWid, picWid);
	flowLayout.minimumLineSpacing = 2;
	flowLayout.minimumInteritemSpacing = 2;
	self.collection = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, screenWid, SCREEN_HEIGHT-64) collectionViewLayout:flowLayout];
	[self.collection registerClass:[PhotoCell class] forCellWithReuseIdentifier:@"cell"];
	self.collection.backgroundColor = [UIColor whiteColor];
	[self.view addSubview:self.collection];
	self.collection.dataSource = self;
	self.collection.delegate = self;
	self.dataSource = [NSMutableArray arrayWithCapacity:0];
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
	return self.asset.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
	PhotoCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    [[PHImageManager defaultManager] requestImageForAsset:self.asset[indexPath.row] targetSize:CGSizeMake(200, 200) contentMode:PHImageContentModeDefault options:self.imgOption resultHandler:^(UIImage*_Nullable result,NSDictionary*_Nullable info) {
        //这个handler 并非在主线程上执行，所以如果有UI的更新操作就得手动添加到主线程中
               dispatch_async(dispatch_get_main_queue(), ^{
                   //update UI
//                   cell.photo.contentMode = UIViewContentModeScaleAspectFit;
                   cell.photo.image = result;
               });
    }];
	return cell;
}


-(void)goBack
{
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
