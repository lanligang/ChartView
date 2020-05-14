//
//  TipBubble.m
//  manager
//
//  Created by ios2 on 2020/5/13.
//  Copyright © 2020 CY. All rights reserved.
//

#import "TipBubble.h"

@implementation TipBubble{
	CGFloat _leftPadding;//左间距
	CGFloat _rightPadding;//右侧内边距
	CGFloat _bottomPadding;
	CGFloat _topPadding;   //
}

-(instancetype)init
{
	self =[super init];
	if (self) {
		_arrow_h = 8.0;
		_arrow_w = 16.0;
		_leftPadding = 0;
		_rightPadding = 0;
		_bottomPadding = 0;
		_tipRadius = 4;
		_type = CenterBottomType;
		_drawColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
		self.backgroundColor = [UIColor clearColor];
	}
	return self;
}

- (void)drawRect:(CGRect)rect {
	[super drawRect:rect];
	CGRect newRect = CGRectMake(rect.origin.x - _leftPadding, _topPadding, CGRectGetWidth(rect) - _leftPadding - _rightPadding, CGRectGetHeight(rect) - _bottomPadding);
	//拿到当前画笔  
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	CGContextSetFillColorWithColor(ctx, self.drawColor.CGColor);
	CGPoint point1 = (CGPoint){newRect.origin.x + _tipRadius,newRect.origin.y};
	CGContextMoveToPoint(ctx, point1.x, point1.y);
	CGPoint point2 = (CGPoint){newRect.size.width + newRect.origin.x - _tipRadius,newRect.origin.y};
	CGContextAddLineToPoint(ctx, point2.x, point2.y);

	CGPoint point3 = (CGPoint){newRect.size.width + newRect.origin.x ,newRect.origin.y+ _tipRadius};
	CGContextAddArc(ctx, point2.x, point3.y, _tipRadius, M_PI_2*3, M_PI*2, 0);

	CGPoint point4 = (CGPoint){newRect.size.width + newRect.origin.x ,newRect.origin.y + newRect.size.height - _tipRadius - _arrow_h};

	if (_type == RightBottomType) {
		point4 = (CGPoint){newRect.size.width + newRect.origin.x ,newRect.origin.y + newRect.size.height - _arrow_h};
		CGContextAddLineToPoint(ctx, point4.x, point4.y);
		CGContextAddLineToPoint(ctx, point4.x- _arrow_w/2.0, point4.y + _arrow_h);
		CGContextAddLineToPoint(ctx, point4.x- _arrow_w, point4.y);
		CGContextAddLineToPoint(ctx, newRect.origin.x + _tipRadius, point4.y);
		CGContextAddArc(ctx, newRect.origin.x + _tipRadius, point4.y- _tipRadius, _tipRadius, M_PI_2, M_PI, 0);
		CGContextAddLineToPoint(ctx, newRect.origin.x, _tipRadius);
		CGContextAddArc(ctx, _tipRadius, _tipRadius, _tipRadius, M_PI, M_PI_2*3, 0);
	}else{
		CGContextAddLineToPoint(ctx, point4.x, point4.y);
		CGContextAddArc(ctx, point4.x - _tipRadius, point4.y, _tipRadius, 0, M_PI_2, 0);
		CGFloat arrowX =  CGRectGetMidX(newRect);
		if (_type == CenterBottomType) {
			CGContextAddLineToPoint(ctx, arrowX + _arrow_w/2.0, point4.y + _tipRadius);
			CGContextAddLineToPoint(ctx, arrowX, point4.y + _tipRadius + _arrow_h);
			CGContextAddLineToPoint(ctx, arrowX - _arrow_w/2.0, point4.y + _tipRadius);
			CGContextAddLineToPoint(ctx, newRect.origin.x + _tipRadius, point4.y + _tipRadius);
			CGContextAddArc(ctx, newRect.origin.x + _tipRadius, point4.y, _tipRadius, M_PI_2, M_PI, 0);
			CGContextAddLineToPoint(ctx, newRect.origin.x, _tipRadius);
			CGContextAddArc(ctx, _tipRadius, _tipRadius, _tipRadius, M_PI, M_PI_2*3, 0);
		}else if(_type == LeftBottomType){
			CGContextAddLineToPoint(ctx, _arrow_w, point4.y + _tipRadius);
			CGContextAddLineToPoint(ctx, _arrow_w/2.0, point4.y + _tipRadius + _arrow_h);
			CGContextAddLineToPoint(ctx, newRect.origin.x, point4.y + _tipRadius);
			CGContextAddLineToPoint(ctx, newRect.origin.x, _tipRadius);
			CGContextAddArc(ctx, _tipRadius, _tipRadius, _tipRadius, M_PI, M_PI_2*3, 0);
		}
	}
	CGContextClosePath(ctx);
	CGContextFillPath(ctx);//填充
}

-(void)setType:(TipBubbleType)type
{
	_type = type;
	[self setNeedsDisplay];
}
-(void)setContentEdgeInsets:(UIEdgeInsets)contentEdgeInsets
{
	_contentEdgeInsets = contentEdgeInsets;
	_topPadding = _contentEdgeInsets.top;
	_leftPadding = _contentEdgeInsets.left;
	_rightPadding =_contentEdgeInsets.right;
	_bottomPadding = _contentEdgeInsets.bottom;
	[self setNeedsDisplay];
}

-(void)setTipRadius:(CGFloat)tipRadius
{
	_tipRadius = tipRadius;
	[self setNeedsDisplay];
}
-(void)setArrow_h:(CGFloat)arrow_h
{
	_arrow_h  = arrow_h;
	[self setNeedsDisplay];
}
-(void)setArrow_w:(CGFloat)arrow_w
{
	_arrow_w = arrow_w;
	[self setNeedsDisplay];
}




@end
