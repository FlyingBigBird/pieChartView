//
//  ViewController.m
//  PieChartViewDemo
//
//  Created by BaoBaoDaRen on 2018/12/3.
//  Copyright © 2018年 BaoBao. All rights reserved.
//

#import "ViewController.h"
#import "PieChartView.h"
#import "masonry.h"
#import "PieChartIndicatorView.h"
#import "HomePageModel.h"
#import "PieChartModel.h"


#define WeakSelf(type)  __weak typeof(type) weak##type = type; // weak
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
// 字符串是否为空
#define IsStrEmpty(_ref)    (((_ref) == nil) || ([(_ref) isEqualToString:@"(null)"]) || ([(_ref) isEqualToString:@"(Null)"]) || ([(_ref) isEqualToString:@"(NULL)"]) || ([(_ref) isEqualToString:@"(null)"]) || ([(_ref) isEqualToString:@"<null>"]) || ([(_ref) isEqual:[NSNull null]]) || ([(_ref) isEqualToString:@""]) || ([(_ref) length] == 0))

// 数组是否为空
#define IsArrEmpty(_ref)    (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]) || ([(_ref) count] == 0))
#define L(_ref) [NSString stringWithFormat:@"%@",_ref]

#define is_Pad ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)

#define IS_IPHONE_X ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) && !is_Pad : NO)
//判断iPhoneXr
#define IS_IPHONE_Xr ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(828, 1792), [[UIScreen mainScreen] currentMode].size) && !is_Pad : NO)
//判断iPhoneXsMax
#define IS_IPHONE_Xs_Max ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2688), [[UIScreen mainScreen] currentMode].size)&& !is_Pad : NO)

//判断iPhoneX所有系列
#define ISIPhoneXSeries (IS_IPHONE_X || IS_IPHONE_Xr || IS_IPHONE_Xs_Max)
#define StatusBar_H (ISIPhoneXSeries ? 44.0 : 20.0)
#define NavBar_H         44
#define TabBar_H  (ISIPhoneXSeries ? 83.0 : 49.0)


@interface ViewController ()

@property (nonatomic, strong) UIScrollView * caroselScrollView;
@property (nonatomic, strong) NSTimer *scrollTimer;
@end

@implementation ViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.view.backgroundColor = [UIColor whiteColor];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [self.scrollTimer invalidate];
    self.scrollTimer = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // 服务器返回数据替换此处假数据...
    NSArray *bannerArr = @[
                           @{
                               @"countStr":@"1",
                               @"nameStr":@"第一",
                               @"listArr":@[@{@"num":@"1",@"status":@"1"},@{@"num":@"2",@"status":@"2"},@{@"num":@"3",@"status":@"3"},@{@"num":@"4",@"status":@"4"}],
                               },
                           @{
                               @"countStr":@"1",
                               @"nameStr":@"第一",
                               @"listArr":@[@{@"num":@"1",@"status":@"1"},@{@"num":@"2",@"status":@"2"},@{@"num":@"3",@"status":@"3"},@{@"num":@"4",@"status":@"4"}],
                               },
                           @{
                               @"countStr":@"1",
                               @"nameStr":@"第一",
                               @"listArr":@[@{@"num":@"1",@"status":@"1"},@{@"num":@"2",@"status":@"2"},@{@"num":@"3",@"status":@"3"},@{@"num":@"4",@"status":@"4"}],
                               },
                           ];
    
    // 初始化scrollView...
    [self.caroselScrollView removeFromSuperview];
    self.caroselScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 170)];
    [self.view addSubview:self.caroselScrollView];
    [self.caroselScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 170));
        make.center.mas_equalTo(self.view);
        
    }];
    
    self.caroselScrollView.contentSize = CGSizeMake(SCREEN_WIDTH * bannerArr.count, 170);
    self.caroselScrollView.scrollEnabled = YES;
    self.caroselScrollView.showsHorizontalScrollIndicator = NO;
    self.caroselScrollView.bounces = NO;
    self.caroselScrollView.pagingEnabled = YES;

    [self setScrollPieChartViewWithPieChartData:bannerArr];

    
    self.scrollTimer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(pageControlBeginRotate) userInfo:nil repeats:YES];
}
#pragma mark - 绘制饼状图
- (void)setScrollPieChartViewWithPieChartData:(NSArray *)chartArr
{
    for (int i = 0; i < chartArr.count; i++)
    {
        PieChartIndicatorView * indicatorView = [[PieChartIndicatorView alloc] initWithFrame:CGRectMake(self.caroselScrollView.frame.size.width / 3 * 2 + self.caroselScrollView.frame.size.width * i, 0, self.caroselScrollView.frame.size.width / 3, self.caroselScrollView.frame.size.height)];
        [indicatorView setPieChartIndicatorViewSubsAtIndex:i withData:chartArr];
        [self.caroselScrollView addSubview:indicatorView];
        
        PieChartView * chart = [[PieChartView alloc] initWithFrame:CGRectMake(25 + self.caroselScrollView.frame.size.width * i, 10, self.caroselScrollView.frame.size.width / 3 * 2 - 25, self.caroselScrollView.frame.size.height)];
        [self.caroselScrollView addSubview:chart];
        
        NSDictionary *dic = chartArr[i];
        HomePageModel * homeModel = [[HomePageModel alloc] init];
        [homeModel setValuesForKeysWithDictionary:dic];
        
        if (!IsArrEmpty(homeModel.listArr))
        {
            CGFloat maxValue = 0;
            for (int i = 0; i < homeModel.listArr.count; i++)
            {
                NSString * getNum = L([homeModel.listArr[i] objectForKey:@"num"]);
                if (IsStrEmpty(getNum))
                {
                    maxValue += 0;
                } else
                {
                    maxValue  += [getNum floatValue];
                }
            }
            
            NSMutableArray * dataArray1 = [NSMutableArray array];
            for (int i = 0; i < homeModel.listArr.count; i++)
            {
                PieChartModel *model = [[PieChartModel alloc] init];
                
                NSString * getNum = L([homeModel.listArr[i] objectForKey:@"num"]);
                model.name = getNum;
                model.value = 423651.23;
                if ([model.name isEqualToString:@"0"] || IsStrEmpty(model.name))
                {
                    model.rate = 0;
                } else
                {
                    model.rate = [model.name floatValue] / maxValue;
                }
                [dataArray1 addObject:model];
            }
            chart.dataArray = [NSMutableArray arrayWithArray:dataArray1];
            [chart draw];
        } else
        {
            PieChartModel *model = [[PieChartModel alloc] init];
            
            model.rate = 1;
            model.name = @"0";
            model.value = 423651.23;
            chart.dataArray = @[model];
            [chart draw];
        }
    }
}
- (void)pageControlBeginRotate
{
    CGFloat getOffset = self.caroselScrollView.contentOffset.x;
    getOffset += self.caroselScrollView.frame.size.width;
    
    
    WeakSelf(self);
    if (getOffset >= self.caroselScrollView.frame.size.width * 3)
    {
        [UIView transitionWithView:self.caroselScrollView duration:0.5 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
            
            weakself.caroselScrollView.contentOffset = CGPointMake(0, 0);
        } completion:^(BOOL finished) {
            
        }];
    } else
    {
        [UIView transitionWithView:self.caroselScrollView duration:0.5 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
            
            weakself.caroselScrollView.contentOffset = CGPointMake(getOffset, 0);
        } completion:^(BOOL finished) {
            
        }];
    }
}






- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
