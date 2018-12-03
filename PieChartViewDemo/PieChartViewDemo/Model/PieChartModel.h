//
//  PieChartModel.h
//  FotileCSS
//
//  Created by BaoBaoDaRen on 2018/6/21.
//  Copyright © 2018年 康振超. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PieChartModel : NSObject

/**
 名称
 */
@property (copy, nonatomic) NSString *name;

/**
 数值
 */
@property (assign, nonatomic) CGFloat value;

/**
 比例
 */
@property (assign, nonatomic) CGFloat rate;

@end
