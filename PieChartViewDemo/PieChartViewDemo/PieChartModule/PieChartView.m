//
//  PieChartView.m
//  FotileCSS
//
//  Created by BaoBaoDaRen on 2018/6/21.
//  Copyright © 2018年 康振超. All rights reserved.
//

#import "PieChartView.h"
#import "PieChartModel.h"
#import "PieChartCenterView.h"
#import "UIColor+UIColor_HexString.h"

#define radian RADIAN
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
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


@interface PieChartView ()

@property (nonatomic, strong) NSMutableArray *modelArray;
@property (nonatomic, strong) NSMutableArray *colorArray;

@end

@implementation PieChartView


- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)draw {
    
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    
#pragma mark - 适配机型调整饼状图面积比例,调这里...
    CGFloat chartMargin = 60;
    if (iPhone5)
    {
        chartMargin = 30;
    } else if(iPhone6)
    {
        chartMargin = 45;
    }
    
    CGFloat min = self.bounds.size.width;
    
    CGPoint center =  CGPointMake(self.bounds.size.width * 0.5, self.bounds.size.height * 0.5);
    CGFloat radius = min * 0.5 - chartMargin;
    
    CGFloat start = 0;
    CGFloat angle = 0;
    CGFloat end = start;
    
    NSArray * COLOR_ARRAY = @[[UIColor colorWithHexString:@"#FF4945"],[UIColor colorWithHexString:@"#FFB743"],[UIColor colorWithHexString:@"#1CD1B3"],[UIColor colorWithHexString:@"#35BADB"],[UIColor colorWithHexString:@"#7BA0E7"]];
    
    if (self.dataArray.count == 0) {
        
        end = start + M_PI * 2 ;
        UIColor *color = COLOR_ARRAY.firstObject;
        
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:start endAngle:end clockwise:true];
        [color set];
        
        //添加一根线到圆心
        [path addLineToPoint:center];
        [path fill];
        
    } else {
        
        NSMutableArray *pointArray = [NSMutableArray array];
        NSMutableArray *centerArray = [NSMutableArray array];
        
        self.modelArray = [NSMutableArray array];
        self.colorArray = [NSMutableArray array];
        
        for (int i = 0; i < self.dataArray.count; i++) {
            
            // 获取占比，通过占比计算圆弧画的角度，到y轴、x轴，旋转角度,赋予色值...
            PieChartModel *model = self.dataArray[i];
            CGFloat percent = model.rate;
            
            UIColor *color = COLOR_ARRAY[0];
            
            if (i < COLOR_ARRAY.count) {
                
                color = COLOR_ARRAY[i];
            } else {
                
                color = COLOR_ARRAY[i % COLOR_ARRAY.count];
            }
            
            start = end;
            angle = percent * M_PI * 2;
            end = start + angle;
            
            UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:start endAngle:end clockwise:true];
            [color set];
            
            //添加一根线到圆心
            [path addLineToPoint:center];
            [path fill];
            
            // 获取弧度的中心角度
            CGFloat radianCenter = (start + end) * 0.5;
            
            // 获取指引线的起点
            CGFloat lineStartX = self.frame.size.width * 0.5 + radius * cos(radianCenter) / 6 * 5;
            CGFloat lineStartY = self.frame.size.height * 0.5 + radius * sin(radianCenter) / 6 * 5;
            CGPoint point = CGPointMake(lineStartX, lineStartY);
            
            if (i <= self.dataArray.count / 2 - 1) {
                
                [pointArray insertObject:[NSValue valueWithCGPoint:point] atIndex:0];
                [centerArray insertObject:[NSNumber numberWithFloat:radianCenter] atIndex:0];
                [self.modelArray insertObject:model atIndex:0];
                [self.colorArray insertObject:color atIndex:0];
            } else {
                
                [pointArray addObject:[NSValue valueWithCGPoint:point]];
                [centerArray addObject:[NSNumber numberWithFloat:radianCenter]];
                [self.modelArray addObject:model];
                [self.colorArray addObject:color];
            }
        }
        
        CAShapeLayer *layer = [CAShapeLayer new];
        layer.lineWidth = 2;
        
        //圆环的颜色
        layer.strokeColor = [UIColor colorWithRed:254 / 255.0 green:254 / 255.0 blue:254 / 255.0 alpha:0.65].CGColor;
        
        //背景填充色
        layer.fillColor = [UIColor clearColor].CGColor;
        
        //半径
        CGFloat radius = 47;
        if (iPhone5)
        {
            radius = 48;
        } else if(iPhone6)
        {
            radius = 47;
        }
        
        //按照顺时针方向
        BOOL clockWise = true;
        
        CGFloat end1 = start + M_PI * 2;
        
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:start endAngle:end1 clockwise:clockWise];
        layer.path = [path CGPath];
        [self.layer addSublayer:layer];
        
        // 通过pointArray绘制指引线
        [self drawLineWithPointArray:pointArray centerArray:centerArray];
    }
    
    // 在中心添加label
    PieChartCenterView *centerView = [[PieChartCenterView alloc] init];
    centerView.frame = CGRectMake(0, 0, 80, 80);
    
    CGRect frame = centerView.frame;
    frame.origin = CGPointMake(self.frame.size.width * 0.5 - frame.size.width * 0.5, self.frame.size.height * 0.5 - frame.size.width * 0.5);
    centerView.frame = frame;
    centerView.nameLabel.text = self.title;
    [self addSubview:centerView];
}

