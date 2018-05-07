//
//  IDScaleView.m
//  kvo
//
//  Created by 悦帅 on 2018/4/27.
//  Copyright © 2018年 悦帅. All rights reserved.
//
#define EXTRA_DISTANCE 15.0
#define GESTURE_DETECTION_LENGTH 35.0   //手势限制距离
#define MINIMUM_WIDTH 90.0
#import "IDScaleView.h"


@interface IDShowView()
@property (strong, nonatomic)UIColor *cornerColor;
@property (assign, nonatomic)CGFloat cornerWidth;
@property (assign, nonatomic)CGFloat cornerLineWidth;
@end


@implementation IDShowView
- (void)drawRect:(CGRect)rect {
    [[UIColor whiteColor] setFill];
    
    UIRectFill(CGRectMake(15,
                          15,
                          rect.size.width - 2*15,
                          rect.size.height - 2*15));
    
    [[UIColor clearColor] setFill];
    
    UIRectFill(CGRectMake(3 + 15,
                          3 + 15,
                          rect.size.width - (3 + 15)*2,
                          rect.size.height - (3 + 15)*2));
    
    UIRectFill(CGRectMake(20 + 15,
                          15,
                          self.frame.size.width - (20 + 15)*2,
                          3 ));
    
    UIRectFill(CGRectMake(20 + 15,
                          self.frame.size.height - 3 - 15,
                          self.frame.size.width - (20 + 15)*2,
                          3 ));
    
    UIRectFill(CGRectMake(15,
                          20 + 15,
                          3 ,
                          self.frame.size.height - (20 + 15)*2));
    
    UIRectFill(CGRectMake(self.frame.size.width - 3 - 15,
                          20 + 15,
                          3,
                          self.frame.size.height - (20 + 15)*2));
}




@end


@interface IDScaleView()<UIGestureRecognizerDelegate>
@property (weak, nonatomic,)IDShowView *showView;
@end
@implementation IDScaleView
+ (instancetype)scaleViewWithScaleFrame:(CGRect)scaleFrame showFrame:(CGRect)showFrame{
    IDScaleView *scaleView =[[IDScaleView alloc]initWithFrame:scaleFrame];
    scaleView.showFrame =showFrame;
    
    IDShowView *showView =[[IDShowView alloc]initWithFrame:showFrame];
    showView.backgroundColor =[UIColor clearColor];
    scaleView.showView =showView;
    showView.cornerColor =scaleView.cornerColor;
    showView.cornerWidth =scaleView.cornerLineWidth;
    showView.cornerLineWidth =scaleView.cornerLineWidth;
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:scaleView action:@selector(panGesturEvent:)];
    [showView addGestureRecognizer:panGestureRecognizer];

    UIPinchGestureRecognizer *r2 = [[UIPinchGestureRecognizer alloc]initWithTarget:scaleView action:@selector(pinGesturEvent:)];
    r2.delegate = scaleView;
    [showView addGestureRecognizer:r2];
    [scaleView addSubview:showView];
    return scaleView;
}
// 允许多个手势并发
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self =[super initWithFrame:frame];
    self.backColor =[UIColor colorWithWhite:0 alpha:0.5];
    self.cornerColor =[UIColor whiteColor];
    self.cornerWidth =20;
    self.cornerLineWidth =3;
    self.backgroundColor =[UIColor clearColor];
    return self;
}

