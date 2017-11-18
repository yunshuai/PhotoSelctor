//
//  ViewController.m
//  PhotoSelctor
//
//  Created by 贾小云 on 2017/11/5.
//  Copyright © 2017年 贾小云. All rights reserved.
//

#import "ViewController.h"
#import <Photos/Photos.h>
#import "SelectPicturesController.h"
#import "PhotoGroupCell.h"
#import "GroupPhotoVc.h"

#define SCREEN_WIDTH  [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT  [UIScreen mainScreen].bounds.size.height
#define ColorRgb(R,G,B) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:1]

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>

@property (nonatomic,strong) UITableView * tableview;
@property (nonatomic,strong) NSMutableArray * picDataSource;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"选择图片";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    self.picDataSource = [NSMutableArray arrayWithCapacity:0];
    self.tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT*0.5-44, SCREEN_WIDTH, 44*2)];
    self.tableview.dataSource = self;
    self.tableview.delegate = self;
    self.tableview.scrollEnabled = NO;
    [self.view addSubview:self.tableview];
//    self.tableview.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

//获取所有相册列表
-(void)getAllPhotoList
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        PHFetchResult * group = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil];
        NSArray * arr1 = [self getFirstPhotoName:group];
        self.picDataSource = [NSMutableArray arrayWithArray:arr1];
        NSLog(@"array = %@",arr1);
    }
}

-(NSMutableArray *)getFirstPhotoName:(PHFetchResult *)group
{
    __block NSMutableArray * photoSource = [NSMutableArray arrayWithCapacity:0];
    [group enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        PHAssetCollection * assetCollection = obj;
        NSString * groupName1 = assetCollection.localizedTitle;
        PHFetchResult * fetchResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:nil];
        PHImageRequestOptions * option = [[PHImageRequestOptions alloc] init];
        option.resizeMode = PHImageRequestOptionsResizeModeFast;
        option.networkAccessAllowed = YES;
        NSInteger count = fetchResult.count;
        if (count>0) {
            PHAsset * asset = fetchResult.firstObject;
            NSMutableDictionary * dic = [NSMutableDictionary dictionary];
            [dic setObject:groupName1 forKey:@"groupName"];
            [dic setObject:@(count) forKey:@"count"];
            [dic setObject:asset forKey:@"asset"];
            [dic setObject:fetchResult forKey:@"fetchResult"];
            [photoSource addObject:dic];
        }
    }];
    if (photoSource.count > 0) {
        return photoSource;
    }
    else
    {
        return nil;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == 1)
    {
        GroupPhotoVc * groupPhoto = [[GroupPhotoVc alloc] init];
        [self.navigationController pushViewController:groupPhoto animated:YES];
    }
    else
    {
        SelectPicturesController * selectVc = [[SelectPicturesController alloc] init];
        [self getAllPhotoList];
        selectVc.photoData = self.picDataSource[0];
        [self.navigationController pushViewController:selectVc animated:YES];
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier = @"cell";
    UITableViewCell * cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    cell.textLabel.text = @"全部";
    if (indexPath.row == 1) {
         cell.textLabel.text = @"选择相册";
    }
    return cell;
}

@end
