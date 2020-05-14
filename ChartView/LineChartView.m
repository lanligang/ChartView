//
//  LineChartView.m
//  manager
//
//  Created by ios2 on 2020/5/12.
//  Copyright © 2020 CY. All rights reserved.
//
/*
 _       _____   __   _   _____   _   _   __    __
| |     | ____| |  \ | | /  ___/ | | / /  \ \  / /
| |     | |__   |   \| | | |___  | |/ /    \ \/ /
| |     |  __|  | |\   | \___  \ | |\ \     \  /
| |___  | |___  | | \  |  ___| | | | \ \    / /
|_____| |_____| |_|  \_| /_____/ |_|  \_\  /_/
 */

#import "LineChartView.h"

@implementation LineChartDrawModel

- (void)drawLineChart:(CGRect)rect andContext:(CGContextRef)ctx andIsBegain:(BOOL)isBegain andIsEnd:(BOOL)isEnd
{
    if (isBegain) {
        CGContextBeginPath(ctx);
    }
    CGFloat lengths[] = { 2, 2 };
    CGContextSetLineDash(ctx, 1, lengths, 0);    //不使用虚线
    CGContextSetStrokeColorWithColor(ctx, self.lineColor.CGColor);
    CGContextSetLineWidth(ctx, 1.0);
    if (isBegain) {
        CGContextMoveToPoint(ctx, self.point.x, self.point.y);
    } else {
        CGContextAddLineToPoint(ctx, self.point.x, self.point.y);
    }
    if (isEnd) {
        CGContextStrokePath(ctx);         //是否是最后一条
    }
}

- (void)drawHistogramChart:(CGRect)rect andContext:(CGContextRef)ctx
{
	CGContextBeginPath(ctx);
    CGFloat lengths[] = { 2, 2 };
    CGContextSetLineDash(ctx, 1, lengths, 0);    //不使用虚线
	CGContextSetStrokeColorWithColor(ctx, self.lineColor.CGColor);
    CGContextSetLineWidth(ctx, self.line_w);
	CGContextMoveToPoint(ctx, self.point.x, self.point.y);
	CGContextAddLineToPoint(ctx, self.bottomPoint.x, self.bottomPoint.y);
	CGContextStrokePath(ctx);
}

@end

@implementation LineDashDrawModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.lineWidth = 0.25;
        self.lineColor = [UIColor grayColor];
    }
    return self;
}

//绘制虚线
- (void)drawDashLineChart:(CGRect)rect andContext:(CGContextRef)ctx
{
    CGContextBeginPath(ctx);
    CGFloat lengths[] = { 2, 2 };
    CGContextSetLineDash(ctx, 1, lengths, 2);    //不使用虚线
    CGContextSetLineWidth(ctx, self.lineWidth);
    CGContextSetStrokeColorWithColor(ctx, self.lineColor.CGColor);
    CGContextMoveToPoint(ctx, self.topPoint.x, self.topPoint.y);
    CGContextAddLineToPoint(ctx, self.bottomPoint.x, self.bottomPoint.y);
    CGContextStrokePath(ctx);
}

//绘制底部的灰色的线
- (void)drawGrayLine:(CGRect)rect andContext:(CGContextRef)ctx
{
    CGContextBeginPath(ctx);
    CGFloat lengths[] = { 2, 2 };
    CGContextSetLineDash(ctx, 1, lengths, 0);    //不使用虚线
    CGContextSetLineWidth(ctx, self.lineWidth);
    CGContextSetStrokeColorWithColor(ctx, self.lineColor.CGColor);
    CGContextMoveToPoint(ctx, self.leftPoint.x, self.leftPoint.y);
    CGContextAddLineToPoint(ctx, self.rightPoint.x, self.rightPoint.y);
    CGContextStrokePath(ctx);
}

@end

@interface LineChartView ()
//左边的标签
@property (nonatomic, strong) NSMutableArray *leftLables;
@end

