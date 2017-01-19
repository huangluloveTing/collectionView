//
//  ScanPhotoViewController.m
//  WaterfallCollectionLayout
//
//  Created by 黄露 on 2017/1/19.
//  Copyright © 2017年 tanhui. All rights reserved.
//

#import "ScanPhotoViewController.h"
#import "PhotoScanLayout.h"

@interface ScanPhotoViewController ()<UICollectionViewDelegate , UICollectionViewDataSource>

@property (nonatomic ,strong) UICollectionView *photoView;

@end

@implementation ScanPhotoViewController

- (UICollectionView *)photoView {
    if (!_photoView ) {
        PhotoScanLayout *layout = [[PhotoScanLayout alloc] init];
        _photoView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width , 200) collectionViewLayout:layout];
        _photoView.delegate = self;
        _photoView.dataSource = self;
        [_photoView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"photo"];
        
        _photoView.layer.masksToBounds = YES;
        _photoView.layer.cornerRadius = 5;
        _photoView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _photoView.layer.borderWidth = 1;
    }
    
    return _photoView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.translucent = NO;
    
    [self.view addSubview:self.photoView];
}

#pragma mark -
- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 10;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"photo" forIndexPath:indexPath];
    
    cell.contentView.backgroundColor = [UIColor colorWithRed:(arc4random() % 255) / 255.0 green:(arc4random() % 255) / 255.0 blue:(arc4random() % 255) / 255.0 alpha:1];
    
    return cell;
}


@end