- (void)drawRect:(CGRect)rect {
    [self.backColor setFill];
    UIRectFill(self.bounds);
    
    [[UIColor clearColor] setFill];
    CGRect clearArea = CGRectMake(self.showView.frame.origin.x + EXTRA_DISTANCE,
                                  self.showView.frame.origin.y + EXTRA_DISTANCE,
                                  self.showView.frame.size.width - 2*EXTRA_DISTANCE,
                                  self.showView.frame.size.height - 2*EXTRA_DISTANCE);
    UIRectFill(clearArea);
    [self.showView setNeedsDisplay];
}
- (void)setBackColor:(UIColor *)backColor{
    _backColor =backColor;
    [self setNeedsDisplay];
}
- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    [self setNeedsDisplay];
}
- (void)setCornerColor:(UIColor *)cornerColor{
    _cornerColor =cornerColor;
    self.showView.cornerColor =cornerColor;
    [self.showView setNeedsDisplay];
}
-(void)pinGesturEvent:(UIPinchGestureRecognizer *)recognizer {
    CGFloat centerX, centerY, width, height;
    centerX =recognizer.view.center.x;
    centerY =recognizer.view.center.y;
    width =recognizer.view.frame.size.width *recognizer.scale;
    height =recognizer.view.frame.size.height *recognizer.scale;
    
    CGFloat showViewWidth, showViewHeight;
    
    showViewWidth = centerX >= recognizer.view.superview.center.x ? MIN((2 *recognizer.view.superview.center.x -centerX) *2 +2 *EXTRA_DISTANCE, width) : MIN(2 *centerX +2 *EXTRA_DISTANCE, width);
    showViewWidth =MAX(MINIMUM_WIDTH, showViewWidth);
    
    showViewHeight = centerY >= recognizer.view.superview.center.y ? MIN((2 *recognizer.view.superview.center.y -centerY) *2+2 *EXTRA_DISTANCE, height) : MIN(2 *centerY+2 *EXTRA_DISTANCE, height);
    showViewHeight =MAX(MINIMUM_WIDTH, showViewHeight);

    recognizer.view.bounds =CGRectMake(0, 0, showViewWidth, showViewHeight);
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        if ([self.delegate respondsToSelector:@selector(showViewDidBeginDraging:withShowFrame:)]) {
            CGRect trueFrame =CGRectMake(recognizer.view.frame.origin.x +EXTRA_DISTANCE, recognizer.view.frame.origin.y +EXTRA_DISTANCE, recognizer.view.frame.size.width -2*EXTRA_DISTANCE, recognizer.view.frame.size.height -2*EXTRA_DISTANCE);
            [self.delegate showViewDidBeginDraging:(IDShowView *)recognizer.view withShowFrame:trueFrame];
        }
    } else if (recognizer.state == UIGestureRecognizerStateChanged ||
               recognizer.state == UIGestureRecognizerStateBegan) {
        
        CGRect trueFrame =CGRectMake(recognizer.view.frame.origin.x +EXTRA_DISTANCE, recognizer.view.frame.origin.y +EXTRA_DISTANCE, recognizer.view.frame.size.width -2*EXTRA_DISTANCE, recognizer.view.frame.size.height -2*EXTRA_DISTANCE);
        if ([self.delegate respondsToSelector:@selector(showViewDidDraging:withShowFrame:)]) {
            [self.delegate showViewDidDraging:(IDShowView *)recognizer.view withShowFrame:trueFrame];
        }
    } else if (recognizer.state == UIGestureRecognizerStateEnded) {
        CGRect trueFrame =CGRectMake(recognizer.view.frame.origin.x +EXTRA_DISTANCE, recognizer.view.frame.origin.y +EXTRA_DISTANCE, recognizer.view.frame.size.width -2*EXTRA_DISTANCE, recognizer.view.frame.size.height -2*EXTRA_DISTANCE);
        if ([self.delegate respondsToSelector:@selector(showViewDidEndDraging:withShowFrame:)]) {
            [self.delegate showViewDidEndDraging:(IDShowView *)recognizer.view withShowFrame:trueFrame];
        }
    }
    recognizer.scale = 1;
    [recognizer.view.superview setNeedsDisplay];
}
/**
 手势事件
 
 @param recognizer 手势对象
 */
