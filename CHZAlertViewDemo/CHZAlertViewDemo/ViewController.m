//
//  ViewController.m
//  CHZAnimations
//
//  Created by Wymann Chan on 2019/8/24.
//  Copyright © 2019 TCLSmartHome. All rights reserved.
//

#import "ViewController.h"
#import "NormalAlertVC.h"
#import "ImageAlertVC.h"
#import "TextFieldAlertVC.h"
#import "TextViewAlertVC.h"
#import "PickerAlertVC.h"
#import "TimerAlertVC.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *titleArray;

@end

@implementation ViewController

#pragma mark - Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"CHZAlertViewDemo";
    [self initData];
    [self initTableView];
}

#pragma mark - Data
/** 初始化数据 */
- (void)initData {
    self.titleArray = @[@"普通弹窗", @"图片弹窗", @"TextField 弹窗", @"TextView弹窗", @"选择器弹窗", @"弹窗定时消失"];
}

#pragma mark - UI
/** TableView */
- (void)initTableView {
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titleArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CELLID = @"CELLID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELLID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELLID];
    }
    cell.textLabel.text = self.titleArray[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:14.0];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45.0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:{
            NormalAlertVC *vc = [[NormalAlertVC alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 1:{
            ImageAlertVC *vc = [[ImageAlertVC alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 2:{
            TextFieldAlertVC *vc = [[TextFieldAlertVC alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 3:{
            TextViewAlertVC *vc = [[TextViewAlertVC alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 4:{
            PickerAlertVC *vc = [[PickerAlertVC alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 5:{
            TimerAlertVC *vc = [[TimerAlertVC alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        default:
            break;
    }
}

@end
