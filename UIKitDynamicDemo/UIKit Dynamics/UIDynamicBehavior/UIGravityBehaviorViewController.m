//
//  UIGravityBehaviorViewController.m
//  UIKit Dynamics
//
//  Created by XuYafei on 15/9/23.
//  Copyright © 2015年 loopeer. All rights reserved.
//

#import "UIGravityBehaviorViewController.h"

@interface UIGravityBehaviorViewController ()

@end

@implementation UIGravityBehaviorViewController {
    UIImageView *_imageView;
    UIDynamicAnimator* _animator;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"UIGravityBehavior";
    self.view.backgroundColor = [UIColor whiteColor];
    
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    _imageView.center = CGPointMake(self.view.center.x, _imageView.frame.size.width/2);
    _imageView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:_imageView];
    
    _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    
    UIGravityBehavior* gravityBeahvior = [[UIGravityBehavior alloc] initWithItems:@[_imageView]];
    [_animator addBehavior:gravityBeahvior];
}

@end
