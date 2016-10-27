//
//  UIPhotoWallViewController.m
//  UIKit Dynamics
//
//  Created by XuYafei on 15/9/30.
//  Copyright © 2015年 loopeer. All rights reserved.
//

#import "UIPhotoWallViewController.h"
#import "UICollectionViewDynamicLayout.h"

@interface UIPhotoWallViewController () <UICollectionViewDataSource>

@end

@implementation UIPhotoWallViewController {
    UICollectionViewFlowLayout *_collectionLayout;
    UICollectionView *_collectionView;
}

#pragma mark - LoadView

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"UIPhotoWallViewController";
    self.view.backgroundColor = [UIColor whiteColor];
    
    _collectionLayout = [[UICollectionViewDynamicLayout alloc] init];
    _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:_collectionLayout];
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:_collectionView];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 80;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor darkGrayColor];
    cell.contentView.backgroundColor = [UIColor darkGrayColor];
    return cell;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [_collectionLayout invalidateLayout];
}

@end
