//
//  XZSecKillViewController.m
//  WeiZhiUser
//
//  Created by Mekor on 8/8/16.
//  Copyright © 2016 WeiZhi. All rights reserved.
//

#import "XZSecKillViewController.h"
#import "MJExtension.h"
#import "SecKillModel.h"
#import "SecKillCollectionViewCell.h"
#import "XZSecKillFlowLayout.h"
#import <UIKit/UIKit.h>
#import "XZSecKillTimeViewController.h"


static const CGFloat topViewHeight = 44;
static NSString *const identifier = @"SecKillCollectionViewCell";

@interface XZSecKillViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate> {
    CGFloat pageWidth;
}
/// 顶部滚动标题栏
@property (nonatomic, strong)UICollectionView *topView;
/// 内容滚动
@property (nonatomic, strong)UIScrollView *contentScrollView;

@property (nonatomic, strong) NSArray<Datalist *> *datalist;
@property (nonatomic, weak) XZSecKillFlowLayout *flowLayout;
@property(nonatomic,strong)XZSecKillTimeViewController *needScrollToTopPage;
@end

@implementation XZSecKillViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    // 进行网络请求
    [self getRequest];
    
}


- (void)getRequest {
    NSString *patch = [[NSBundle mainBundle] pathForResource:@"datajson" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:patch];
    // 字典转模型
    SecKillModel *model = [SecKillModel objectWithJSONData:data];
    NSLog(@"%@",model);
    self.datalist = model.datalist;
    
    
    // 根据数据创建显示内容
    [self configInterface];
}

- (void)configInterface {
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.topView = ({
        
        XZSecKillFlowLayout *flowLayout = [[XZSecKillFlowLayout alloc] init];
        
        pageWidth = SCREEN_WIDTH/4;
        // 根据时间个数确定宽度
        if(self.datalist.count<4){
            pageWidth = SCREEN_WIDTH/self.datalist.count;
        }
        
        flowLayout.itemSize = CGSizeMake(pageWidth, 44);
        self.flowLayout = flowLayout;
        
        UICollectionView *view = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, topViewHeight) collectionViewLayout:flowLayout];
        view.backgroundColor = [UIColor redColor];
        view.showsHorizontalScrollIndicator = NO;
        view.delegate = self;
        view.dataSource = self;
        view.pagingEnabled = NO;
        UINib *nib = [UINib nibWithNibName:@"SecKillCollectionViewCell" bundle:nil];
        [view registerNib:nib forCellWithReuseIdentifier:identifier];
        [self.view addSubview:view];
        view;
    });
    
    self.contentScrollView = ({
        UIScrollView *view = [[UIScrollView alloc]initWithFrame:CGRectMake(0, self.topView.bottom, SCREEN_WIDTH, SCREEN_HEIGHT - self.topView.bottom)];
        view.delegate = self;
        view.backgroundColor = [UIColor yellowColor];
        view.pagingEnabled = YES;
        view.scrollsToTop = NO;
        [self.view addSubview:view];
        view;
    });
    
    // 添加时间段显示的秒杀界面
    CGFloat width = self.contentScrollView.width;
    CGFloat height = self.contentScrollView.height;
    
    // 添加所有子控制器
    [self addChildViewController];
    
    [self.contentScrollView setContentSize:CGSizeMake(width * self.datalist.count, height)];
    
    // 添加默认控制器
    UIViewController *vc = [self.childViewControllers firstObject];
    vc.view.frame = self.contentScrollView.bounds;
    [self.contentScrollView addSubview:vc.view];
    self.needScrollToTopPage = self.childViewControllers[0];
}

/// 创建显示的控制器
- (void)addChildViewController{
    
    for (int i= 0; i< self.datalist.count; i++) {
        XZSecKillTimeViewController *vc = [[XZSecKillTimeViewController alloc]init];
        vc.detail = self.datalist[i];
        [self addChildViewController:vc];
    }
}


#pragma mark - <UICollectionViewDelegate,UICollectionViewDataSource>
#pragma mark UICollectionViewDataSource
//定义展示的Section的个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSLog(@"创建个数%zd",self.datalist.count);
    return self.datalist.count;
}
//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SecKillCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    cell.detail = self.datalist[indexPath.item];
    cell.tag = indexPath.item;
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self scrollToSelectedPage:indexPath.item];

    [self setScrollToTopWithTableViewIndex:indexPath.item];
}

#pragma mark - UIScrollViewDelegate
//#pragma mark - 阻止惯性继续滑动
//- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
//    // 阻止惯性继续滑动
//    [scrollView setContentOffset:scrollView.contentOffset animated:NO];
//}
/** 滚动结束后调用（代码导致） */
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{

    if (scrollView == self.topView) {
        // 获得索引
        NSUInteger index = 0;
        int screenCenter = self.topView.contentOffset.x + self.topView.frame.size.width/2;
        // 取cell
        NSArray *array = self.topView.visibleCells;
        for (SecKillCollectionViewCell *cell in array) {
            int cellX = cell.centerX;
            if (cellX == screenCenter) {
                index = cell.tag;
            }
        }
        [self setScrollToTopWithTableViewIndex:index];
        return;
    }
    
    // 获得索引
    NSUInteger index = scrollView.contentOffset.x / self.contentScrollView.frame.size.width;
    // 添加控制器
    XZSecKillTimeViewController *newsVc = self.childViewControllers[index];
    newsVc.detail = self.datalist[index];
    
    [self setScrollToTopWithTableViewIndex:index];
    
    if (!newsVc.view.superview){
        newsVc.view.frame = scrollView.bounds;
        [self.contentScrollView addSubview:newsVc.view];
    }
    // topView滚动到相应的位置
    [self scrollToSelectedPage:index];
}
/** 滚动结束（手势导致） */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollViewDidEndScrollingAnimation:scrollView];
}


#pragma mark - private

#pragma mark ScrollToTop

- (void)setScrollToTopWithTableViewIndex:(NSInteger)index
{
    CGFloat offsetX = index * self.contentScrollView.frame.size.width;
    
    CGFloat offsetY = self.contentScrollView.contentOffset.y;
    CGPoint offset = CGPointMake(offsetX, offsetY);
    
    [self.contentScrollView setContentOffset:offset animated:YES];
    self.needScrollToTopPage.tableView.scrollsToTop = NO;
    self.needScrollToTopPage = self.childViewControllers[index];
    self.needScrollToTopPage.tableView.scrollsToTop = YES;
}
#pragma mark 根据page滚动到相应位置
- (void)scrollToSelectedPage:(NSInteger)page {
    // 当前cell 的位置
    // 取出屏幕的中心点
    
    CGFloat screenCenter = self.topView.contentOffset.x  + self.topView.frame.size.width/2;
    // 没有 section margin 的center
    CGPoint currentPageCenter = CGPointMake((page+0.5) * pageWidth, 0);
    // section margin
    CGFloat sectionMargin = self.flowLayout.sectionInset.left;
    
    CGFloat distance =  currentPageCenter.x + sectionMargin - screenCenter;
    // 计算出目标点
    CGPoint destPoint = CGPointMake(self.topView.contentOffset.x + distance, 0);
    
    
    // 动画移动到指定位置
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseOut|UIViewAnimationOptionAllowUserInteraction animations:^{
        self.topView.contentOffset = destPoint;
    } completion:nil];
}
@end