@implementation LineChartView
{
    CGFloat _leftPadding;        //左侧的间距
    CGFloat _bottomPadding;     //底部的距离
    CGFloat _topPadding;        //顶部间距
    CGFloat _rightPadding;      //右侧边距
    NSMutableArray *_drawArray;    //绘制的数据的数组
    NSInteger _maxValue;        //最大参数
    NSInteger _mineValue;       //最小参数
    CGFloat _plottingScale;     //比例尺
    LineDashDrawModel *_dashLineModel;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _leftPadding =   62.0;
        _topPadding =    30.0;
        _bottomPadding = 35.0;
        _rightPadding =  5.0;
		_histogramMax_w = 20.0;
		_dashLine_w = 0.5;
		_line_w = 1.0;
		_spaceLine_w = 0.2;
		_spaceLineColor = [UIColor grayColor];//灰色
		_dashLineColor = [UIColor colorWithRed:0x2C/255.0 green:0x88/255.0 blue:0x6c/255.0 alpha:1];
		_lineColor = [UIColor colorWithRed:0x2C/255.0 green:0x88/255.0 blue:0x6c/255.0 alpha:1];
		_chartType = ChartType_line;
        self.backgroundColor = [UIColor clearColor];
        _drawArray = [NSMutableArray array];
        self.leftLables = [NSMutableArray array];
        for (int i = 0; i < 6; i++) {
            UILabel *titleLable = [UILabel new];
            titleLable.text = @"0";
            titleLable.font = [UIFont systemFontOfSize:10];
            titleLable.textAlignment = NSTextAlignmentRight;
			titleLable.textColor = [UIColor colorWithRed:0x33/255.0 green:0x33/255.0 blue:0x33/255.0 alpha:1];
            [self.leftLables addObject:titleLable];
            [self addSubview:titleLable];
        }
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    //绘制图形
    CGRect newRect = CGRectMake(_leftPadding, _topPadding, CGRectGetWidth(rect) - _leftPadding - _rightPadding, CGRectGetHeight(rect) - _topPadding - _bottomPadding);

    CGFloat item_h = newRect.size.height / 5.0;

    for (int i = 0; i < 6; i++) {
        CGFloat y = rect.size.height - _bottomPadding - item_h * (i);
        //绘制五条线
        LineDashDrawModel *model = [[LineDashDrawModel alloc]init];
        model.leftPoint = CGPointMake(newRect.origin.x, y);
        model.rightPoint = CGPointMake(newRect.origin.x + CGRectGetWidth(newRect), y);
		model.lineWidth = _spaceLine_w;
		model.lineColor = _spaceLineColor;
        [model drawGrayLine:rect andContext:ctx];

		//修改UI 控件
        UILabel *leftLable =  self.leftLables[i];

		if (i!=0 && _chartType == ChartType_histogram_percent)
		{
			leftLable.text = [NSString stringWithFormat:@"%d%%", (int)(_plottingScale * i / 1 +_mineValue)];
		}else{
			leftLable.text = [NSString stringWithFormat:@"%d", (int)(_plottingScale * i / 1 +_mineValue)];
		}

        leftLable.frame = CGRectMake(0, 0, _leftPadding - 5, 10);
        leftLable.center = CGPointMake(leftLable.center.x, y);
    }

    NSInteger count = _drawArray.count;
    CGFloat draw_w = CGRectGetWidth(newRect);
    CGFloat item_w = draw_w / count;
    if (_drawArray.count > 0) {

        for (int i = 0; i < _drawArray.count; i++) {

            CGFloat x = newRect.origin.x + item_w / 2.0 + i * item_w;          //获取当前X值
            LineChartDrawModel *model = _drawArray[i];
			model.lineColor = _lineColor;
			model.line_w = _line_w;
            CGFloat y =  newRect.origin.y + newRect.size.height * (1 - model.number / _maxValue);

            model.point = (CGPoint) { x, y };

            BOOL isBegain = (i == 0) ? YES : NO;

            BOOL isLast = (i == _drawArray.count - 1) ? YES : NO;
			if (self.chartType == ChartType_line)
			{
				[model drawLineChart:rect andContext:ctx andIsBegain:isBegain andIsEnd:isLast];

			}else{

				model.bottomPoint = CGPointMake(x, CGRectGetMaxY(newRect));
				model.line_w = item_w *0.5;
				model.line_w = MIN(model.line_w, _histogramMax_w);
				model.lineColor = _lineColor;
				[model drawHistogramChart:rect andContext:ctx];

			}

			UILabel *bottomTitleLable =  [self viewWithTag:100 + i];

			bottomTitleLable.frame = CGRectMake(0, CGRectGetMaxY(newRect), item_w, _bottomPadding);

			//设置位置和大小
			bottomTitleLable.center = CGPointMake(x, bottomTitleLable.center.y);
        }
        if (_dashLineModel) {
            [_dashLineModel drawDashLineChart:rect andContext:ctx];
        }
    }
}

