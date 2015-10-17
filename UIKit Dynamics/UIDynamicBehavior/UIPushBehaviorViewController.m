//
//  UIPushBehaviorViewController.m
//  UIKit Dynamics
//
//  Created by XuYafei on 15/9/29.
//  Copyright © 2015年 loopeer. All rights reserved.
//

#import "UIPushBehaviorViewController.h"

@implementation UIPushBehaviorViewController {
    UIImageView *_imageView;
    UISlider *_slider;
    UIDynamicAnimator *_animator;
    UIPushBehavior *_pushBehavior;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"UIPushBehavior";
    self.view.backgroundColor = [UIColor whiteColor];
    
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    _imageView.center = self.view.center;
    _imageView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:_imageView];
    
    _slider = [[UISlider alloc] initWithFrame:CGRectMake(40, self.view.frame.size.height-100, self.view.frame.size.width-80, 44)];
    [_slider addTarget:self action:@selector(sliderChanged:) forControlEvents:UIControlEventValueChanged];
    _slider.minimumValue = 0.0;
    _slider.maximumValue = 10.0;
    _slider.continuous = NO;
    [self.view addSubview:_slider];
    
    _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    
    UICollisionBehavior* collisionBehavior = [[UICollisionBehavior alloc] initWithItems:@[_imageView]];
    collisionBehavior.translatesReferenceBoundsIntoBoundary = YES;
    [_animator addBehavior:collisionBehavior];
}

- (void)sliderChanged:(UISlider*)sender {
    [_animator removeBehavior:_pushBehavior];
    _pushBehavior = [[UIPushBehavior alloc] initWithItems:@[_imageView] mode:UIPushBehaviorModeInstantaneous];
    _pushBehavior.pushDirection = CGVectorMake(-sender.value, 0);
    [_animator addBehavior:_pushBehavior];
}

@end
