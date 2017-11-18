//
//  GroupPhotoVc.m
//  PhotoSelctor
//
//  Created by 贾小云 on 2017/11/18.
//  Copyright © 2017年 贾小云. All rights reserved.
//

#import "GroupPhotoVc.h"
#import <Photos/Photos.h>
#import "SelectPicturesController.h"
#import "PhotoGroupCell.h"

#define SCREEN_WIDTH  [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT  [UIScreen mainScreen].bounds.size.height
#define ColorRgb(R,G,B) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:1]

@interface GroupPhotoVc ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>

@property (nonatomic,strong) UITableView * tableview;
@property (nonatomic,strong) NSMutableArray * picDataSource;

@end

@implementation GroupPhotoVc

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"选择相册";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.picDataSource = [NSMutableArray arrayWithCapacity:0];
    self.tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    self.tableview.dataSource = self;
    self.tableview.delegate = self;
    [self.view addSubview:self.tableview];
    self.tableview.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self getPhotoList];
}


//获取所有相册列表
-(void)getPhotoList
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        PHFetchResult * group = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
        NSArray * arr1 = [self getFirstPhotoName:group];
        PHFetchResult * group1 = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
        NSArray * arr2 = [self getFirstPhotoName:group1];
        [self.picDataSource addObjectsFromArray:arr1];
        [self.picDataSource addObjectsFromArray:arr2];
        dispatch_group_t groupQueue = dispatch_group_create();
        dispatch_queue_t queue = dispatch_queue_create("com.yun", 0);
        dispatch_group_async(groupQueue, queue, ^{
            for (NSMutableDictionary * dic in self.picDataSource) {
                PHAsset * asset = dic[@"asset"];
                [self getImageByAsset:asset makeSize:CGSizeMake(150, 150) makeResizeMode:PHImageRequestOptionsResizeModeExact completion:^(UIImage *image) {
                    if (image) {
                        [dic setObject:image forKey:@"img"];
                    }
                }];
            }
        });
        dispatch_group_wait(groupQueue, DISPATCH_TIME_FOREVER);
        [self.tableview reloadData];
    }
}

-(NSMutableArray *)getFirstPhotoName:(PHFetchResult *)group
{
    __block NSMutableArray * photoSource = [NSMutableArray arrayWithCapacity:0];
    [group enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        PHAssetCollection * assetCollection = obj;
        NSString * groupName1 = assetCollection.localizedTitle;
        if ([groupName1 isEqualToString:@"视频"] || [groupName1 isEqualToString:@"慢动作"] || [groupName1 isEqualToString:@"最近删除"]|| [groupName1 isEqualToString:@"延时摄影"] || [groupName1 isEqualToString:@"已隐藏"] || [groupName1 isEqualToString:@"全景照片"])
        {
            
        }
        else
        {
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

-(void)getImageByAsset:(PHAsset *)asset makeSize:(CGSize)size makeResizeMode:(PHImageRequestOptionsResizeMode)resizeMode completion:(void (^)(UIImage * image))completion
{
    PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
    /**
     resizeMode：对请求的图像怎样缩放。有三种选择：None，不缩放；Fast，尽快地提供接近或稍微大于要求的尺寸；Exact，精准提供要求的尺寸。
     deliveryMode：图像质量。有三种值：Opportunistic，在速度与质量中均衡；HighQualityFormat，不管花费多长时间，提供高质量图像；FastFormat，以最快速度提供好的质量。
     这个属性只有在 synchronous 为 true 时有效。
     */
    option.resizeMode = resizeMode;//控制照片尺寸
//    option.deliveryMode = PHImageRequestOptionsDeliveryModeOpportunistic;//控制照片质量
    option.synchronous = YES;
    option.networkAccessAllowed = YES;
    //param：targetSize 即你想要的图片尺寸，若想要原尺寸则可输入PHImageManagerMaximumSize
    [[PHCachingImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeAspectFill options:option resultHandler:^(UIImage * _Nullable image, NSDictionary * _Nullable info) {
        completion(image);
    }];
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SelectPicturesController * selectVc = [[SelectPicturesController alloc] init];
    selectVc.photoData = self.picDataSource[indexPath.row];
    [self.navigationController pushViewController:selectVc animated:YES];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.picDataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier = @"cell";
    PhotoGroupCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    NSDictionary * dic = self.picDataSource[indexPath.row];
    if (!cell) {
        cell = [[PhotoGroupCell alloc] init];
        NSString * numStr = [NSString stringWithFormat:@"(%@)",dic[@"count"]];
        CGRect rect = [numStr boundingRectWithSize:CGSizeMake(MAXFLOAT, 100) options:0 attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil];
        cell.selected_count.frame = CGRectMake(CGRectGetMinX(cell.sum_count.frame)+5+rect.size.width, 35, 60, 30);
    }
   
    cell.img.image = dic[@"img"];
    cell.name.text = dic[@"groupName"];
    cell.sum_count.text = [NSString stringWithFormat:@"(%@)",dic[@"count"]];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}
@end