- (void)__drawLineCharWithData:(NSArray <LineChartDrawModel *> *)data
{
    [_drawArray removeAllObjects];
    [_drawArray addObjectsFromArray:data];
    NSMutableArray *tempArray = [NSMutableArray array];

    for (int i = 0; i < _drawArray.count; i++)
	 {
        LineChartDrawModel *model = _drawArray[i];
        [tempArray addObject:@(model.number)];
		model.lineColor  = _lineColor;  //分割线颜色
		model.line_w = _line_w;         //线条宽度

		UILabel *bottomTitleLable = [self viewWithTag:100+ i];

		if (!bottomTitleLable)
		{
			bottomTitleLable = [UILabel new];
			[self addSubview:bottomTitleLable];
		}

		bottomTitleLable.tag = 100 + i;

		bottomTitleLable.font = [UIFont systemFontOfSize:14.0];

		bottomTitleLable.text = model.title;

		bottomTitleLable.textColor = [UIColor colorWithRed:0x33/255.0 green:0x33/255.0 blue:0x33/255.0 alpha:1];

		bottomTitleLable.textAlignment = NSTextAlignmentCenter;
    }
    CGFloat maxValue = [[tempArray valueForKeyPath:@"@max.floatValue"] floatValue];
    _maxValue = maxValue * 1.2 / 1;
    _mineValue = 0;
    if (_mineValue <= 0) {
        _mineValue = 0;
    }
    if (_maxValue < 10) {
        _maxValue = 10;
    }
	if (_chartType == ChartType_histogram_percent) {
		NSInteger number = maxValue * 1.2;
		if (number < 25) {
			_maxValue = 25;
		}else if (number < 50){
			_maxValue = 50;
		}else if (number < 75){
			_maxValue = 75;
		}else{
			_maxValue = 100;
		}
		_mineValue = 0;
	}
    CGFloat plottingScale =  (_maxValue - _mineValue) / 5.0;
    _plottingScale = plottingScale;
    [self setNeedsDisplay];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    CGPoint point = [[touches anyObject]locationInView:self];
    [self showDashLineWithPoint:point];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    CGPoint point = [[touches anyObject]locationInView:self];
    [self showDashLineWithPoint:point];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    CGPoint point = [[touches anyObject]locationInView:self];
    [self showDashLineWithPoint:point];
}

