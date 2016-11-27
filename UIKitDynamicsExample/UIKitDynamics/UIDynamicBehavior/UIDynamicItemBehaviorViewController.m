//
//  UIDynamicItemBehaviorViewController.m
//  UIKit Dynamics
//
//  Created by XuYafei on 15/9/29.
//  Copyright © 2015年 loopeer. All rights reserved.
//

#import "UIDynamicItemBehaviorViewController.h"

@implementation UIDynamicItemBehaviorViewController {
    UIImageView *_imageView;
    UISlider *_slider;
    UISlider *_slider2;
    UISlider *_slider3;
    UILabel *_label;
    UIDynamicAnimator *_animator;
    UIDynamicItemBehavior *_dynamicItemBehavior;
    UIPushBehavior *_pushBehavior;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"UIDynamicItemBehavior";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Push" style:UIBarButtonItemStyleDone target:self action:@selector(push)];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    _imageView.center = self.view.center;
    _imageView.transform = CGAffineTransformRotate(_imageView.transform, 40);
    _imageView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:_imageView];
    
    _slider = [[UISlider alloc] initWithFrame:CGRectMake(130, 108, self.view.frame.size.width-160, 40)];//弹性
    [_slider addTarget:self action:@selector(sliderChanged:) forControlEvents:UIControlEventValueChanged];
    _slider.minimumValue = 0.0;
    _slider.maximumValue = 1.0;
    _slider.continuous = NO;
    _slider.value = _slider.maximumValue;
    [self.view addSubview:_slider];
    
    _slider2 = [[UISlider alloc] initWithFrame:CGRectMake(130, 148, self.view.frame.size.width-160, 40)];//阻力//角阻力
    [_slider2 addTarget:self action:@selector(sliderChanged2:) forControlEvents:UIControlEventValueChanged];
    _slider2.minimumValue = 0.0;
    _slider2.maximumValue = 100.0;
    _slider2.continuous = NO;
    _slider2.value = _slider2.maximumValue;
    [self.view addSubview:_slider2];
    
    _slider3 = [[UISlider alloc] initWithFrame:CGRectMake(130, 188, self.view.frame.size.width-160, 40)];//摩擦力//密度
    [_slider3 addTarget:self action:@selector(sliderChanged3:) forControlEvents:UIControlEventValueChanged];
    _slider3.minimumValue = 1.0;
    _slider3.maximumValue = 6.0;
    _slider3.continuous = NO;
    _slider3.value = _slider3.maximumValue;
    [self.view addSubview:_slider3];
    
    _label = [[UILabel alloc] initWithFrame:CGRectMake(10, 100, 100, 132)];
    _label.numberOfLines = 0;
    _label.textAlignment = NSTextAlignmentRight;
    _label.text = @"弹性:\n\n阻力/角阻力:\n\n摩擦力/密度:";
    [self.view addSubview:_label];
    
    _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    
    UICollisionBehavior *collisionBehavior = [[UICollisionBehavior alloc] initWithItems:@[_imageView]];
    collisionBehavior.translatesReferenceBoundsIntoBoundary = YES;
    [_animator addBehavior:collisionBehavior];
    
    UIGravityBehavior *gravityBeahvior = [[UIGravityBehavior alloc] initWithItems:@[_imageView]];
    [_animator addBehavior:gravityBeahvior];
    
    _dynamicItemBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[_imageView]];
    _dynamicItemBehavior.allowsRotation = YES;//允许旋转
    _dynamicItemBehavior.elasticity = _slider.value;//弹性
    _dynamicItemBehavior.resistance = _slider2.value;//阻力
    _dynamicItemBehavior.angularResistance = _slider2.value;//角阻力
    _dynamicItemBehavior.friction = _slider3.value;//摩擦力
    _dynamicItemBehavior.density = _slider3.value;//密度
    [_animator addBehavior:_dynamicItemBehavior];
}

- (void)sliderChanged:(UISlider*)sender {
    _dynamicItemBehavior.elasticity = sender.value;//弹性
}

- (void)sliderChanged2:(UISlider*)sender {
    _dynamicItemBehavior.resistance = sender.value;//阻力
    _dynamicItemBehavior.angularResistance = sender.value;//角阻力
}

- (void)sliderChanged3:(UISlider*)sender {
    _dynamicItemBehavior.friction = sender.value;//摩擦力
    _dynamicItemBehavior.density = sender.value;//密度
}

- (void)push {
    UIPushBehavior *pushBehavior = [[UIPushBehavior alloc] initWithItems:@[_imageView] mode:UIPushBehaviorModeInstantaneous];
    pushBehavior.pushDirection = CGVectorMake(-10, 0);
    [_animator addBehavior:pushBehavior];
}

@end
