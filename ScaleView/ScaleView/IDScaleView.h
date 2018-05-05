//
//  IDScaleView.h
//  kvo
//
//  Created by 悦帅 on 2018/4/27.
//  Copyright © 2018年 悦帅. All rights reserved.
//


#import <UIKit/UIKit.h>
@class IDShowView;

typedef enum {
    IDPanAtTopLeftCorner,//左上角
    IDPanAtTopRightCorner,//右上角
    IDPanAtBottomLeftCorner,//左下角
    IDPanAtBottomRightCorner,//右下角
    IDPanAtTopBorder,//上中
    IDPanAtBottomBorder,//下中
    IDPanAtLeftBorder,//左中
    IDPanAtRightBorder,//右中
    IDPanAtCenter,//正中
    IDPanAtNone
} IDPanPosition;
@protocol IDScaleViewDelegate<NSObject>
@optional
/**
 开始拖动
 
 @param showView 窗体控件
 @param frame 窗体的大小
 */
- (void)showViewDidBeginDraging:(IDShowView *)showView withShowFrame:(CGRect)frame;
/**
 正在拖动
 
 @param showView 窗体控件
 @param frame 窗体的大小
 */
- (void)showViewDidDraging:(IDShowView *)showView withShowFrame:(CGRect)frame;
/**
 拖动完毕
 
 @param showView 窗体控件
 @param frame 窗体的大小
 */
- (void)showViewDidEndDraging:(IDShowView *)showView withShowFrame:(CGRect)frame;
@end

@interface IDShowView:UIView

@end

@interface IDScaleView : UIView
@property (weak, nonatomic)id<IDScaleViewDelegate>delegate;

/**
 默认灰色的背景颜色
 */
@property (strong, nonatomic)UIColor *backColor;

/**
 透视窗口的边角的颜色
 */
@property (strong, nonatomic)UIColor *cornerColor;

/**
 边角宽
 */
@property (assign, nonatomic)CGFloat cornerWidth;

/**
 边角线宽
 */
@property (assign, nonatomic)CGFloat cornerLineWidth;

/**
 透视窗体的大小
 */
@property (assign, nonatomic)CGRect showFrame;

/**
 初始化的方法

 @param scaleFrame 背景的view的大小
 @param showFrame 透视窗口的大小
 @return 返回实例化对象
 */
+ (instancetype)scaleViewWithScaleFrame:(CGRect)scaleFrame showFrame:(CGRect)showFrame;
@end