- (void)showDashLineWithPoint:(CGPoint)point
{
    CGRect newRect = CGRectMake(
								_leftPadding,
								_topPadding,
								CGRectGetWidth(self.bounds) - _leftPadding - _rightPadding, CGRectGetHeight(self.bounds) - _topPadding - _bottomPadding);

	//避免出现位置跳跃
	if (newRect.size.height < 0 || newRect.size.width < 0)return;

	BOOL isContaint  =  CGRectContainsPoint(newRect, point);
	NSInteger currentPage = -1;
	if (isContaint) {
		if (_drawArray.count == 0) return; //没有数据
		if (!_dashLineModel) {
			_dashLineModel  = [[LineDashDrawModel alloc]init];
			_dashLineModel.lineColor =  _dashLineColor;
		}else{
			UILabel *lastLable =  [self viewWithTag:100+_dashLineModel.currentPage];
			lastLable.textColor = [UIColor colorWithRed:0x33/255.0 green:0x33/255.0 blue:0x33/255.0 alpha:1];
		}
		CGFloat item_W = CGRectGetWidth(newRect)/_drawArray.count;
		NSInteger x =  point.x - _leftPadding;
		NSInteger page = x /item_W;
		currentPage = page;
		CGFloat drawX = page * item_W + item_W/2.0 + _leftPadding;
		UILabel *currentLable =  [self viewWithTag:100+page];
		currentLable.textColor =[UIColor colorWithRed:0x2C/255.0 green:0x88/255.0 blue:0x6c/255.0 alpha:1];
		_dashLineModel.currentPage = page;//滑动到某一页了
		_dashLineModel.topPoint = CGPointMake(drawX, _topPadding);
		_dashLineModel.bottomPoint = CGPointMake(drawX, CGRectGetHeight(newRect) + _topPadding);
	}
	[self setNeedsDisplay];
	if (isContaint) {
		if (currentPage <0) return;
		LineChartDrawModel *model = _drawArray[currentPage];
		CGFloat y =  CGRectGetMinY(newRect) + CGRectGetHeight(newRect) * (1 - model.number / _maxValue);
		CGFloat item_W = CGRectGetWidth(newRect)/_drawArray.count;
		CGFloat x = CGRectGetMinX(newRect) + item_W / 2.0 +  currentPage * item_W;
		//获取当前X值
		model.point = (CGPoint) { x, y };
		//当前参数
		if ([self.delegate respondsToSelector:@selector(lineChartView:didScrollInPage:andPoint:andSource:)]) {
			BOOL containtPoint   =  CGRectContainsPoint(newRect, model.point);
			if (!containtPoint) return;
				[self.delegate lineChartView:self didScrollInPage:currentPage andPoint:model.point andSource:model];
		}
	}
}
#pragma mark - lazy load
-(TipBubble *)tip
{
	if (!_tip) {
		_tip = [[TipBubble alloc]init];
		_tip.bounds = CGRectMake(0, 0, 60, 40);
		_tip.drawColor = [[UIColor redColor]colorWithAlphaComponent:0.5];
		[self addSubview:_tip]; //添加到指定位置
	 }
	return _tip;
}

#pragma mark - setter
-(void)setChartInsets:(UIEdgeInsets)chartInsets
{
	_chartInsets = chartInsets;
	_leftPadding =   _chartInsets.left;
	_topPadding =    _chartInsets.top;
	_bottomPadding = _chartInsets.bottom;
	_rightPadding =  _chartInsets.right;
	[self setNeedsDisplay];
}

-(void)setChartType:(ChartType)chartType
{
	_chartType = chartType;
	[self setNeedsDisplay];
}

#pragma mark - 设置 位置和 宽度
-(void)setLine_w:(CGFloat)line_w
{
	_line_w = line_w;
	[self setNeedsDisplay];
}
-(void)setDashLine_w:(CGFloat)dashLine_w
{
	_dashLine_w = dashLine_w;
	[self setNeedsDisplay];
}
-(void)setHistogramMax_w:(CGFloat)histogramMax_w
{
	_histogramMax_w = histogramMax_w;
	[self setNeedsDisplay];
}
-(void)setSpaceLine_w:(CGFloat)spaceLine_w
{
	_spaceLine_w = spaceLine_w;
	[self setNeedsDisplay];
}
#pragma mark - 设置颜色 ---
-(void)setLineColor:(UIColor *)lineColor
{
	_lineColor = lineColor;
	[self setNeedsDisplay];
}
-(void)setDashLineColor:(UIColor *)dashLineColor
{
	_dashLineColor = dashLineColor;
	[self setNeedsDisplay];
}
-(void)setSpaceLineColor:(UIColor *)spaceLineColor
{
	_spaceLineColor = spaceLineColor;
	[self setNeedsDisplay];
}
-(void)dismissDashLine
{
	if (_dashLineModel) {
		//先找到指定的标签
		UILabel *bottomTitleLable =  [self viewWithTag:100 + _dashLineModel.currentPage];
		bottomTitleLable.textColor = [UIColor colorWithRed:0x33/255.0f green:0x33/255.0f blue:0x33/255.0f alpha:1];
		_dashLineModel = nil;
		[_tip removeFromSuperview];
		_tip = nil; //释放 气泡
		[self setNeedsDisplay];
	}
}
@end
