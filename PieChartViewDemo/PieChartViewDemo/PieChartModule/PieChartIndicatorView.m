//
//  PieChartIndicatorView.m
//  FotileCSS
//
//  Created by BaoBaoDaRen on 2018/6/21.
//  Copyright © 2018年 康振超. All rights reserved.
//

#import "PieChartIndicatorView.h"
#import "UILabel+LabCornerRadius.h"
#import "UIColor+UIColor_HexString.h"
#import "HomePageModel.h"

#define L(_ref) [NSString stringWithFormat:@"%@",_ref]
#define GGrayColor [UIColor colorWithHexString:@"#999999"]
#define GClearColor [UIColor clearColor]

@implementation PieChartIndicatorView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        
    }
    return self;
}


- (void)setPieChartIndicatorViewSubsAtIndex:(int)index withData:(NSArray *)dataArr
{    
//    NSArray * imgArr = @[[UIImage imageNamed:@""],[UIImage imageNamed:@""],[UIImage imageNamed:@""],[UIImage imageNamed:@""],[UIImage imageNamed:@""]];
    
    NSDictionary *dic = dataArr[index];
    HomePageModel * model = [[HomePageModel alloc] init];
    [model setValuesForKeysWithDictionary:dic];

    NSArray * listArr = model.listArr;
    
    NSInteger squareNum = listArr.count;// (photoArr.count)
    CGFloat verticalM = 2;
    CGFloat viewWidth = 80;
    CGFloat viewHeight = 20;
    CGFloat leftM = self.frame.size.width / 2 - viewWidth / 2;
    CGFloat topM = (self.frame.size.height - squareNum * viewHeight - verticalM * (squareNum - 1)) / 2;
    
    for (int i = 0; i < squareNum; i++)
    {
        CGFloat getLeftM = leftM;
        CGFloat getTopM = topM + viewHeight * i + verticalM * i;
        UIView * bgView = [[UIView alloc] initWithFrame:CGRectMake(getLeftM, getTopM, viewWidth, viewHeight)];
        [self addSubview:bgView];
        
        UIImageView * outImgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, viewHeight / 2 - 12 / 2, 12, 12)];
        [bgView addSubview:outImgView];
        outImgView.layer.masksToBounds = YES;
        outImgView.layer.cornerRadius = 12 / 2;
        
//        if (i < imgArr.count) {
//
//            outImgView.image = imgArr[i];
//        } else {
//
//            outImgView.image = imgArr[i % imgArr.count];
//        }
        outImgView.backgroundColor = [UIColor redColor];
        
        UILabel * titLab = [[UILabel alloc] initWithFrame:CGRectMake(12 + 10 * 2, 0, viewWidth - (12 + 10 * 2), viewHeight)];
        [bgView addSubview:titLab];
        [titLab resetLabelCornerRadius:0 withTitleColor:GGrayColor withBgColor:GClearColor withTitleFont:12 withNumberLine:1];
        titLab.text = @"状态";

    }
}

@end
