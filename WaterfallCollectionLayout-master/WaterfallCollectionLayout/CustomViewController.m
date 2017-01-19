//
//  CustomViewController.m
//  WaterfallCollectionLayout
//
//  Created by 黄露 on 2017/1/18.
//  Copyright © 2017年 tanhui. All rights reserved.
//

#import "CustomViewController.h"
#import "CustomWaterfallLayout.h"
#import "CustomCollectionViewCell.h"

@interface CustomViewController ()<UICollectionViewDelegate , UICollectionViewDataSource>

@property (nonatomic ,strong) UICollectionView *collectionView;

@end

@implementation CustomViewController

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        CustomWaterfallLayout *layout = [[CustomWaterfallLayout alloc] init];
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor yellowColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[CustomCollectionViewCell class] forCellWithReuseIdentifier:@"col_cell"];
    }
    
    return _collectionView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self.view addSubview:self.collectionView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - delegate and datasource
- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return 100;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CustomCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"col_cell" forIndexPath:indexPath];
    
    cell.contentView.backgroundColor = [UIColor colorWithRed:(arc4random() % 255) / 255.0 green:(arc4random() % 255) / 255.0 blue:(arc4random() % 255) / 255.0 alpha:1];
    
    return cell;
}


@end