- (void)drawLineWithPointArray:(NSArray *)pointArray centerArray:(NSArray *)centerArray {
    
    // 记录每一个指引线包括数据所占用位置的和（总体位置）
    CGRect rect = CGRectZero;
    
    // 用于计算指引线长度
    CGFloat width = self.bounds.size.width * 0.5;
    
    for (int i = 0; i < pointArray.count; i++) {
        
        // 取出数据
        NSValue *value = pointArray[i];
        
        // 每个圆弧中心点的位置
        CGPoint point = value.CGPointValue;
        
        // 每个圆弧中心点的角度
        CGFloat radianCenter = [centerArray[i] floatValue];
        
        // 颜色（绘制数据时要用）
        UIColor *color = self.colorArray[i % 6];
        
        // 模型数据（绘制数据时要用）
        PieChartModel *model = self.modelArray[i];
        
        // 模型的数据
        NSString *name = model.name;
        
        // 圆弧中心点的x值和y值
        CGFloat x = point.x;
        CGFloat y = point.y;
        
        // 指引线终点的位置（x, y）
        CGFloat startX = x + 10 * cos(radianCenter);
        CGFloat startY = y + 10 * sin(radianCenter);
         
        // 指引线转折点的位置(x, y)
        CGFloat breakPointX = x + 20 * cos(radianCenter);
        CGFloat breakPointY = y + 20 * sin(radianCenter);
        
        // 转折点到中心竖线的垂直长度（为什么+20, 在实际做出的效果中，有的转折线很丑，+20为了美化）
        CGFloat margin = fabs(width - breakPointX) + 20;
        
        // 指引线长度
        CGFloat lineWidth = width - margin;
        
        // 指引线起点（x, y）
        CGFloat endX;
        CGFloat endY;
        
        // 绘制文字和数字时，所占的size（width和height）
        // width使用lineWidth更好，我这么写固定值是为了达到产品要求
        CGFloat numberWidth = 80.f;
        CGFloat numberHeight = 15.f;
        
        CGFloat titleWidth = numberWidth;
        CGFloat titleHeight = numberHeight;
        
        // 绘制文字和数字时的起始位置（x, y）与上面的合并起来就是frame
        CGFloat numberX;// = breakPointX;
        CGFloat numberY = breakPointY - numberHeight;
        
        CGFloat titleX = breakPointX;
        CGFloat titleY = breakPointY + 2;
        
        // 文本段落属性(绘制文字和数字时需要)
        NSMutableParagraphStyle * paragraph = [[NSMutableParagraphStyle alloc]init];
        // 文字靠右
        paragraph.alignment = NSTextAlignmentRight;
        
        // 判断x位置，确定在指引线向左还是向右绘制
        // 根据需要变更指引线的起始位置
        // 变更文字和数字的位置
        if (x <= width) { // 在左边
            
            endX = 10;
            endY = breakPointY ;
            
            // 文字靠左
            paragraph.alignment = NSTextAlignmentLeft;
            numberX = endX;
            titleX = endX;
        } else {    // 在右边
            
            endX = self.bounds.size.width - 10;
            endY = breakPointY;
            numberX = endX - numberWidth;
            titleX = endX - titleWidth;
        }
        
        if (i != 0) {
            
            // 当i!=0时，就需要计算位置总和(方法开始出的rect)与rect1(将进行绘制的位置)是否有重叠
            CGRect rect1 = CGRectMake(numberX, numberY, numberWidth, titleY + titleHeight - numberY);
            
            CGFloat margin = 0;
            
            if (CGRectIntersectsRect(rect, rect1)) {
                // 两个面积重叠
                // 三种情况
                // 1. 压上面
                // 2. 压下面
                // 3. 包含
                // 通过计算让面积重叠的情况消除
                if (CGRectContainsRect(rect, rect1)) {// 包含
                    
                    if (i % self.dataArray.count <= self.dataArray.count * 0.5 - 1) {
                        // 将要绘制的位置在总位置偏上
                        margin = CGRectGetMaxY(rect1) - rect.origin.y;
                        endY -= margin;
                    } else {
                        // 将要绘制的位置在总位置偏下
                        margin = CGRectGetMaxY(rect) - rect1.origin.y;
                        endY += margin;
                    }
                } else {    // 相交
                    
                    if (CGRectGetMaxY(rect1) > rect.origin.y && rect1.origin.y < rect.origin.y) { // 压在总位置上面
                        margin = CGRectGetMaxY(rect1) - rect.origin.y;
                        endY -= margin;
                        
                    } else if (rect1.origin.y < CGRectGetMaxY(rect) && rect1.origin.y < CGRectGetMaxY(rect)) {  // 压总位置下面
                        margin = CGRectGetMaxY(rect) - rect1.origin.y;
                        endY += margin;
                    }
                    
                }
            }
            
            titleY = endY + 2;
            numberY = endY - numberHeight;
            
            // 通过计算得出的将要绘制的位置
            CGRect rect2 = CGRectMake(numberX, numberY, numberWidth, titleY + titleHeight - numberY);
            
            // 把新获得的rect和之前的rect合并
            if (numberX == rect.origin.x)
            {
                // 当两个位置在同一侧的时候才需要合并
                if (rect2.origin.y < rect.origin.y)
                {
                    rect = CGRectMake(rect.origin.x, rect2.origin.y, rect.size.width, rect.size.height + rect2.size.height);
                } else
                {
                    rect = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height + rect2.size.height);
                }
            }
        } else
        {
            rect = CGRectMake(numberX, numberY, numberWidth, titleY + titleHeight - numberY);
        }
        
        // 重新制定转折点
        if (endX == 10) {
            breakPointX = endX + lineWidth;
        } else {
            breakPointX = endX - lineWidth;
        }
        
        breakPointY = endY;
        
        //1.获取上下文
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        
        //2.绘制路径
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(endX, endY)];
        [path addLineToPoint:CGPointMake(breakPointX, breakPointY)];
        [path addLineToPoint:CGPointMake(startX, startY)];
        CGContextSetLineWidth(ctx, 0.5);
        
        //设置颜色
        [color set];
        
        //3.把绘制的内容添加到上下文当中
        CGContextAddPath(ctx, path.CGPath);
        
        //4.把上下文的内容显示到View上(渲染到View的layer)(stroke fill)
        CGContextStrokePath(ctx);
        
        // 在终点处添加点(小圆点)
        // movePoint，让转折线指向小圆点中心
        CGFloat movePoint = -2.5;
        
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = color;
        CGRect rect = view.frame;
        rect.size = CGSizeMake(5, 5);
        rect.origin = CGPointMake(startX + movePoint, startY + movePoint);
        view.frame = rect;
        view.layer.cornerRadius = 2.5;
        view.layer.masksToBounds = true;
        
        //指引线上面的数字
        [name drawInRect:CGRectMake(numberX , numberY , numberWidth, numberHeight) withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10.0], NSForegroundColorAttributeName:color,NSParagraphStyleAttributeName:paragraph}];
    }
}

@end
