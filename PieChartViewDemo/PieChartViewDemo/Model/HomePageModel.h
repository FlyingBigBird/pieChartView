//
//  HomePageModel.h
//  FotileCSS
//
//  Created by BaoBaoDaRen on 2018/7/17.
//  Copyright © 2018年 康振超. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface HomePageModel : NSObject

@property (nonatomic, copy) NSString * countStr;
@property (nonatomic, copy) NSString * nameStr;
@property (nonatomic, strong) NSArray  * listArr;

/**
 名称
 */
@property (nonatomic, copy) NSString *name;

/**
 数值
 */
@property (nonatomic, assign) CGFloat value;

/**
 比例
 */
@property (nonatomic, assign) CGFloat rate;

@end
