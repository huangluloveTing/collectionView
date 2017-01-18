//
//  ViewController.m
//  瀑布流练习  laozi bijing shi tiancai  meiyou kunnan neng nandao wode
//  zheme nan jiejue de wenti bushi haishi bei laozi jiejue gaoding le ma  haha
//
//  Created by mac on 16/1/4.
//  Copyright © 2016年 丁志杰 --- 银泰网络. All rights reserved.
//

#define imageurl @"http://i1.15yan.guokr.cn/u0bk6rs5q79lnochkx3vj1ki18zjcobh.jpg!content"


#define HTTPURL @"http://apis.guokr.com/handpick/article.json?limit=%ld&ad=1&category=all&retrieve_type=by_since"


#import "ViewController.h"
#import "AoiroSoraLayout.h"
#import "Recommend.h"
#import "RecommendCollectionViewCell.h"
#import "UIImage+MultiFormat.h"
#import "UIImageView+WebCache.h"
#import "BLImageSize.h"
#import "MJRefresh.h"
#import "MBProgressHUD.h"
@interface ViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,AoiroSoraLayoutDelegate>


@property (nonatomic,strong)UICollectionView * collectionView;
@property (nonatomic,strong)UIImage * image; // 如果计算图片尺寸失败  则下载图片直接计算
@property (nonatomic,strong)NSMutableArray * heightArray;// 存储图片高度的数组
@property (nonatomic,strong)NSMutableArray * modelArray; //存储 model 类的数组

@property (nonatomic,assign)NSInteger page; // 一次刷新的个数

@property (nonatomic,strong)MBProgressHUD * hud;

@end

@implementation ViewController

#pragma mark -- MBProgressHUD 菊花加载显示

- (void)p_MBProgressHUD
{
    _hud = [MBProgressHUD showHUDAddedTo:_collectionView animated:YES];
    _hud.dimBackground = YES;// 灰背景  菊花高亮
    _hud.labelText = @"加载中";
    _hud.square = YES;  // 背景矩形宽高一样
    _hud.mode = MBProgressHUDModeIndeterminate; // 菊花样式
    [_hud show:YES];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    _page = 30;// 初次加载的个数
    
    [self p_collectionView]; // collectionView 布局
    
   // [self p_MBProgressHUD]; 菊花加载

    [self p_json];  // json 解析
    
    [self addHeader]; // 下拉刷新
    
    [self addFooter]; // 上拉刷新
    
}

// 懒加载数组
- (NSMutableArray *)heightArray
{
    if (_heightArray == nil) {
        _heightArray = [NSMutableArray array];
    }
    return _heightArray;
}

// 懒加载数组
- (NSMutableArray *)modelArray
{
    if (_modelArray == nil) {
        _modelArray = [NSMutableArray array];
    }
    return _modelArray;
}

#pragma mark -- 下拉刷新
- (void)addHeader
{
    __unsafe_unretained typeof(self) vc = self;
    // 添加下拉刷新头部控件
    [self.collectionView addHeaderWithCallback:^{
        // 进入刷新状态就会调这个Block
        
        
        // 模拟延迟加载数据,因此2秒后才调用
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            // 结束刷新
            [vc.collectionView headerEndRefreshing];
        });
    }];
#pragma mark -- 自动刷新--进入程序就下拉刷新
    [self.collectionView headerBeginRefreshing];
}

