//
//  DataController.m
//  LPPushServiceDemo
//
//  Created by XuYafei on 15/9/28.
//  Copyright © 2015年 loopeer. All rights reserved.
//

#import "DataController.h"
#import "XFUserDefaults.h"
#import "ViewController.h"

@interface LPEditTableViewCell : UITableViewCell <UITextFieldDelegate>

@property (strong, nonatomic) UITextField *keyTextField;
@property (strong, nonatomic) UITextField *valueTextField;

@end

@implementation LPEditTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _keyTextField = [[UITextField alloc] initWithFrame:CGRectMake(
                          self.contentView.frame.origin.x,
                          self.contentView.frame.origin.y,
                          self.contentView.frame.size.width / 4,
                          self.contentView.frame.size.height)];
        _keyTextField.font = [UIFont systemFontOfSize:14];
        _keyTextField.textAlignment = NSTextAlignmentRight;
        _keyTextField.enabled = NO;
        [self.contentView addSubview:_keyTextField];
        
        _valueTextField = [[UITextField alloc] initWithFrame:CGRectMake(
                            _keyTextField.frame.origin.x+_keyTextField.frame.size.width,
                            _keyTextField.frame.origin.y,
                            self.contentView.frame.size.width-_keyTextField.frame.size.width,
                            _keyTextField.frame.size.height)];
        _valueTextField.delegate = self;
        _valueTextField.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_valueTextField];
        
    }
    return self;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    NSString *text = _valueTextField.text;
    text = [text stringByReplacingOccurrencesOfString:@" " withString:@""];
    text = [text stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    text = [text stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    text = [text stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    _valueTextField.text = text;
    return YES;
}

@end

@interface DataController () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation DataController {
    UITableView *_tableView;
    UISlider *_slider;
    
    NSArray<NSDictionary *> *_data;
    NSArray *_keys;
    NSInteger _count;
}

#pragma mark - LoadView

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.navigationItem.title = @"设置";
        self.navigationController.navigationBar.translucent = NO;
        self.edgesForExtendedLayout = UIRectEdgeNone;
        _keys = @[@"水星", @"金星", @"地球", @"火星", @"木星", @"土星"];
        _data = [XFUserDefaults getCacheDataWithKey:@"test"];
        _count = [_data[0][@"count"] integerValue];
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(dismissDataController)];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(saveData)];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    _slider = [[UISlider alloc] initWithFrame:CGRectMake(40, 0, CGRectGetWidth(self.view.frame) - 80, 44)];
    [_slider addTarget:self action:@selector(sliderChanged:) forControlEvents:UIControlEventValueChanged];
    _slider.minimumValue = 2.0;
    _slider.maximumValue = 6.0;
    _slider.continuous = NO;
    _slider.value = _count;
    [self.view addSubview:_slider];
    
    CGRect frame = CGRectMake(0, CGRectGetMaxY(_slider.frame), CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - CGRectGetHeight(_slider.frame));
    _tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.allowsSelection = NO;
    [_tableView registerClass:[LPEditTableViewCell class] forCellReuseIdentifier:NSStringFromClass([LPEditTableViewCell class])];
    [self.view addSubview:_tableView];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _keys.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LPEditTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LPEditTableViewCell class]) forIndexPath:indexPath];
    if (indexPath.row < _count) {
        cell.contentView.backgroundColor = [UIColor colorWithRed:0 green:0.8 blue:1 alpha:0.4];
    } else {
        cell.contentView.backgroundColor = [UIColor clearColor];
    }
    NSDictionary *dictionary = _data[indexPath.section];
    cell.keyTextField.text = [NSString stringWithFormat:@"%@  :", _keys[indexPath.row]];
    NSString *value = dictionary[_keys[indexPath.row]];
    cell.valueTextField.text = value;
    return cell;
}

#pragma mark - Action

- (void)saveData {
    [self.view endEditing:YES];
    NSMutableArray *mutableArray = [_data mutableCopy];
    NSMutableDictionary *mutableDictionary = [mutableArray[0] mutableCopy];
    NSInteger count = [_tableView numberOfRowsInSection:0];
    for (int i = 0; i < count; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        LPEditTableViewCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
        mutableDictionary[_keys[i]] = cell.valueTextField.text;
    }
    mutableDictionary[@"count"] = [@(_count) stringValue];
    mutableArray[0] = mutableDictionary;
    _data = mutableArray;
    [XFUserDefaults setCacheData:_data withKey:@"test"];
    _data = [XFUserDefaults getCacheDataWithKey:@"test"];
    [_tableView reloadData];
    
    [_viewController reloadView];
}

- (void)dismissDataController {
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:^{}];
}

- (void)sliderChanged:(UISlider *)slider {
    _count = slider.value;
    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
}

@end