- (void)panGesturEvent:(UIPanGestureRecognizer *)recognizer {
    static IDPanPosition panPosition =IDPanAtNone;
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        panPosition =getPosition([recognizer locationInView:recognizer.view], recognizer.view.frame.size);
        if ([self.delegate respondsToSelector:@selector(showViewDidBeginDraging:withShowFrame:)]) {
            CGRect trueFrame =CGRectMake(recognizer.view.frame.origin.x +EXTRA_DISTANCE, recognizer.view.frame.origin.y +EXTRA_DISTANCE, recognizer.view.frame.size.width -2*EXTRA_DISTANCE, recognizer.view.frame.size.height -2*EXTRA_DISTANCE);
            [self.delegate showViewDidBeginDraging:(IDShowView *)recognizer.view withShowFrame:trueFrame];
        }
    } else if (recognizer.state == UIGestureRecognizerStateChanged ||
               recognizer.state == UIGestureRecognizerStateBegan) {
        CGRect showFrame =recognizer.view.frame;
        CGPoint translation =[recognizer translationInView:recognizer.view];
        CGFloat x, y, width, height;
        
        switch (panPosition) {
            case IDPanAtCenter:{
                CGFloat _x = showFrame.origin.x + translation.x;
                CGFloat _y = showFrame.origin.y + translation.y;
                x = MIN(MAX(-EXTRA_DISTANCE, _x), recognizer.view.superview.frame.size.width - recognizer.view.frame.size.width + EXTRA_DISTANCE);
                y = MIN(MAX(-EXTRA_DISTANCE, _y), recognizer.view.superview.frame.size.height - recognizer.view.frame.size.height + EXTRA_DISTANCE);
                showFrame.origin = CGPointMake(x, y);
                recognizer.view.frame = showFrame;
                break;
            }
            case IDPanAtTopLeftCorner:{
                x = MAX(-EXTRA_DISTANCE, MIN(showFrame.origin.x + translation.x, showFrame.origin.x + showFrame.size.width - MINIMUM_WIDTH ));
                y = MAX(-EXTRA_DISTANCE, MIN(showFrame.origin.y + translation.y, showFrame.origin.y + showFrame.size.height - MINIMUM_WIDTH ));
                width = showFrame.origin.x + showFrame.size.width - x;
                height = showFrame.origin.y + showFrame.size.height - y;
                
                showFrame = CGRectMake(x, y, width, height);
                recognizer.view.frame = showFrame;
                break;
            }
            case IDPanAtTopRightCorner:{
                height = MIN(MAX(MINIMUM_WIDTH, showFrame.size.height - translation.y), showFrame.size.height + showFrame.origin.y + EXTRA_DISTANCE);
                width =  MIN(MAX(MINIMUM_WIDTH, showFrame.size.width + translation.x), recognizer.view.superview.frame.size.width - showFrame.origin.x + EXTRA_DISTANCE);
                showFrame = CGRectMake(showFrame.origin.x, showFrame.origin.y + showFrame.size.height - height, width, height);
                recognizer.view.frame = showFrame;
                break;
            }
            case IDPanAtBottomLeftCorner:{
                if (translation.x > -EXTRA_DISTANCE && showFrame.size.width == MINIMUM_WIDTH) {
                    return;
                }
                x = MIN(MAX(-EXTRA_DISTANCE, showFrame.origin.x + translation.x), showFrame.origin.x + showFrame.size.width - MINIMUM_WIDTH);
                y = showFrame.origin.y;
                width = showFrame.origin.x + showFrame.size.width - x;
                height = MIN(MAX(showFrame.size.height + translation.y, MINIMUM_WIDTH), recognizer.view.superview.frame.size.height - showFrame.origin.y + EXTRA_DISTANCE);
                showFrame = CGRectMake(x, y, width, height);
                recognizer.view.frame = showFrame;
                break;
            }
            case IDPanAtBottomRightCorner:{
                showFrame.size = CGSizeMake(MIN(MAX(MINIMUM_WIDTH, showFrame.size.width + translation.x), recognizer.view.superview.frame.size.width - showFrame.origin.x + EXTRA_DISTANCE),
                                            MIN(MAX(MINIMUM_WIDTH, showFrame.size.height + translation.y), recognizer.view.superview.frame.size.height - showFrame.origin.y + EXTRA_DISTANCE));
                recognizer.view.frame = showFrame;
                break;
            }
            case IDPanAtLeftBorder:{
                x = MIN(MAX(-EXTRA_DISTANCE, showFrame.origin.x + translation.x), showFrame.origin.x + showFrame.size.width - MINIMUM_WIDTH);
                width = showFrame.origin.x + showFrame.size.width - x;
                showFrame = CGRectMake(x, showFrame.origin.y, width, showFrame.size.height);
                recognizer.view.frame = showFrame;
                break;
            }
            case IDPanAtTopBorder:{
                height = MIN(MAX(MINIMUM_WIDTH, showFrame.size.height - translation.y), showFrame.size.height + showFrame.origin.y + EXTRA_DISTANCE);
                showFrame = CGRectMake(showFrame.origin.x, showFrame.origin.y + showFrame.size.height - height, showFrame.size.width, height);
                recognizer.view.frame = showFrame;
                break;
            }
            case IDPanAtRightBorder:{
                width =  MIN(MAX(MINIMUM_WIDTH, showFrame.size.width + translation.x), recognizer.view.superview.frame.size.width - showFrame.origin.x + EXTRA_DISTANCE);
                showFrame = CGRectMake(showFrame.origin.x, showFrame.origin.y, width, showFrame.size.height);
                recognizer.view.frame = showFrame;
                break;
            }
            case IDPanAtBottomBorder:{
                height = MIN(MAX(showFrame.size.height + translation.y, MINIMUM_WIDTH), recognizer.view.superview.frame.size.height - showFrame.origin.y + EXTRA_DISTANCE);
                showFrame = CGRectMake(showFrame.origin.x, showFrame.origin.y, showFrame.size.width, height);
                recognizer.view.frame = showFrame;
                break;
            }
            default:
                break;
        }
        //归零
        [recognizer setTranslation:CGPointMake(0, 0) inView:recognizer.view];
        [recognizer.view.superview setNeedsDisplay];
        
        CGRect trueFrame =CGRectMake(recognizer.view.frame.origin.x +EXTRA_DISTANCE, recognizer.view.frame.origin.y +EXTRA_DISTANCE, recognizer.view.frame.size.width -2*EXTRA_DISTANCE, recognizer.view.frame.size.height -2*EXTRA_DISTANCE);
        if ([self.delegate respondsToSelector:@selector(showViewDidDraging:withShowFrame:)]) {
            [self.delegate showViewDidDraging:(IDShowView *)recognizer.view withShowFrame:trueFrame];
        }
    } else if (recognizer.state == UIGestureRecognizerStateEnded) {
        CGRect trueFrame =CGRectMake(recognizer.view.frame.origin.x +EXTRA_DISTANCE, recognizer.view.frame.origin.y +EXTRA_DISTANCE, recognizer.view.frame.size.width -2*EXTRA_DISTANCE, recognizer.view.frame.size.height -2*EXTRA_DISTANCE);
        if ([self.delegate respondsToSelector:@selector(showViewDidEndDraging:withShowFrame:)]) {
            [self.delegate showViewDidEndDraging:(IDShowView *)recognizer.view withShowFrame:trueFrame];
        }
    }
}
/**
 手势初始的触摸位置
 
 @param position 传递过来的位置
 @param size 当前窗体的大小
 @return 返回在窗体的触摸位置
 */
