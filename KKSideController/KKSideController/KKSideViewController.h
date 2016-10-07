//
//  KKSideViewController.h
//  KKNews
//
//  Created by MR.KING on 16/7/24.
//  Copyright © 2016年 KING. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KKSideViewController : UIViewController

/// 左侧控制器
@property(nonatomic,strong,readonly)UIViewController * leftVCtl;

/// 中心控制器
@property(nonatomic,strong,readonly)UIViewController * homeVCtl;

/// 执行 打开 或者 关闭 的时间
@property(nonatomic,assign)NSTimeInterval duration;

/// 滑动手势是否可用
@property(nonatomic,assign)BOOL panEnable;

/// 指示是否打开
@property(nonatomic,assign,getter=isOpen)BOOL open;

/// 初始化
- (instancetype)initWithLeftVCtl:(UIViewController*)leftVCtl homeVCtl:(UIViewController*)homeVCtl;

/// 打开
-(void)open;

/// 动画打开
-(void)openAnimation:(BOOL)animation;

/// 关闭
-(void)close;

/// 动画关闭
-(void)closeAnimation:(BOOL)animation;

@end
