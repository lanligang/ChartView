//
//  LineChartView.h
//  manager
//
//  Created by ios2 on 2020/5/12.
//  Copyright © 2020 CY. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TipBubble.h"    //气泡

NS_ASSUME_NONNULL_BEGIN

@class LineChartDrawModel;
/** ===================================================================== */

#pragma mark - 折线View  的 代理方法  在点击滑动使用
@class LineChartView;
@protocol LineChartDelegate <NSObject>
@optional
//获取到这些数据
-(void)lineChartView:(LineChartView *)chartView
	 didScrollInPage:(NSInteger)page
			andPoint:(CGPoint)point
		   andSource:(LineChartDrawModel *)chartModel;
@end

/** ===================================================================== */

//线条View  的类型 枚举
typedef NS_ENUM(NSInteger, ChartType) {
	ChartType_line = 0,                //折线图
	ChartType_histogram = 1,           //柱状图
	ChartType_histogram_percent = 2,   //百分比柱状图
};
/** ===================================================================== */


#pragma mark - 线条View 包括 折线 以及柱状图三种
@interface LineChartView : UIView

@property(nonatomic,assign)ChartType chartType;            //折线图还是柱状图
@property(nonatomic,assign)UIEdgeInsets chartInsets;       // 确定表格的位置
@property(nonatomic,weak)id <LineChartDelegate>delegate;
@property (nonatomic,strong)TipBubble *tip;                //提示气泡

//颜色属性
@property (nonatomic,strong)UIColor *dashLineColor;        //虚线的颜色
@property (nonatomic,strong)UIColor *spaceLineColor;       //横线分割线颜色 [UIColor grayColor]
@property (nonatomic,strong)UIColor *lineColor;             //线条颜色


//线宽
@property(nonatomic,assign)CGFloat line_w;                 //线条宽度    默认为 1.0;
@property(nonatomic,assign)CGFloat dashLine_w;             //虚线的宽度  默认是 0.5;
@property(nonatomic,assign)CGFloat histogramMax_w;         //最大宽度 默认最大宽度是 20;
@property(nonatomic,assign)CGFloat  spaceLine_w;           //横向分割线宽度  默认 0.2;

//折线图
-(void)__drawLineCharWithData:(NSArray <LineChartDrawModel*>*)data;

//隐藏 虚线 并清理掉 气泡
-(void)dismissDashLine;


@end


/** ======================= 辅助类 ========================= */

#pragma mark - 画柱状图和折线图的 model

@interface LineChartDrawModel:NSObject


@property(nonatomic,assign)CGFloat number;    //热度数据 | 柱状图的数字

@property (nonatomic,strong)NSString *title;  //底部标题


#warning 下面属性不用设置 - 直接在 LineChartView 属性设置
@property (nonatomic,strong)UIColor *lineColor;  //线条的颜色
@property(nonatomic,assign)CGFloat line_w;       //线条宽度
@property(nonatomic,assign)CGPoint point;       //顶部的点|也是折线图的点
@property(nonatomic,assign)CGPoint bottomPoint; //绘制柱状图下部的点

// ================================ 绘制方法 =============================
//绘制柱状图
- (void)drawHistogramChart:(CGRect)rect andContext:(CGContextRef)ctx;
//绘制
- (void)drawLineChart:(CGRect)rect andContext:(CGContextRef)ctx andIsBegain:(BOOL)isBegain andIsEnd:(BOOL)isEnd;

@end


#pragma mark - 画分割线 以及 虚线
@interface LineDashDrawModel : NSObject

@property(nonatomic,assign)CGFloat lineWidth;   //虚线的宽度

@property (nonatomic,strong)UIColor *lineColor;  //虚线的颜色

@property(nonatomic,assign)CGPoint topPoint;    //上面的点
@property(nonatomic,assign)CGPoint bottomPoint; //下边的点

//绘制横线线条使用属性
@property(nonatomic,assign)CGPoint leftPoint;    //左边的点
@property(nonatomic,assign)CGPoint rightPoint;   //右边的点

@property(nonatomic,assign)NSInteger currentPage; //当前第几个数据

- (void)drawDashLineChart:(CGRect)rect andContext:(CGContextRef)ctx;

@end


NS_ASSUME_NONNULL_END
