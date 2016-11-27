//
//  UICollisionBehaviorViewController.m
//  UIKit Dynamics
//
//  Created by XuYafei on 15/9/23.
//  Copyright © 2015年 loopeer. All rights reserved.
//

#import "UICollisionBehaviorViewController.h"

@interface UICollisionBehaviorViewController () <UICollisionBehaviorDelegate>

@end

@implementation UICollisionBehaviorViewController {
    UIImageView *_imageView;
    UIDynamicAnimator *_animator;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"UICollisionBehavior";
    self.view.backgroundColor = [UIColor whiteColor];
    
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    _imageView.center = CGPointMake(self.view.center.x, _imageView.frame.size.width/2);
    _imageView.transform = CGAffineTransformRotate(_imageView.transform, 45);
    _imageView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:_imageView];
    
    _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    
    UIGravityBehavior *gravityBeahvior = [[UIGravityBehavior alloc] initWithItems:@[_imageView]];
    [_animator addBehavior:gravityBeahvior];
    
    UICollisionBehavior *collisionBehavior = [[UICollisionBehavior alloc] initWithItems:@[_imageView]];
    collisionBehavior.translatesReferenceBoundsIntoBoundary = YES;
    collisionBehavior.collisionDelegate = self;
    [_animator addBehavior:collisionBehavior];
    
//    [collisionBehavior addBoundaryWithIdentifier:@"line2" fromPoint:CGPointMake(self.view.frame.size.width, 0) toPoint:CGPointMake(self.view.frame.size.width, 400)];
//    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0,150, self.view.frame.size.width, self.view.frame.size.width)];
//    [collisionBehavior addBoundaryWithIdentifier:@"circle" forPath:path];
}

- (void)collisionBehavior:(UICollisionBehavior*)behavior beganContactForItem:(id <UIDynamicItem>)item withBoundaryIdentifier:(nullable id <NSCopying>)identifier atPoint:(CGPoint)p {
    _imageView.backgroundColor = [UIColor darkGrayColor];
}

- (void)collisionBehavior:(UICollisionBehavior*)behavior endedContactForItem:(id <UIDynamicItem>)item withBoundaryIdentifier:(nullable id <NSCopying>)identifier {
    _imageView.backgroundColor = [UIColor grayColor];
}

@end
