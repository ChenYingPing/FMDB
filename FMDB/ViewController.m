//
//  ViewController.m
//  FMDB
//
//  Created by Chen on 15/7/28.
//  Copyright (c) 2015年 Chen. All rights reserved.
//

#import "ViewController.h"
#import "UserCacheTool.h"
#import "FMDB.h"
#import "UserCell.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

- (IBAction)addUsers;
- (IBAction)update;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong)NSArray *users;

@end

@implementation ViewController

- (NSArray *)users
{
    if (_users == nil) {
        _users = [NSMutableArray array];
    }
    return _users;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = YES;
    self.tableView.rowHeight = 86;
    
    //先从缓存里面取出用户数组
    NSArray *usersArray = [UserCacheTool usersWithSqlite];
    self.users = usersArray;
}


- (IBAction)addUsers {
    
    NSString * uid = [NSString stringWithFormat:@"user%d",arc4random()%100];
    NSString * avatar = [NSString stringWithFormat:@"avatar%d",arc4random()%100];
    
    //把数据进行缓存
    [UserCacheTool addUsersWithUid:uid avatar:avatar];
    
    NSArray *usersArray = [UserCacheTool usersWithSqlite];
    self.users = usersArray;
    [self.tableView reloadData];
}

- (IBAction)update {
    //1.先从缓存里面取出用户数组
    NSArray *usersArray = [UserCacheTool usersWithSqlite];
    for (NSDictionary *user in usersArray) {
        NSString * uid = user[@"uid"];
        NSString * avatar = user[@"avatar"];
        NSString * nickname = [NSString stringWithFormat:@"nickname%d",arc4random()%100];
        NSDate * date = [NSDate date];
        NSString * dateline = [NSString stringWithFormat:@"%@",date];
        //把数据进行缓存
        [UserCacheTool addKeyWithUid:uid avatar:avatar nickname:nickname dateline:dateline];
    }
    //2.删除原先的旧表
    [UserCacheTool deleteTable:@"t_users"];
    
    //3.取出新表里的内容
    NSArray *users = [UserCacheTool usersFromT_newUsers];
    //4.删除新表
    [UserCacheTool deleteTable:@"t_newUsers"];
    self.users = users;
    [self.tableView reloadData];
}

#pragma mark - tableView数据源方法

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.users.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentufier = @"users";
    UserCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentufier];
    if(!cell){
        NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"UserCell" owner:nil options:nil];
        cell = [nibs lastObject];
        cell.backgroundColor = [UIColor clearColor];
    }
    NSDictionary *dict = self.users[indexPath.row];
    cell.uidLabel.text = dict[@"uid"];
    cell.avatarLabel.text = dict[@"avatar"];
    if (dict[@"nickname"]) {
        cell.nickNameLabel.text = dict[@"nickname"];
        cell.dateLineLabel.text = dict[@"dateline"];
    }
    return cell;
}

@end
