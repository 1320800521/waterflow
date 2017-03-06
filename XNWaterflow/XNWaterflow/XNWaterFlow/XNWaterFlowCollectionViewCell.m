//
//  XNWaterFlowCollectionViewCell.m
//  XNWaterflow
//
//  Created by 小鸟 on 2017/3/2.
//  Copyright © 2017年 小鸟. All rights reserved.
//

#import "XNWaterFlowCollectionViewCell.h"

@implementation XNWaterFlowCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.imagView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGes:)];
    tap.delegate = self;
    [self.imagView addGestureRecognizer:tap];
    
}

- (void)tapGes:(UITapGestureRecognizer *)tap{
    
    if (self.clickBlcok) {
        self.clickBlcok();
    }
}


@end
