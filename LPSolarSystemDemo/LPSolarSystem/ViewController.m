//
//  ViewController.m
//  LPSolarSystem
//
//  Created by XuYafei on 15/12/26.
//  Copyright © 2015年 loopeer. All rights reserved.
//

#import "ViewController.h"
#import "DataController.h"
#import "XFUserDefaults.h"

static CGFloat sWidth = 30;
static CGFloat pWidth = 16;
static CGFloat mWidth = 12;

static NSUInteger sunTag = 100;
static NSUInteger planetTag = 101;
static NSUInteger meteorTag = 107;

@interface ViewController () <UICollisionBehaviorDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIDynamicAnimator *animator;
@property (nonatomic, strong) UIDynamicItemBehavior *dynamicItemBehavior;

@property (nonatomic, strong) NSMutableArray<UIImageView *> *entity;
@property (nonatomic, strong) NSArray<NSString *> *imageNameArray;
@property (nonatomic, strong) NSArray<NSDictionary *> *data;

@property (nonatomic, strong) UIImageView *fireButton;
@property (nonatomic, strong) UIImageView *sun;
@property (nonatomic, strong) UIImageView *meteor;

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) CGFloat space;
@property (nonatomic, assign) CGFloat angle;
@property (nonatomic, assign) NSInteger count;

@end

@implementation ViewController {

}

#pragma UIViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.navigationItem.title = @"Random Number";
        _entity = [NSMutableArray array];
        _imageNameArray = @[@"太阳", @"水星", @"金星", @"地球", @"火星", @"木星", @"土星", @"彗星"];
        
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"重置" style:UIBarButtonItemStyleDone target:self action:@selector(reset:)];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"设置" style:UIBarButtonItemStyleDone target:self action:@selector(set:)];
        
        _data = [XFUserDefaults getCacheDataWithKey:@"test"];
        if (_data.count <= 0) {
            NSArray *keys = @[@"水星", @"金星", @"地球", @"火星", @"木星", @"土星", @"count"];
            NSArray *values = @[@"1", @"2", @"3", @"4", @"5", @"6", @"6"];
            _data = @[[NSDictionary dictionaryWithObjects:values forKeys:keys]];
            [XFUserDefaults setCacheData:_data withKey:@"test"];
        }
        _count = [_data[0][@"count"] integerValue];
        _space = (CGRectGetWidth([UIScreen mainScreen].bounds) / 2 - sWidth / 2 - pWidth * _count) / (_count + 1);
    }
    return  self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self create];
}

#pragma mark - Create

- (void)create {
    [self createBackground];
    [self createEntity];
    [self createBehavior];
}

- (void)createBackground {
    UIImageView *bgView = [[UIImageView alloc] initWithFrame:self.view.frame];
    bgView.contentMode = UIViewContentModeScaleAspectFill;
    bgView.image = [UIImage imageNamed:@"bg"];
    [self.view addSubview:bgView];
    
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
    effectView.frame = self.view.frame;
    [self.view addSubview:effectView];
}

- (void)createEntity {
    
    //生成太阳
    
    _sun = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, sWidth, sWidth)];
    _sun.center = self.view.center;
    _sun.image = [UIImage imageNamed:_imageNameArray.firstObject];
    _sun.layer.cornerRadius = sWidth / 2;
    _sun.layer.masksToBounds = NO;
    _sun.layer.shadowColor = [UIColor redColor].CGColor;
    _sun.layer.shadowRadius = 10;
    _sun.layer.shadowOpacity = 1;
    _sun.tag = sunTag;
    [_entity addObject:_sun];
    [self.view addSubview:_sun];
    
    CAShapeLayer *sunShadowLayer = [CAShapeLayer layer];
    sunShadowLayer.frame = _sun.frame;
    sunShadowLayer.fillColor = [UIColor orangeColor].CGColor;
    sunShadowLayer.strokeColor = [UIColor clearColor].CGColor;
    sunShadowLayer.shadowColor = [UIColor orangeColor].CGColor;
    sunShadowLayer.shadowOpacity = 1.0;
    sunShadowLayer.shadowRadius = 20;
    [self.view.layer addSublayer:sunShadowLayer];
    
    //生成行星
    
    for (int i = 0; i < _count; i++) {
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        shapeLayer.position = _sun.center;
        shapeLayer.fillColor = [UIColor clearColor].CGColor;
        shapeLayer.strokeColor = [UIColor colorWithRed:0 green:0.8 blue:1 alpha:0.4].CGColor;
        shapeLayer.lineWidth = 0.5;
        [self.view.layer addSublayer:shapeLayer];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, pWidth, pWidth)];
        imageView.center = CGPointMake(CGRectGetMidX(_sun.frame), CGRectGetMaxY(_sun.frame) + CGRectGetWidth(imageView.frame) / 2 + _space + i * (pWidth + _space));
        imageView.image = [UIImage imageNamed:_imageNameArray[i + 1]];
        imageView.layer.cornerRadius = pWidth / 2;
        imageView.layer.shadowColor = [UIColor blackColor].CGColor;
        imageView.layer.shadowRadius = 5;
        imageView.layer.shadowOpacity = 1;
        imageView.tag = planetTag + i;
        [_entity addObject:imageView];
        [self.view addSubview:imageView];
        
        CGFloat radius = CGRectGetMidY(imageView.frame) - CGRectGetMidY(_sun.frame);
        shapeLayer.frame = CGRectMake(0, 0, radius * 2, radius * 2);
        shapeLayer.path = [UIBezierPath bezierPathWithArcCenter:_sun.center radius:radius startAngle:-M_PI endAngle:M_PI clockwise:YES].CGPath;
    }
    
    //生成彗星
    
    _meteor = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, mWidth, mWidth)];
    _meteor.center = CGPointMake(CGRectGetMidX(_sun.frame), CGRectGetHeight(self.view.frame) - CGRectGetHeight(_meteor.frame) / 2);
    _meteor.layer.cornerRadius = mWidth / 2;
    _meteor.image = [UIImage imageNamed:_imageNameArray.lastObject];
    _meteor.layer.shadowColor = [UIColor blackColor].CGColor;
    _meteor.layer.shadowRadius = 5;
    _meteor.layer.shadowOpacity = 1;
    _meteor.tag = meteorTag;
    _meteor.alpha = 0.0;
    [_entity addObject:_meteor];
    [self.view addSubview:_meteor];
    
    //发射器
    _fireButton = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 12)];
    _fireButton.center = CGPointMake(CGRectGetMidX(_sun.frame), CGRectGetHeight(self.view.frame) + CGRectGetHeight(_fireButton.frame) / 2);
    _fireButton.layer.anchorPoint = CGPointMake(1, 0.5);
    _fireButton.image = [UIImage imageNamed:@"indicator"];
    _fireButton.userInteractionEnabled = YES;
    [self.view addSubview:_fireButton];
    
    [self.view bringSubviewToFront:_sun];
    
}

