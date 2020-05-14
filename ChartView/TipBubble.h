//
//  TipBubble.h
//  manager
//
//  Created by ios2 on 2020/5/13.
//  Copyright © 2020 CY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TipBubble.h" //泡泡提示

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, TipBubbleType) {
	LeftBottomType = 1,
	CenterBottomType = 2,
	RightBottomType = 3
};

typedef TipBubbleType TipBubbleType;

@interface TipBubble : UIView
//边界
@property(nonatomic,assign)UIEdgeInsets contentEdgeInsets;
//箭头宽度
@property(nonatomic,assign)CGFloat arrow_w;
//箭头高度
@property(nonatomic,assign)CGFloat arrow_h;
//圆角
@property(nonatomic,assign)CGFloat tipRadius;

//绘制的颜色
@property (nonatomic,strong)UIColor *drawColor;

//类型
@property(nonatomic,assign)TipBubbleType type;

@end

NS_ASSUME_NONNULL_END
