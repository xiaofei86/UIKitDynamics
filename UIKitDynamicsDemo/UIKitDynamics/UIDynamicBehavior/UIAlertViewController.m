//
//  UIAlertViewController.m
//  UIKit Dynamics
//
//  Created by XuYafei on 15/9/30.
//  Copyright © 2015年 loopeer. All rights reserved.
//

#import "UIAlertViewController.h"

@implementation UIAlertViewController {
    UIDynamicAnimator *_animator;
    UIAlertController *_alertController;
    UISnapBehavior *_snapBehaviour;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"UIAlertViewController";
    self.view.backgroundColor = [UIColor lightGrayColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"ReStart" style:UIBarButtonItemStyleDone target:self action:@selector(start)];
    [self start];
}

- (void)start {
    _alertController = [UIAlertController alertControllerWithTitle:@"UIAlertViewController" message:@"UIAlertViewController" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}];
    [_alertController addAction:okAction];
    _alertController.view.alpha = 0.0;
    
    //当UIAlertController将要展示的时候会自动调整其view的位置等属性。
    //所以在presentViewController之前设置其属性可能导致被重置。
    [self.navigationController presentViewController:_alertController animated:NO completion:nil];
    
    //重置view.center来暂停原动画然后开始自定义的动画
    _alertController.view.center = CGPointMake(self.view.center.x, 0);
    [UIView animateWithDuration:0.25 animations:^{
        _alertController.view.alpha = 1.0;
    }];
    _animator = [UIDynamicAnimator new];
    _snapBehaviour = [[UISnapBehavior alloc] initWithItem:_alertController.view snapToPoint:self.view.center];
    _snapBehaviour.damping = 1.0;
    [_animator addBehavior:_snapBehaviour];
}

@end
