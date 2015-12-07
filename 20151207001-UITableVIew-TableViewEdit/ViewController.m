//
//  ViewController.m
//  20151207001-UITableVIew-TableViewEdit
//
//  Created by Rainer on 15/12/7.
//  Copyright © 2015年 Rainer. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self tableView];

    UIButton *editButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.bounds.size.width - 80 - 10, 20, 80, 40)];
    editButton.backgroundColor = [UIColor redColor];
    [editButton addTarget:self action:@selector(editButtonClickAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [editButton setTitle:@"编辑" forState:UIControlStateNormal];
    
    [self.view addSubview:editButton];
    
}

#pragma mark - 数据源方法
/**
 *  返回当前组行数
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

/**
 *  返回当前行表格
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *tableViewCellIdentifier = @"dataTableViewCellIdentifier";
    
    UITableViewCell *tableViewCell = [tableView dequeueReusableCellWithIdentifier:tableViewCellIdentifier];
    
    if (nil == tableViewCell) {
        tableViewCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableViewCellIdentifier];
    }
    
    NSString *text = self.dataArray[indexPath.row];
    
    tableViewCell.textLabel.text = text;
    
    return tableViewCell;
}

#pragma mark - 代理方法
/**
 *  返回表格行的编辑样式
 */
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.tableView.editing ? UITableViewCellEditingStyleInsert : UITableViewCellEditingStyleDelete;
}

/**
 *  该方法用来提交修改表格行操作，删除操作需要实现
 */
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    // 判断操作类型
    // 1.删除操作
    if (UITableViewCellEditingStyleDelete == editingStyle) {
        // 1.删除数据源对应的数据
        [self.dataArray removeObjectAtIndex:indexPath.row];
        // 2.删除表格行
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        // 2.刷新表格
//        [self.tableView reloadData];
    } else if (UITableViewCellEditingStyleInsert == editingStyle) {
        // 1.在当前indexPath的基础上创建当前行的下一个indexPath
        NSIndexPath *index = [NSIndexPath indexPathForRow:indexPath.row + 1 inSection:indexPath.section];
        
        // 2.将数据添加到表格数据数据源上
        [self.dataArray insertObject:@"王小二" atIndex:index.row];
        
        // 3.添加一行数据到表格上
        [self.tableView insertRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationBottom];
        
        // 4.恢复默认表格编辑状态
        [self changeTableViewEditing:NO];
        
        // 3.刷行表格
//        [self.tableView reloadData];
    } else {
        return;
    }
}

/**
 *  实现此方法就可以拖动表格行，切换表格行顺序
 */
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    // 1.取出数据源原下标的数据
    NSString *sourceDataString = self.dataArray[sourceIndexPath.row];
    
    // 2.删除数据源原下标的数据
    [self.dataArray removeObjectAtIndex:sourceIndexPath.row];
    
    // 3.将取出的原下标数据插入目标下标的下一个数据
    [self.dataArray insertObject:sourceDataString atIndex:destinationIndexPath.row];
}

#pragma mark - 按钮事件监听
/**
 *  点击添加按钮事件处理
 */
- (void)editButtonClickAction:(UIButton *)button {
    [self changeTableViewEditing:YES];
}

#pragma mark - 辅助私有方法
/**
 *  改变编辑状态
 */
- (void)changeTableViewEditing:(BOOL)isEditing {
    self.tableView.editing = isEditing;
}

#pragma mark - 控件懒加载
/**
 *  UITableView懒加载
 */
- (UITableView *)tableView {
    if (nil == _tableView) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        tableView.contentInset = UIEdgeInsetsMake(60, 0, 0, 0);
        
        tableView.dataSource = self;
        tableView.delegate = self;
        
        _tableView = tableView;
        [self.view addSubview:_tableView];
    }
    
    return _tableView;
}

#pragma mark - 属性懒加载
/**
 *  数据源属性懒加载
 */
- (NSMutableArray *)dataArray {
    if (nil == _dataArray) {
        _dataArray = [NSMutableArray arrayWithArray:@[@"张三",@"李四",@"王五",@"赵六",@"赵钱孙",@"周吴正",@"邓超",@"李晨",@"郑凯",@"鹿晗",@"AngelBaby",@"王祖蓝",@"陈赫",@"王宝强",@"成龙",@"白百何"]];
    }
    
    return _dataArray;
}

#pragma mark - 内存处理方法

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

@end
