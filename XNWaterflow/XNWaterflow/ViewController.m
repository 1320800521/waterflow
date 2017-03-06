//
//  ViewController.m
//  XNWaterflow
//
//  Created by 小鸟 on 2017/3/1.
//  Copyright © 2017年 小鸟. All rights reserved.
//

#import "ViewController.h"
#import "XNWaterFlowLayout.h"
#import "XNWaterFlowCollectionViewCell.h"
#import "XNWaterFlowHeadCollectionReusableView.h"

//#import "XRWaterfallLayout.h"

@interface ViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic,strong) UICollectionView *waterFlow;

@property (nonatomic,strong) UIView *headerView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self configer];
}

- (void)configer{
    
    
    self.headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, self.view.frame.size.width, 200)];
    self.headerView.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.headerView];
    
    XNWaterFlowLayout *layout = [XNWaterFlowLayout waterFallLayoutWithColumnCount:4];
    layout.headerReferenceSize = CGSizeMake(self.view.frame.size.width, 400);
    
    [layout setColumnSpacing:10 rowSpacing:10 sectionInset:UIEdgeInsetsMake(10, 10, 10, 10)];
    
    layout.itemHeightBlock = ^CGFloat(CGFloat itemWidth,NSIndexPath *indexPath){
        //根据图片的原始尺寸，及显示宽度，等比例缩放来计算显示
        return 50 + arc4random()%50;
    };

    self.waterFlow = [[UICollectionView alloc]initWithFrame:CGRectMake(0, self.headerView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height) collectionViewLayout:layout];
    self.waterFlow.backgroundColor = [UIColor whiteColor];
    [self.waterFlow registerNib:[UINib nibWithNibName:@"XNWaterFlowCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
    [self.waterFlow registerNib:[UINib nibWithNibName:@"XNWaterFlowHeadCollectionReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    self.waterFlow.delegate = self;
    self.waterFlow.dataSource = self;
    [self.view addSubview:self.waterFlow];
    
    [self.waterFlow addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
    CGPoint point = [change[@"new"] CGPointValue];
    
    
    self.headerView.frame = CGRectMake(self.headerView.frame.origin.x, -point.y, self.headerView.frame.size.width, self.headerView.frame.size.height);
                
    self.waterFlow.frame = CGRectMake(self.waterFlow.frame.origin.x, ((self.headerView.frame.size.height - point.y) >= 0)?(self.headerView.frame.size.height - point.y):0, self.waterFlow.frame.size.width, self.view.frame.size.height);
    
    
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        XNWaterFlowHeadCollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"header" forIndexPath:indexPath];
        
        UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
        
        headerView.backgroundColor = [UIColor redColor];
        [header addSubview:headerView];
        
        return header;
    }
    
    return nil;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 50;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    XNWaterFlowCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.imagView.image = [UIImage imageNamed:@"bb"];
    cell.clickBlcok = ^{
    
        NSLog(@"----  %ld",(long)indexPath.row);
        
    };
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
