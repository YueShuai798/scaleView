//
//  ViewController.m
//  ScaleView
//
//  Created by 悦帅 on 2018/5/5.
//  Copyright © 2018年 悦帅. All rights reserved.
//

#import "ViewController.h"
#import "YSScaleView.h"

@interface ViewController ()<YSScaleViewDelegate>
@property (strong, nonatomic)UIImageView *iconView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.iconView =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"timg-1"]];
    [self.view addSubview:self.iconView];
    self.iconView.frame =self.view.bounds;
    self.iconView.userInteractionEnabled =YES;
    
    YSScaleView *scaleView =[YSScaleView scaleViewWithScaleFrame:self.iconView.frame showFrame:CGRectMake(100, 100, 200, 400)];
    [self.iconView addSubview:scaleView];
    scaleView.delegate =self;
}
#pragma mark-IDScaleViewDelegate
- (void)showViewDidBeginDraging:(YSShowView *)showView withShowFrame:(CGRect)frame{
    NSLog(@"手势开始");
}
- (void)showViewDidDraging:(YSShowView *)showView withShowFrame:(CGRect)frame{
    NSLog(@"拖动ing");
}
- (void)showViewDidEndDraging:(YSShowView *)showView withShowFrame:(CGRect)frame{
    NSLog(@"手势结束");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
