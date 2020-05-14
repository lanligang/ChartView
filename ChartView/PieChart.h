//
//  PieChart.h
//  manager
//
//  Created by ios2 on 2020/5/12.
//  Copyright © 2020 CY. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PieChartModel : NSObject
/* 0 - 1 之间*/
@property(nonatomic,assign)double percentage;
//起始弧度数
@property(nonatomic,assign)double startAngle;
//结束的弧度数
@property(nonatomic,assign)double endAngle;
@property(nonatomic,assign)CGPoint centerPoint;
//半径
@property(nonatomic,assign)double radius;
//指的是向内或者向外偏移的量
@property(nonatomic,assign)double offSet;
//图标的宽度
@property(nonatomic,assign)double chart_w;
//绘制的颜色
@property (nonatomic,strong)UIColor  *drawColor;
//绘制
- (void)drawPieChart:(CGRect)rect andContext:(CGContextRef)ctx;

@end

@interface PieChart : UIView
//圆弧宽度
@property(nonatomic,assign)CGFloat pieCharWidth;
@property(nonatomic,assign)CGFloat offSet; //每一圈偏移的量
//绘制数据
-(void)__drawPieCharWithData:(NSArray <PieChartModel*>*)data;

@end

NS_ASSUME_NONNULL_END
