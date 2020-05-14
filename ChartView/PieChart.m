//
//  PieChart.m
//  manager
//
//  Created by ios2 on 2020/5/12.
//  Copyright © 2020 CY. All rights reserved.
//

#import "PieChart.h"

@implementation PieChartModel

- (void)drawPieChart:(CGRect)rect andContext:(CGContextRef)ctx
{
	//设置填充颜色
	CGContextBeginPath(ctx);
	CGContextSetFillColorWithColor(ctx,self.drawColor.CGColor);

	CGPoint startPoint = [self pointWithAngle:self.startAngle andCenterPoint:self.centerPoint andRadius:self.radius + self.offSet];

	CGContextMoveToPoint(ctx, startPoint.x, startPoint.y);
	CGContextAddArc(ctx, self.centerPoint.x, self.centerPoint.y, self.radius + self.offSet, self.startAngle, self.endAngle, 0);
	//绘制闭合扇形
	CGContextAddLineToPoint(ctx, _centerPoint.x, _centerPoint.y);
	CGContextAddLineToPoint(ctx, startPoint.x, startPoint.y);
	CGContextFillPath(ctx);
	CGContextBeginPath(ctx);
	CGContextSetLineWidth(ctx, 1.0);
	CGContextSetStrokeColorWithColor(ctx, [UIColor whiteColor].CGColor);
	CGContextSetFillColorWithColor(ctx,[UIColor whiteColor].CGColor);
	CGFloat space_w = self.chart_w;
	CGPoint smarStartPoint = [self pointWithAngle:self.startAngle andCenterPoint:self.centerPoint andRadius:self.radius - self.offSet - space_w];
	CGContextMoveToPoint(ctx, smarStartPoint.x, smarStartPoint.y);
	CGContextAddArc(ctx, self.centerPoint.x, self.centerPoint.y, self.radius - self.offSet - space_w, self.startAngle, self.endAngle, 0);
	//绘制闭合扇形
	CGContextAddLineToPoint(ctx, _centerPoint.x, _centerPoint.y);
	CGContextAddLineToPoint(ctx, smarStartPoint.x, smarStartPoint.y);
	CGContextDrawPath(ctx, kCGPathFillStroke); //这个代表填充 + 绘制解决有小细线问题
}

-(CGPoint)pointWithAngle:(double)angle andCenterPoint:(CGPoint)centerpoint andRadius:(CGFloat)radius
{
	double x = 0;
	double y = 0;
	double cX = centerpoint.x;
	double cY = centerpoint.y;
	if (angle == 0) {
		x = cX + self.radius;
		y = cY + 0;
	}else if (angle >0&& angle < M_PI_2) {
		x = cX + radius * cos(angle);
		y = cY + radius *sin(angle);
	}else if (angle == M_PI_2){
		x = cX + 0;
		y = cY + radius;
	}else if (angle >M_PI_2 && angle < M_PI){
		double aAngle = M_PI - angle;
		y = cY + radius * sin(aAngle);
		x = cX - radius * cos(aAngle);
	}else if (angle == M_PI){
		x = cX - radius;
		y = cY + 0;
	}else if (angle >M_PI && angle < M_PI_2*3.0){
		double aAngle =  M_PI_2*3.0 - angle;
		x = cX - radius * sin(aAngle);
		y = cY - radius * cos(aAngle);
	}else if (angle == M_PI_2*3.0){
		x = cX - 0;
		y = cY - radius;
	}else{
		double aAngle =  M_PI*2.0 - angle;
		x = cX + radius * cos(aAngle);
		y = cY - radius * sin(aAngle);
	}
	return (CGPoint){x,y};
}


@end


@implementation PieChart{
	NSMutableArray *_chartDataSource;
}

-(instancetype)init
{
	self = [super init];
	if (self) {
		_chartDataSource = [NSMutableArray array];
		_pieCharWidth = 40;
		_offSet = 2.0;
		self.backgroundColor = [UIColor clearColor];
	}
	return self;
}

-(instancetype)initWithFrame:(CGRect)frame
{
	self =[super initWithFrame:frame];
	if (self) {
		_chartDataSource = [NSMutableArray array];
		self.backgroundColor = [UIColor whiteColor];
		_pieCharWidth = 40;
		_offSet = 2.0;
	}
	return self;
}

//绘制数据
-(void)__drawPieCharWithData:(NSArray <PieChartModel*>*)data;
{
	[_chartDataSource removeAllObjects];
	[_chartDataSource addObjectsFromArray:data];
	[self setNeedsDisplay];
}
-(void)drawRect:(CGRect)rect
{
	[super drawRect:rect];
	CGFloat startAngle = 0;
	CGFloat radius  = CGRectGetHeight(rect)/2.0 - _offSet * (_chartDataSource.count - 1);
	CGPoint center = CGPointMake(CGRectGetWidth(rect)/2.0, CGRectGetWidth(rect)/2.0);
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	CGFloat offSet = 0;
	for (int i = 0; i< _chartDataSource.count; i++) {
	   PieChartModel *model = _chartDataSource[i];
	   model.chart_w = _pieCharWidth;
	   CGFloat angle = startAngle + model.percentage * M_PI*2;
	   model.startAngle = startAngle;
	   model.endAngle = angle;
	   startAngle = angle;
	   model.centerPoint = center;
	   model.radius = radius;
	   model.offSet = offSet;
	   [model drawPieChart:rect andContext:ctx];
	   offSet += _offSet; //这里让偏移量每次增加 1 个
	}
}

-(void)setPieCharWidth:(double)pieCharWidth
{
	_pieCharWidth = pieCharWidth;
	[self setNeedsDisplay];
}
-(void)setOffSet:(CGFloat)offSet
{
	_offSet = offSet;
	[self setNeedsDisplay];
}

@end



