//
//  XZSecKillFlowLayout.m
//  SecKillDemo
//
//  Created by Mekor on 8/8/16.
//  Copyright © 2016 李小争. All rights reserved.
//

#import "XZSecKillFlowLayout.h"

@implementation XZSecKillFlowLayout

-(void)prepareLayout {
    [super prepareLayout];
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.minimumLineSpacing = 0;
    // 收尾距离  View宽度 - 中间Item的宽度 的 一半
    CGFloat margin = (self.collectionView.frame.size.width - self.itemSize.width)*0.5;
    self.sectionInset = UIEdgeInsetsMake(0, margin,0, margin);
}

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity {
    
    // 取出屏幕的中心点
    CGFloat screenCenter = self.collectionView.contentOffset.x + self.collectionView.frame.size.width/2;
    
    // 这一步，取出手指离开时，屏幕上显式的cell
    CGRect nowVisibleRect = (CGRect){self.collectionView.contentOffset, self.collectionView.frame.size};
    
    NSArray<UICollectionViewLayoutAttributes*>* nowAttributes = [self layoutAttributesForElementsInRect:nowVisibleRect];
    
    // 计算哪个cell距离屏幕中心最近
    CGFloat minDistance = CGFLOAT_MAX;
    int minIndex = -1;
    for(int i = 0; i < nowAttributes.count; i++) {
        UICollectionViewLayoutAttributes* attr = nowAttributes[i];
        CGFloat distance =  attr.center.x - screenCenter;
        if (fabs(distance) < fabs(minDistance)) {
            minDistance = distance;
            minIndex = i;
        }
    }
    
    // 当力度大于0.3时，说明一定要切换到另一页
    NSLog(@"%f", velocity.x);
    if (fabs(velocity.x) > 0.3) {
        
        // 右边还有元素
        if ( velocity.x > 0 && nowAttributes.count-1 > minIndex) {
            minDistance = nowAttributes[minIndex+1].center.x - screenCenter;
        }else if(velocity.x < 0 && minIndex > 0) {
            minDistance = nowAttributes[minIndex-1].center.x - screenCenter;
        }
    }
    
    // 计算出目标点
    CGPoint destPoint = CGPointMake(self.collectionView.contentOffset.x + minDistance, proposedContentOffset.y);
    
    
    // 动画移动到指定位置
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseOut|UIViewAnimationOptionAllowUserInteraction animations:^{
        self.collectionView.contentOffset = destPoint;
    } completion:nil];
    
    // 返回值已经没有什么意义了
    return destPoint;
}


@end