- (void)createBehavior {
    _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    
    //连接行星
    
    UIAttachmentBehavior *sunBehavior = [[UIAttachmentBehavior alloc] initWithItem:_sun attachedToAnchor:_sun.center];
    [sunBehavior setAnchorPoint:_sun.center];
    [_animator addBehavior:sunBehavior];
    
    for (int i = 0; i < _count; i++) {
        UIImageView *imageView = _entity[i + 1];
        UIAttachmentBehavior *attachmentBehavior = [[UIAttachmentBehavior alloc] initWithItem:imageView attachedToAnchor:imageView.center];
        [attachmentBehavior setAnchorPoint:_sun.center];
        [_animator addBehavior:attachmentBehavior];
    }
    
    //生成物理效果
    
    UICollisionBehavior *collisionBehavior = [[UICollisionBehavior alloc] initWithItems:_entity];
    collisionBehavior.translatesReferenceBoundsIntoBoundary = YES;
    collisionBehavior.collisionDelegate = self;
    [_animator addBehavior:collisionBehavior];
    
    _dynamicItemBehavior = [[UIDynamicItemBehavior alloc] initWithItems:_entity];
    _dynamicItemBehavior.allowsRotation = YES;//允许旋转
    _dynamicItemBehavior.elasticity = 1;//弹性
    _dynamicItemBehavior.resistance = 0;//阻力
    _dynamicItemBehavior.angularResistance = 0;//角阻力
    _dynamicItemBehavior.friction = 0;//摩擦力
    _dynamicItemBehavior.density = 1;//密度
    [_animator addBehavior:_dynamicItemBehavior];
    
    //推动行星
    
    NSMutableArray<UIImageView *> *planets = [_entity mutableCopy];
    [planets removeObject:planets.lastObject];
    for (UIImageView *planet in planets) {
        CGFloat arc = [self randomWithLength:1.0];
        UIPushBehavior *pushBehavior = [[UIPushBehavior alloc] initWithItems:@[planet] mode:UIPushBehaviorModeInstantaneous];
        pushBehavior.pushDirection = CGVectorMake(arc, 0);
        [_animator addBehavior:pushBehavior];
    }
}

#pragma mark - Public

- (void)reloadView {
    _data = [XFUserDefaults getCacheDataWithKey:@"test"];
    NSInteger count = [_data[0][@"count"] integerValue];
    if (count < 2) {
        count = 2;
    }
    if (count > 6) {
        count = 6;
    }
    if (count == _count) {
        _count = count;
    } else {
        _count = count;
        _space = (CGRectGetWidth([UIScreen mainScreen].bounds) / 2 - sWidth / 2 - pWidth * _count) / (_count + 1);
        [self clear];
        [self create];
    }
    
}

#pragma mark - UICollisionBehaviorDelegate

