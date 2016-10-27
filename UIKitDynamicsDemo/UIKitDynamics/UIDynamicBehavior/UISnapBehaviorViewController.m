//
//  UISnapBehaviorViewController.m
//  UIKit Dynamics
//
//  Created by XuYafei on 15/9/29.
//  Copyright © 2015年 loopeer. All rights reserved.
//

#import "UISnapBehaviorViewController.h"

@implementation UISnapBehaviorViewController {
    UIImageView *_imageView;
    UISlider *_slider;
    UIDynamicAnimator *_animator;
    UISnapBehavior *_snapBehavior;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"UISnapBehavior";
    self.view.backgroundColor = [UIColor whiteColor];
    
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    _imageView.center = CGPointZero;
    _imageView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:_imageView];
    
    _slider = [[UISlider alloc] initWithFrame:CGRectMake(40, self.view.frame.size.height-100, self.view.frame.size.width-80, 44)];
    [_slider addTarget:self action:@selector(sliderChanged:) forControlEvents:UIControlEventValueChanged];
    _slider.minimumValue = 0.0;
    _slider.maximumValue = 1.0;
    _slider.continuous = NO;
    [self.view addSubview:_slider];
    
    _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
}

- (void)sliderChanged:(UISlider*)sender {
    _imageView.center = CGPointZero;
    [_animator removeAllBehaviors];
    
    _snapBehavior = [[UISnapBehavior alloc] initWithItem:_imageView snapToPoint:self.view.center];
    _snapBehavior.damping = sender.value;
    [_animator addBehavior:_snapBehavior];
}

@end
