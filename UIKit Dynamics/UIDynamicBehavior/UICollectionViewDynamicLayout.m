//
//  UICollectionViewDynamicLayout.m
//  UIKit Dynamics
//
//  Created by XuYafei on 15/10/18.
//  Copyright © 2015年 loopeer. All rights reserved.
//

#import "UICollectionViewDynamicLayout.h"

static const NSInteger _count = 4;
static const NSInteger _interval = 10;

@implementation UICollectionViewDynamicLayout

- (instancetype)init {
    self = [super init];
    if (self) {
        self.sectionInset = UIEdgeInsetsMake(_interval, _interval, _interval, _interval);
        self.minimumLineSpacing = _interval;
        self.minimumInteritemSpacing = _interval;
        
        self.dynamicAnimator = [[UIDynamicAnimator alloc] initWithCollectionViewLayout:self];
    }
    return self;
}

- (void)prepareLayout {
    [super prepareLayout];
    
    NSInteger itemWidth = (self.collectionView.bounds.size.width-(_count+1)*_interval)/_count;
    self.itemSize = CGSizeMake(itemWidth, itemWidth);
    
    CGSize contentSize = self.collectionView.contentSize;
    NSArray *items = [super layoutAttributesForElementsInRect:
                      CGRectMake(0.0f, 0.0f, contentSize.width, contentSize.height)];
    
    if (self.dynamicAnimator.behaviors.count == 0) {
        [items enumerateObjectsUsingBlock:^(id<UIDynamicItem> obj, NSUInteger idx, BOOL *stop) {
            
            UIAttachmentBehavior *behaviour = [[UIAttachmentBehavior alloc] initWithItem:obj attachedToAnchor:[obj center]];
            behaviour.length = 0.0f;
            behaviour.damping = 0.8f;
            behaviour.frequency = 1.0f;
            
            [self.dynamicAnimator addBehavior:behaviour];
            
        }];
    }
}

-(NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    return [self.dynamicAnimator itemsInRect:rect];
}

-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [self.dynamicAnimator layoutAttributesForCellAtIndexPath:indexPath];
}

-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    UIScrollView *scrollView = self.collectionView;
    CGFloat delta = newBounds.origin.y - scrollView.bounds.origin.y;
    
    CGPoint touchLocation = [self.collectionView.panGestureRecognizer locationInView:self.collectionView];
    
    [self.dynamicAnimator.behaviors enumerateObjectsUsingBlock:^(UIAttachmentBehavior *springBehaviour, NSUInteger idx, BOOL *stop) {
        CGFloat yDistanceFromTouch = fabs(touchLocation.y - springBehaviour.anchorPoint.y);
        CGFloat xDistanceFromTouch = fabs(touchLocation.x - springBehaviour.anchorPoint.x);
        CGFloat scrollResistance = (yDistanceFromTouch + xDistanceFromTouch) / 1500.0f;
        
        UICollectionViewLayoutAttributes *item = (UICollectionViewLayoutAttributes *)springBehaviour.items.firstObject;
        CGPoint center = item.center;
        if (delta < 0) {
            center.y += MAX(delta, delta*scrollResistance);
        }
        else {
            center.y += MIN(delta, delta*scrollResistance);
        }
        item.center = center;
        
        [self.dynamicAnimator updateItemUsingCurrentState:item];
    }];
    
    return NO;
}

@end
