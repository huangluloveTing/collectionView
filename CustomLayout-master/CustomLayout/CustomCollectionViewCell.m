//
//  CustomCollectionViewCell.m
//  CustomLayout
//
//  Created by Fay on 16/3/12.
//  Copyright © 2016年 Fay. All rights reserved.
//

#import "CustomCollectionViewCell.h"

@interface CustomCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@end

@implementation CustomCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

-(void)setImageName:(NSString *)imageName {
    _imageName = [imageName copy];
    
    self.imageView.image = [UIImage imageNamed:imageName];
}

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com
