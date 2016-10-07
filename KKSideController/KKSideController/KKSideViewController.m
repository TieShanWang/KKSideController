//
//  KKSideViewController.m
//  KKNews
//
//  Created by MR.KING on 16/7/24.
//  Copyright © 2016年 KING. All rights reserved.
//

#import "KKSideViewController.h"

#import "UIView+KKFrame.h"



CGFloat KKSideCriticalScale = 0.4f;

CGFloat KKSideDefaultDuration = 0.25f;



@interface KKSideViewController ()<UIGestureRecognizerDelegate>

/// 左侧控制器
@property(nonatomic,strong)UIViewController * leftVCtl;

/// 中心控制器
@property(nonatomic,strong)UIViewController * homeVCtl;

/// 滑动手势
@property(nonatomic,strong)UIPanGestureRecognizer * panGesture;

@end



@implementation KKSideViewController



- (instancetype)initWithLeftVCtl:(UIViewController *)leftVCtl homeVCtl:(UIViewController *)homeVCtl
{
    self = [super init];
    if (self) {
        NSParameterAssert(leftVCtl);
        NSParameterAssert(homeVCtl);
        _panEnable = YES;
        _leftVCtl = leftVCtl;
        _homeVCtl = homeVCtl;
        [self addGesture];
        [self initData];
        [self initCtl];
    }
    return self;
}

/// 添加手势
-(void)addGesture{
    _panGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];
    _panGesture.delegate = self;
    [self.view addGestureRecognizer:_panGesture];
}

/// 设置默认值
-(void)initData{
    _open = NO;
    self.duration = KKSideDefaultDuration;
}

// 初始化控制器
-(void)initCtl{
    
    [self addChildViewController:_homeVCtl];
    [self.view addSubview:_homeVCtl.view];
    [_homeVCtl didMoveToParentViewController:self];
    
    // 将左侧的控制器添加为子控制器
    [self addChildViewController:self.leftVCtl];
    [self.view addSubview:self.leftVCtl.view];
    [self.leftVCtl didMoveToParentViewController:self];
    [self closeAnimation:NO duration:0];
}

/// 手势回调
-(void)pan:(UIPanGestureRecognizer*)pan{
    
    if (!_panEnable) {
        return;
    }
    
    CGPoint currentP = [pan translationInView:self.view];
    CGPoint velocity = [pan velocityInView:self.view];
    CGFloat leftCtl_x = _leftVCtl.view.kk_x;
    
    if (leftCtl_x >= [self maxX] ) {
        if (velocity.x > 0) {
            return;
        }
    }
    
    if (leftCtl_x <= [self minX]) {
        if (velocity.x < 0) {
            return;
        }
    }
    
    CGFloat newX = leftCtl_x + currentP.x;
    
    if (newX > [self maxX]) {
        newX = [self maxX];
    }
    
    if (newX < [self minX]) {
        newX = [self minX];
    }
    
    
    _leftVCtl.view.kk_x = newX;
    
    [pan setTranslation:CGPointZero inView:self.view];
    
    if (pan.state == UIGestureRecognizerStateEnded ||
        pan.state == UIGestureRecognizerStateFailed ||
        pan.state == UIGestureRecognizerStateCancelled) {
        
        if (fabs(velocity.x) > 1000) {
            if (velocity.x > 0) {
                [self openAnimation:YES duration:self.duration ];
            }else{
                [self closeAnimation:YES duration:self.duration ];
            }
            return;
        }
        
        [self endGesture];
    }
    
}

/// 手势结束
-(void)endGesture{
    CGFloat leftX = _leftVCtl.view.kk_x;
    if (leftX <= [self minX]) {
        _leftVCtl.view.kk_x = [self minX];
    }
    
    if (leftX >= [self maxX]) {
        _leftVCtl.view.kk_x = [self maxX];
    }
    
    // 小于临界点
    if (leftX < [self criticalWidth]) {
        // close
        NSTimeInterval duration = (_leftVCtl.view.kk_width - fabs(leftX)) / _leftVCtl.view.kk_width * self.duration;
        [self closeAnimation:YES duration:duration];
    }else{
        NSTimeInterval duration = fabs(leftX) / _leftVCtl.view.kk_width * self.duration;
        [self openAnimation:YES duration:duration];
    }
    
    
}


/**
 *  关闭左侧控制器视图
 *  @param animation 标志是否动画
 *  @param duration  动画的周期
 */
-(void)closeAnimation:(BOOL)animation duration:(NSTimeInterval)duration{
    _open = NO;
    [UIView animateWithDuration:(animation)?fabs(duration):0
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         
                         CGRect newFrame = CGRectMake(-_leftVCtl.view.kk_width,
                                                      0,
                                                      _leftVCtl.view.frame.size.width,
                                                      _leftVCtl.view.frame.size.height);
                         
                         _leftVCtl.view.frame = newFrame;
                         
                     } completion:nil];
}

-(void)openAnimation:(BOOL)animation duration:(NSTimeInterval)duration{
    _open = YES;
#if 0
    
    [UIView animateWithDuration:(animation)?fabs(duration):0
                          delay:0
         usingSpringWithDamping:0.3
          initialSpringVelocity:0.8
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
             CGRect newFrame = CGRectMake(0,
                                          0,
                                          _leftVCtl.view.frame.size.width,
                                          _leftVCtl.view.frame.size.height);
             
             _leftVCtl.view.frame = newFrame;
         } completion:nil];
    
#else
    [UIView animateWithDuration:(animation)?duration:0
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                              
                         CGRect newFrame = CGRectMake(0,
                                                      0,
                                                      _leftVCtl.view.frame.size.width,
                                                      _leftVCtl.view.frame.size.height);
                         _leftVCtl.view.frame = newFrame;
    
                          } completion:nil];
#endif
    
    
}


/// 打开,默认动画
-(void)open{
    [self openAnimation:YES];
}

/// 打开左侧
-(void)openAnimation:(BOOL)animation{
    [self openAnimation:animation duration:self.duration];
}

/// 关闭，默认动画
-(void)close{
    [self closeAnimation:YES];
}

/// 关闭左侧
-(void)closeAnimation:(BOOL)animation{
    [self closeAnimation:animation duration:self.duration];
}

/// 最小的X
-(CGFloat)minX{
    return -self.leftVCtl.view.kk_width;
}

/// 最大的X
-(CGFloat)maxX{
    return 0;
}

/// 临界值，指示打开或者关闭
-(CGFloat)criticalWidth{
    return _leftVCtl.view.kk_width * (KKSideCriticalScale - 1);
}

/// 速度的临界值，大于此临界值，将会不再判断手势停止的位置。模拟惯性
-(CGFloat)velocityCritical{
    return 1000;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





@end
