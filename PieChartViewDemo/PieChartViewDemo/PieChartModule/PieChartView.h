//
//  PieChartView.h
//  FotileCSS
//
//  Created by BaoBaoDaRen on 2018/6/21.
//  Copyright © 2018年 康振超. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PieChartView : UIView

/**
 数据数组
 */
@property (strong, nonatomic) NSArray *dataArray;

/**
 标题
 */
@property (copy, nonatomic) NSString *title;

/**
 绘制方法
 */
- (void)draw;

@end
