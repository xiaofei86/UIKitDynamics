//
//  UIAttachmentBehaviorViewController.m
//  UIKit Dynamics
//
//  Created by XuYafei on 15/9/23.
//  Copyright © 2015年 loopeer. All rights reserved.
//

#import "UIAttachmentBehaviorViewController.h"

@interface UIAttachmentBehaviorViewController () <UICollisionBehaviorDelegate>

@end

@implementation UIAttachmentBehaviorViewController {
    UIImageView *_imageView;
    UIDynamicAnimator *_animator;
    UIAttachmentBehavior *_attachmentBehavior;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"UIAttachmentBehavior";
    self.view.backgroundColor = [UIColor whiteColor];
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
    [self.view addGestureRecognizer:panGesture];
    
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    _imageView.center = CGPointMake(self.view.center.x, self.view.frame.size.height-_imageView.frame.size.width/2);
    _imageView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:_imageView];
    
    _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    
    UIGravityBehavior *gravityBeahvior = [[UIGravityBehavior alloc] initWithItems:@[_imageView]];
    [_animator addBehavior:gravityBeahvior];
    
    UICollisionBehavior* collisionBehavior = [[UICollisionBehavior alloc] initWithItems:@[_imageView]];
    collisionBehavior.translatesReferenceBoundsIntoBoundary = YES;
    collisionBehavior.collisionDelegate = self;
    [_animator addBehavior:collisionBehavior];
}

- (void)collisionBehavior:(UICollisionBehavior*)behavior beganContactForItem:(id <UIDynamicItem>)item withBoundaryIdentifier:(nullable id <NSCopying>)identifier atPoint:(CGPoint)p {
    _imageView.backgroundColor = [UIColor darkGrayColor];
}

- (void)collisionBehavior:(UICollisionBehavior*)behavior endedContactForItem:(id <UIDynamicItem>)item withBoundaryIdentifier:(nullable id <NSCopying>)identifier {
    _imageView.backgroundColor = [UIColor grayColor];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.view];
    [_attachmentBehavior setAnchorPoint:point];
}

- (void)panGesture:(UIPanGestureRecognizer *)panGesture {
    CGPoint point = [panGesture locationInView:self.view];
    if (panGesture.state == UIGestureRecognizerStateBegan){
        _attachmentBehavior = [[UIAttachmentBehavior alloc] initWithItem:_imageView attachedToAnchor:_imageView.center];
        [_attachmentBehavior setAnchorPoint:point];
        [_animator addBehavior:_attachmentBehavior];
    } else if ( panGesture.state == UIGestureRecognizerStateChanged) {
        [_attachmentBehavior setAnchorPoint:point];
    } else if (panGesture.state == UIGestureRecognizerStateEnded||
               panGesture.state == UIGestureRecognizerStateCancelled||
               panGesture.state == UIGestureRecognizerStateFailed) {
        [_animator removeBehavior:_attachmentBehavior];
    }
}

@end
