//
//  ViewController.m
//  UIKit Dynamics
//
//  Created by XuYafei on 15/9/23.
//  Copyright © 2015年 loopeer. All rights reserved.
//

#import "ViewController.h"
#import "UIGravityBehaviorViewController.h"
#import "UICollisionBehaviorViewController.h"
#import "UIAttachmentBehaviorViewController.h"
#import "UISnapBehaviorViewController.h"
#import "UIPushBehaviorViewController.h"
#import "UIDynamicItemBehaviorViewController.h"
#import "UIPendulumViewController.h"
#import "UIPhotoWallViewController.h"
#import "UITransformViewController.h"
#import "UIAlertViewController.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation ViewController {
    UITableView *_tableView;
    NSArray *_data;
    NSArray *_detail;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _data = @[@"UIGravityBehavior", @"UICollisionBehavior", @"UIAttachmentBehavior", @"UISnapBehavior", @"UIPushBehavior", @"UIDynamicItemBehavior", @"UIPendulumViewController", @"UIPhotoWallViewController", @"UITransformViewController", @"UIAlertViewController"];
    _detail = @[@"重力行为", @"碰撞行为", @"连接行为", @"吸附行为", @"推动行为", @"仿真行为", @"综合应用", @"场景应用", @"场景应用", @"场景应用"];
    _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.rowHeight = 44;
    [self.view addSubview:_tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.text = [_data objectAtIndex:indexPath.row];
    cell.detailTextLabel.text = [_detail objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:
            [self.navigationController pushViewController:[UIGravityBehaviorViewController new] animated:YES];
            break;
        case 1:
            [self.navigationController pushViewController:[UICollisionBehaviorViewController new] animated:YES];
            break;
        case 2:
            [self.navigationController pushViewController:[UIAttachmentBehaviorViewController new] animated:YES];
            break;
        case 3:
            [self.navigationController pushViewController:[UISnapBehaviorViewController new] animated:YES];
            break;
        case 4:
            [self.navigationController pushViewController:[UIPushBehaviorViewController new] animated:YES];
            break;
        case 5:
            [self.navigationController pushViewController:[UIDynamicItemBehaviorViewController new] animated:YES];
            break;
        case 6:
            [self.navigationController pushViewController:[UIPendulumViewController new] animated:YES];
            break;
        case 7:
            [self.navigationController pushViewController:[UIPhotoWallViewController new] animated:YES];
            break;
        case 8:
            [self.navigationController pushViewController:[UITransformViewController new] animated:YES];
            break;
        case 9:
            [self.navigationController pushViewController:[UIAlertViewController new] animated:YES];
            break;
        default:
            break;
    }
}

@end