#pragma mark -- 上拉刷新
- (void)addFooter
{
    __unsafe_unretained typeof(self)vc = self;
    // 添加上拉刷新尾部控件
    [self.collectionView addFooterWithCallback:^{
        // 添加刷新状态就会回调这个block
        vc.page = vc.page + 10;
        NSString * str = [NSString stringWithFormat:HTTPURL,(long)vc.page];
        
        NSURL * url = [NSURL URLWithString:str];
        // 创建请求对象
        NSURLRequest * request = [NSURLRequest requestWithURL:url];
        // 发送请求
        NSURLSessionDataTask * dataTask = [[NSURLSession sharedSession]dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            
                [vc.modelArray removeAllObjects];
                [vc.heightArray removeAllObjects];
                
                NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                
                for (NSDictionary * d in [dict objectForKey:@"result"]) {
                    Recommend * m = [[Recommend alloc]init];
                    [m setValuesForKeysWithDictionary:d];
                    
                    [vc.modelArray addObject:m];
                    
                    [vc p_putImageWithURL:m.headline_img];
                }
            
            // 模拟延迟加载数据,因此2秒后才调用
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
               
                // 判断图片高度数组的个数  是否已经全部计算完成
                // 完成则结束刷新
                if (vc.heightArray.count == vc.page) {
                    [vc.collectionView reloadData];
                    
                    [vc.collectionView footerEndRefreshing];
                }
               
            });
            
        }];
        
        [dataTask resume]; // 开始请求
        
    }];
    
    
}



#pragma mark -- json解析  初次加载
- (void)p_json
{
    NSString * str = [NSString stringWithFormat:HTTPURL,(long)_page];
    
    NSURL * url = [NSURL URLWithString:str];
    // 创建请求对象
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    // 发送请求
    NSURLSessionDataTask * dataTask = [[NSURLSession sharedSession]dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
       
       
        if (!error) {
            
            NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            for (NSDictionary * d in [dict objectForKey:@"result"]) {
                Recommend * m = [[Recommend alloc]init];
                [m setValuesForKeysWithDictionary:d];
                
                [self.modelArray addObject:m];
                
                [self p_putImageWithURL:m.headline_img];
                
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
           
             [_collectionView reloadData];
        });
        
      
    }];
    
    [dataTask resume]; // 开始请求
}


#pragma mark -- 获取 图片 和 图片的比例高度
- (void)p_putImageWithURL:(NSString *)url
{
    // 获取图片
    
    CGSize  size = [BLImageSize dowmLoadImageSizeWithURL:url];
    
    // 获取图片的高度并按比例压缩
    NSInteger itemHeight = size.height * (((self.view.frame.size.width - 20) / 2 / size.width));
    
    NSNumber * number = [NSNumber numberWithInteger:itemHeight];
        
    [self.heightArray addObject:number];

}


#pragma mark -- collectionView 布局
- (void)p_collectionView
{
    
    AoiroSoraLayout * layout = [[AoiroSoraLayout alloc]init];
    layout.interSpace = 5; // 每个item 的间隔
    layout.edgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
    layout.colNum = 2; // 列数;
    layout.delegate = self;
    
    _collectionView = [[UICollectionView alloc]initWithFrame:self.view.frame collectionViewLayout:layout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    
     [_collectionView registerClass:[RecommendCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [self.view addSubview:_collectionView];
}

#pragma mark -- 返回每个item的高度
- (CGFloat)itemHeightLayOut:(AoiroSoraLayout *)layOut indexPath:(NSIndexPath *)indexPath
{
    
    if ([self.heightArray[indexPath.row] integerValue] < 0 || !self.heightArray[indexPath.row]) {
        
        return 150;
    }
    else
    {
        NSInteger intger = [self.heightArray[indexPath.row] integerValue];
        return intger;
    }
    
}

#pragma mark -- collectionView 的分组个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

#pragma mark -- item 的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.modelArray.count;
}

#pragma mark -- cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    RecommendCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.model = self.modelArray[indexPath.row];
    
    
    
    // jiazai shibai chongxin jiazai
    Recommend * model = self.modelArray[indexPath.row];
    if ([model.headline_img isEqualToString:imageurl]) {
        cell.MyImage.image = [UIImage sd_imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:model.headline_img]]];
    }
    
    //[_hud hide:YES];
    
       return cell;
}



#pragma mark -- 选中某个cell
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"第 %ld 个cell",(long)indexPath.row);
    Recommend * model = self.modelArray[indexPath.row];
    NSLog(@"%@",model.headline_img);
}








- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com