IDPanPosition getPosition(CGPoint position, CGSize size){
    CGFloat x = position.x;
    CGFloat y = position.y;
    CGFloat width = size.width;
    CGFloat height = size.height;
    
    IDPanPosition panPosition = IDPanAtNone;
    if (y >= height - GESTURE_DETECTION_LENGTH &&
        x >= width - GESTURE_DETECTION_LENGTH) {
        panPosition = IDPanAtBottomRightCorner;//右下
    }
    else if (y >= height - GESTURE_DETECTION_LENGTH &&
             x <= GESTURE_DETECTION_LENGTH) {
        panPosition = IDPanAtBottomLeftCorner;//左下
    }
    else if (y <= GESTURE_DETECTION_LENGTH &&
             x <= GESTURE_DETECTION_LENGTH) {
        panPosition = IDPanAtTopLeftCorner;//左上
    }
    else if (y <= GESTURE_DETECTION_LENGTH &&
             x >= width - GESTURE_DETECTION_LENGTH) {
        panPosition = IDPanAtTopRightCorner;//右上
    }
    else if (x >= GESTURE_DETECTION_LENGTH &&
             x <= width - GESTURE_DETECTION_LENGTH &&
             y >= GESTURE_DETECTION_LENGTH
             && y <= height - GESTURE_DETECTION_LENGTH) {
        panPosition = IDPanAtCenter;//中间
    }
    else if (x <= GESTURE_DETECTION_LENGTH) {
        panPosition = IDPanAtLeftBorder;//
    }
    else if (y <= GESTURE_DETECTION_LENGTH) {
        panPosition = IDPanAtTopBorder;
    }
    else if (x >= width - GESTURE_DETECTION_LENGTH) {
        panPosition = IDPanAtRightBorder;
    }
    else if (y >= height - GESTURE_DETECTION_LENGTH){
        panPosition = IDPanAtBottomBorder;
    }
    return panPosition;
}

@end


