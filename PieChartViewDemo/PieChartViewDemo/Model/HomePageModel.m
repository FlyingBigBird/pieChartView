//
//  HomePageModel.m
//  FotileCSS
//
//  Created by BaoBaoDaRen on 2018/7/17.
//  Copyright © 2018年 康振超. All rights reserved.
//

#import "HomePageModel.h"

@implementation HomePageModel

- (NSString *)nameStr
{
    if (!_nameStr)
    {
        _nameStr = @"";
    }
    return _nameStr;
}

- (NSString *)countStr
{
    if (!_countStr)
    {
        _countStr = @"";
    }
    return _countStr;
}

- (NSArray *)listArr
{
    if (!_listArr)
    {
        _listArr = [[NSArray alloc] init];
    }
    return _listArr;
}


- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

@end