- (void)collisionBehavior:(UICollisionBehavior *)behavior beganContactForItem:(id <UIDynamicItem>)item1 withItem:(id <UIDynamicItem>)item2 atPoint:(CGPoint)p {
    UIImageView *imageView1 = (UIImageView *)item1;
    UIImageView *imageView2 = (UIImageView *)item2;
    if (imageView1.tag == meteorTag && imageView2.tag > sunTag && imageView2.tag < meteorTag) {
        _dynamicItemBehavior.resistance = 10;
        _dynamicItemBehavior.angularResistance = 1;
        NSString *key = _imageNameArray[imageView2.tag - planetTag + 1];
        [self showAlertWithKey:key];
    } else if (imageView2.tag == meteorTag && imageView1.tag > sunTag && imageView1.tag < meteorTag) {
        _dynamicItemBehavior.resistance = 10;
        _dynamicItemBehavior.angularResistance = 1;
        NSString *key = _imageNameArray[imageView1.tag - planetTag + 1];
        [self showAlertWithKey:key];
    }
}

- (void)collisionBehavior:(UICollisionBehavior *)behavior endedContactForItem:(id <UIDynamicItem>)item1 withItem:(id <UIDynamicItem>)item2 {
    UIImageView *imageView1 = (UIImageView *)item1;
    UIImageView *imageView2 = (UIImageView *)item2;
    if (imageView1.tag == meteorTag && (NSInteger)(imageView2.tag - planetTag) >= 0) {
        NSLog(@"%@", _imageNameArray[imageView2.tag - planetTag + 1]);
    } else if ((imageView2.tag == meteorTag && (NSInteger)(imageView1.tag - planetTag) >= 0)) {
        NSLog(@"%@", _imageNameArray[imageView1.tag - planetTag + 1]);
    }
}

#pragma mark - Touch

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self beginTimer];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self stopTimer];
    UIPushBehavior *pushBehavior = [[UIPushBehavior alloc] initWithItems:@[_meteor] mode:UIPushBehaviorModeInstantaneous];
    [pushBehavior setAngle:_angle + M_PI magnitude:[self randomWithLength:0.1] + 0.06 / _count];
    [_animator addBehavior:pushBehavior];
    [UIView animateWithDuration:0.25 animations:^{
        _meteor.alpha = 1.0;
    }];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self stopTimer];
}

#pragma mark - Timer

- (void)beginTimer {
    _timer = [NSTimer timerWithTimeInterval:0.1 target:self selector:@selector(timerFired) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
    [self timerFired];
}

- (void)stopTimer {
    if (_timer) {
        [_timer invalidate];
    }
    _timer = nil;
}

- (void)timerFired {
    CGFloat arcY = [self randomWithLength:1.0];
    CGFloat arcX = [self randomWithLength:arcY];
    _angle = M_PI - atan(arcY / arcX);
    if (arc4random() % 2) {
        _angle -= M_PI_4;
    }
    _fireButton.transform = CGAffineTransformMakeRotation(_angle);
}

#pragma Private

- (CGFloat)randomWithLength:(CGFloat)range {
    NSUInteger retInt = arc4random() % 100;
    CGFloat ret = retInt / 100.0 * range;
    if (ret == 0) {
        ret = CGFLOAT_MIN;
    }
    return ret;
}

- (void)showAlertWithKey:(NSString *)key {
    NSString *string = [NSString stringWithFormat:@"%@:%@", key, _data[0][key]];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:string preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}];
    [alertController addAction:action];
    [self presentViewController:alertController animated:YES completion:^{}];
}

- (void)clear {
    [self stopTimer];
    [_animator removeAllBehaviors];
    for (UIImageView *imageView in _entity) {
        [imageView removeFromSuperview];
    }
    [self.view.layer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    _entity = [NSMutableArray array];
    _angle = 0;
}

#pragma mark - Action

- (void)reset:(UIBarButtonItem *)buttonItem {
    self.navigationController.navigationBar.userInteractionEnabled = NO;
    [_animator removeAllBehaviors];
    for (int i = 0; i < _count + 1; i++) {
        UIImageView *imageView = _entity[i + 1];
        UISnapBehavior *snapBehavior = [[UISnapBehavior alloc] initWithItem:imageView snapToPoint:_sun.center];
        snapBehavior.damping = 1.0;
        [_animator addBehavior:snapBehavior];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        for (int i = 0; i < _count; i++) {
            UIImageView *imageView = _entity[i + 1];
            imageView.center = CGPointMake(CGRectGetMidX(_sun.frame), CGRectGetMaxY(_sun.frame) + CGRectGetWidth(imageView.frame) / 2 + _space + i * (pWidth + _space));
        }
        _meteor.center = CGPointMake(CGRectGetMidX(_sun.frame), CGRectGetHeight(self.view.frame) - CGRectGetHeight(_meteor.frame) / 2);
        _meteor.alpha = 0.0;
        [self createBehavior];
        self.navigationController.navigationBar.userInteractionEnabled = YES;
    });
}

- (void)set:(UIBarButtonItem *)buttonItem {
    DataController *dataController = [DataController new];
    dataController.viewController = self;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:dataController];
    [self presentViewController:nav animated:YES completion:^{}];
}

@end
