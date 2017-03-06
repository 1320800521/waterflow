//
//  XNWaterFlowCollectionViewCell.h
//  XNWaterflow
//
//  Created by 小鸟 on 2017/3/2.
//  Copyright © 2017年 小鸟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XNWaterFlowCollectionViewCell : UICollectionViewCell<UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imagView;

@property (nonatomic,copy) void (^clickBlcok)(void);

@end
