//
//  UITransformViewController.m
//  UIKit Dynamics
//
//  Created by XuYafei on 15/9/30.
//  Copyright © 2015年 loopeer. All rights reserved.
//

#import "UITransformViewController.h"

@interface UITransformViewController ()

@end

@implementation UITransformViewController {
    UIGravityBehavior *_gravityBehavior;
    UIPushBehavior *_pushBehavior;
    UICollisionBehavior *_collisionBehavior;
    UIDynamicAnimator *_animator;
    UIImageView *_imageView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"UITransformViewController";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"ToRight" style:UIBarButtonItemStyleDone target:self action:@selector(move)];
    
    _imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    _imageView.backgroundColor = [UIColor lightGrayColor];
    _imageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(push)];
    [_imageView addGestureRecognizer:tapGesture];
    [self.view addSubview:_imageView];
    
    _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];

    _collisionBehavior = [[UICollisionBehavior alloc] initWithItems:@[_imageView]];
    _collisionBehavior.translatesReferenceBoundsIntoBoundary = NO;
    [_collisionBehavior addBoundaryWithIdentifier:@"leftLine"
                                       fromPoint:CGPointMake(-1, 0)
                                         toPoint:CGPointMake(-1, self.view.bounds.size.height)];
    [_collisionBehavior addBoundaryWithIdentifier:@"rightLine"
                                        fromPoint:CGPointMake(self.view.bounds.size.width*2-40, 0)
                                          toPoint:CGPointMake(self.view.bounds.size.width*2-40, self.view.bounds.size.height)];
    [_animator addBehavior:_collisionBehavior];
    
    _gravityBehavior = [[UIGravityBehavior alloc] initWithItems:@[_imageView]];
    _gravityBehavior.gravityDirection = CGVectorMake(0.0, 0.0);
    [_animator addBehavior:_gravityBehavior];
    
    _pushBehavior = [[UIPushBehavior alloc] initWithItems:@[_imageView] mode:UIPushBehaviorModeInstantaneous];
    _pushBehavior.pushDirection = CGVectorMake(0, 0);
    [_animator addBehavior:_pushBehavior];
}

- (void)move {
    _gravityBehavior.gravityDirection = CGVectorMake(2.0, 0.0);
    _pushBehavior.pushDirection = CGVectorMake(200.0f, 0.0f);
    _pushBehavior.active = YES;
}

- (void)push {
    _gravityBehavior.gravityDirection = CGVectorMake(-2.0, 0.0);
    _pushBehavior.pushDirection = CGVectorMake(-200.0f, 0.0f);
    _pushBehavior.active = YES;
}

@end
