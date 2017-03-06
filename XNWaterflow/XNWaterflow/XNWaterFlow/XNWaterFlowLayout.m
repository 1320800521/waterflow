//
//  XNWaterFlowLayout.m
//  XNWaterflow
//
//  Created by 小鸟 on 2017/3/2.
//  Copyright © 2017年 小鸟. All rights reserved.
//

#import "XNWaterFlowLayout.h"

@interface XNWaterFlowLayout ()

/**
 记录每一列的最大Y
 */
@property (nonatomic, strong) NSMutableDictionary *maxYDict;

/**
 记录每个item的attributes
 */
@property (nonatomic, strong) NSMutableArray *layoutAttributesArray;

@end

@implementation XNWaterFlowLayout

- (NSMutableDictionary *)maxYDict{
    
    if (!_maxYDict) {
        _maxYDict = [[NSMutableDictionary alloc]init];
    }
    return _maxYDict;
}

- (instancetype)init {
    if (self = [super init]) {
        self.columnCount = 2;
    }
    return self;
}


- (NSMutableArray *)layoutAttributesArray{
    
    if (!_layoutAttributesArray) {
        _layoutAttributesArray = [NSMutableArray array];
    }
    
    return _layoutAttributesArray;
}

- (void)setColumnSpacing:(NSInteger)columnSpacing rowSpacing:(NSInteger)rowSepacing sectionInset:(UIEdgeInsets)sectionInset{
    
    self.columnSpacing = columnSpacing;
    self.rowSpacing = rowSepacing;
    self.sectionInset = sectionInset;
}

- (instancetype)initWithColumnCount:(NSInteger)columnCount {
    if (self = [super init]) {
        self.columnCount = columnCount;
    }
    return self;
}


+ (instancetype)waterFallLayoutWithColumnCount:(NSInteger)columnCount {
    
    return [[self alloc] initWithColumnCount:columnCount];
}


/**
 预加载
 */
- (void)prepareLayout{
    [super prepareLayout];
    
    for (NSInteger i = 0; i < self.columnCount; i ++) {
        self.maxYDict[@(i)] = @(self.sectionInset.top);
    }
    
    // 获取item总数
    NSInteger itemCount = [self.collectionView numberOfItemsInSection:0];
    [self.layoutAttributesArray removeAllObjects];
    
    // 为每个item创建一个attributes并保存
    for (NSInteger i = 0; i < itemCount; i ++) {
        UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        [self.layoutAttributesArray addObject:attributes];
    }
}

- (CGSize)collectionViewContentSize{
    __block NSNumber *maxIndex = @0;
    
    [self.maxYDict enumerateKeysAndObjectsUsingBlock:^(NSNumber *key,NSNumber *obj,BOOL *isok){
    
        if ([self.maxYDict[maxIndex] floatValue] < obj.floatValue) {
            maxIndex = key;
        }
    }];
 
    //collectioncell的contentSize.height就等于最长列的最大y值+下内边距
    return CGSizeMake(0, [self.maxYDict[maxIndex] floatValue] + self.sectionInset.bottom);

}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    //根据indexPath获取item的attributes
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    //获取collectionView的宽度
    CGFloat collectionViewWidth = self.collectionView.frame.size.width;
    
    //item的宽度 = (collectionView的宽度 - 内边距与列间距) / 列数
    CGFloat itemWidth = (collectionViewWidth - self.sectionInset.left - self.sectionInset.right - (self.columnCount - 1) * self.columnSpacing) / self.columnCount;
    
    CGFloat itemHeight = 0;
    //获取item的高度，由外界计算得到
    if (self.itemHeightBlock) itemHeight = self.itemHeightBlock(itemWidth, indexPath);
    
    //找出最短的那一列
    __block NSNumber *minIndex = @0;
    [self.maxYDict enumerateKeysAndObjectsUsingBlock:^(NSNumber *key, NSNumber *obj, BOOL *stop) {
        if ([self.maxYDict[minIndex] floatValue] > obj.floatValue) {
            minIndex = key;
        }
    }];
    
    //根据最短列的列数计算item的x值
    CGFloat itemX = self.sectionInset.left + (self.columnSpacing + itemWidth) * minIndex.integerValue;
    
    //item的y值 = 最短列的最大y值 + 行间距
    CGFloat itemY = [self.maxYDict[minIndex] floatValue] + self.rowSpacing;
    
    //设置attributes的frame
    attributes.frame = CGRectMake(itemX, itemY, itemWidth, itemHeight);
    
    //更新字典中的最大y值
    self.maxYDict[minIndex] = @(CGRectGetMaxY(attributes.frame));
    
    return attributes;
}


//- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
//
//    // 根据indexpath获取item的attributs
//    UICollectionViewLayoutAttributes *attribuutes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
//    
//    // 获取collectionView的宽度
//    CGFloat collectViewWidth = self.collectionView.frame.size.width;
//    
//    // 计算每个item宽度
//    CGFloat itemWidth = (collectViewWidth - self.sectionInset.left - self.sectionInset.right - (self.columnCount - 1) * self.columnSpacing) /  self.columnCount;
//    
//    CGFloat itemHight = 0;
//    // 获取item高
//    if (self.itemHeightBlock) {
//        itemHight = self.itemHeightBlock(itemWidth,indexPath);
//    }
//    // 寻找最短的一列
//    __block NSNumber *shortIndex = @0;
//    [self.maxYDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
//        if ([self.maxYDict[shortIndex] floatValue] > [obj floatValue]) {
//            shortIndex = key;
//        }
//    }];
//    
//    // 根据最短一列计算item的x值
//    CGFloat itemX = self.sectionInset.left + (self.columnSpacing + itemWidth) * shortIndex.integerValue;
//    // 最短列的Y+ 行间距
//    CGFloat itemY = [self.maxYDict[shortIndex]floatValue] + self.rowSpacing;
//    
//    // 设置frame
//    attribuutes.frame = CGRectMake(itemX, itemY, itemWidth, itemHight);
//    
//    // 更新最大Y值
//    self.maxYDict[shortIndex] = @(CGRectGetMaxY(attribuutes.frame));
//
//    return attribuutes;
//}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect{
    
    return self.layoutAttributesArray;
}

@end
