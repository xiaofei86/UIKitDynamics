//
//  UIPendulumViewController.m
//  UIKit Dynamics
//
//  Created by XuYafei on 15/9/29.
//  Copyright © 2015年 loopeer. All rights reserved.
//

#import "UIPendulumViewController.h"

@implementation UIPendulumViewController {
    NSUInteger _count;
    NSArray *_balls;
    NSArray *_anchors;
    NSArray *_lines;
    UIDynamicAnimator *_animator;
    UIPushBehavior *_pushBehavior;
}

#pragma mark - LoadView

- (void)viewDidLoad {
    [super viewDidLoad];
    _count = 5;
    self.navigationItem.title = @"UIPendulumViewController";
    self.view.backgroundColor = [UIColor whiteColor];
    [self createBallsAndAnchors];
    [self createLines];
    [self createDynamicBehaviors];
}

- (void)createBallsAndAnchors {
    NSMutableArray *ballsArray  = [NSMutableArray array];
    NSMutableArray *anchorsArray  = [NSMutableArray array];
    CGFloat ballSize = CGRectGetWidth(self.view.bounds)/(3.0*_count);
    for (int i = 0; i < _count; i++) {
        UIView *ball = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ballSize-1, ballSize-1)];
        ball.backgroundColor = [UIColor grayColor];
        ball.layer.cornerRadius = (ballSize-1)/2.0;
        CGFloat x = CGRectGetWidth(self.view.bounds)/3.0+ballSize/2+i*ballSize;
        CGFloat y = CGRectGetHeight(self.view.bounds)/1.5;
        ball.center = CGPointMake(x, y);
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
        [ball addGestureRecognizer:panGesture];
        [ball addObserver:self forKeyPath:@"center" options:NSKeyValueObservingOptionNew context:Nil];
        [ballsArray addObject:ball];
        [self.view addSubview:ball];
        
        UIView *anchor = [self createAnchorForBall:ball];
        [anchorsArray addObject:anchor];
        [self.view addSubview:anchor];
    }
    _balls = ballsArray;
    _anchors = anchorsArray;
}

- (UIView *)createAnchorForBall:(UIView *)ball {
    UIView *anchor = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    anchor.layer.cornerRadius = 5;
    anchor.backgroundColor = [UIColor darkGrayColor];
    anchor.center = CGPointMake(ball.center.x, ball.center.y-CGRectGetHeight(self.view.bounds)/4);
    return anchor;
}

- (void)createLines {
    NSMutableArray *linesArray  = [NSMutableArray array];
    for (int i = 0; i < _count; i++) {
        CAShapeLayer *subLayer = [[CAShapeLayer alloc] init];
        [self.view.layer addSublayer:subLayer];
        [linesArray addObject:subLayer];
    }
    _lines = linesArray;
}

- (void)panGesture:(UIPanGestureRecognizer *)recoginizer {
    if (recoginizer.state == UIGestureRecognizerStateBegan){
        if (_pushBehavior) {
            [_animator removeBehavior:_pushBehavior];
        }
        _pushBehavior = [[UIPushBehavior alloc] initWithItems:@[recoginizer.view] mode:UIPushBehaviorModeContinuous];
        [_animator addBehavior:_pushBehavior];
    } else if (recoginizer.state == UIGestureRecognizerStateChanged) {
        _pushBehavior.pushDirection = CGVectorMake([recoginizer translationInView:self.view].x/10.f, 0);
    } else if (recoginizer.state == UIGestureRecognizerStateEnded||
               recoginizer.state == UIGestureRecognizerStateCancelled||
               recoginizer.state == UIGestureRecognizerStateFailed) {
        [_animator removeBehavior:_pushBehavior];
        _pushBehavior = nil;
    }
}

#pragma mark - LoadDynamicBehaviors

- (void)createDynamicBehaviors {
    UIDynamicBehavior *behavior = [[UIDynamicBehavior alloc] init];
    [self createAttachBehaviorForBalls:behavior];
    [behavior addChildBehavior:[self createGravityBehaviorForObjects:_balls]];
    [behavior addChildBehavior:[self createCollisionBehaviorForObjects:_balls]];
    [behavior addChildBehavior:[self createItemBehavior]];
    _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    [_animator addBehavior:behavior];
}

- (void)createAttachBehaviorForBalls:(UIDynamicBehavior *)behavior {
    for (int i = 0; i <_count; i++) {
        UIDynamicBehavior *attachmentBehavior = [self createAttachmentBehaviorForBallBearing:[_balls objectAtIndex:i] toAnchor:[_anchors objectAtIndex:i]];
        [behavior addChildBehavior:attachmentBehavior];
    }
}

- (UIDynamicBehavior *)createAttachmentBehaviorForBallBearing:(id<UIDynamicItem>)ballBearing toAnchor:(id<UIDynamicItem>)anchor {
    UIAttachmentBehavior *behavior = [[UIAttachmentBehavior alloc] initWithItem:ballBearing
                                                               attachedToAnchor:[anchor center]];
    return behavior;
}

- (UIDynamicBehavior *)createGravityBehaviorForObjects:(NSArray *)objects {
    UIGravityBehavior *gravity = [[UIGravityBehavior alloc] initWithItems:objects];
    gravity.magnitude = 10;
    return gravity;
}

- (UIDynamicBehavior *)createCollisionBehaviorForObjects:(NSArray *)objects {
    return [[UICollisionBehavior alloc] initWithItems:objects];
}

- (UIDynamicItemBehavior *)createItemBehavior {
    UIDynamicItemBehavior *itemBehavior = [[UIDynamicItemBehavior alloc] initWithItems:_balls];
    itemBehavior.elasticity = 1.0;
    itemBehavior.allowsRotation = NO;
    itemBehavior.resistance = 1.0;
    itemBehavior.angularResistance = 1.0;
    return itemBehavior;
}

#pragma mark - LayoutSublayer

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    [self layoutSublayer];
}

- (void)layoutSublayer {
    for (int i = 0; i < _balls.count; i++) {
        UIView *ball = [_balls objectAtIndex:i];
        CAShapeLayer *subLayer = [_lines objectAtIndex:i];
        
        CGPoint anchorCenter = [[_anchors objectAtIndex:[_balls indexOfObject:ball]] center];
        CGPoint ballCenter = [ball center];
        
        UIBezierPath *path = [[UIBezierPath alloc] init];
        [path moveToPoint:anchorCenter];
        [path addLineToPoint:ballCenter];
        
        [subLayer removeFromSuperlayer];
        subLayer.path = path.CGPath;
        subLayer.lineWidth = 1;
        subLayer.strokeColor = [UIColor grayColor].CGColor;
        CGPathRef bound = CGPathCreateCopyByStrokingPath(subLayer.path, nil, subLayer.lineWidth, kCGLineCapButt, kCGLineJoinMiter, subLayer.miterLimit);
        subLayer.bounds = CGPathGetBoundingBox(bound);
        subLayer.position = CGPointMake((anchorCenter.x+ballCenter.x)/2, (anchorCenter.y+ballCenter.y)/2);
        CGPathRelease(bound);
        [self.view.layer addSublayer:subLayer];
    }
    
}

- (void)dealloc {
    for (UIView *ball in _balls) {
        [ball removeObserver:self forKeyPath:@"center"];
    }
}

@end
