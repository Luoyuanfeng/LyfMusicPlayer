//
//  LYFMusicListViewController.m
//  LYF_MusicPlayer
//
//  Created by 罗元丰 on 16/1/13.
//  Copyright © 2016年 罗元丰. All rights reserved.
//

//创建一个重用标识符
#define musitListCellReuseIdentifier @"musicList_cell"

#import "LYFMusicListViewController.h"
#import "LYFMusicPlayViewController.h"
#import "ListTableViewCell.h"
#import "ListRequestManager.h"
#import "ListHeader.h"


@interface LYFMusicListViewController () <UITableViewDelegate, UITableViewDataSource>

//歌单列表
@property (nonatomic, strong) UITableView *listTableView;

@property (nonatomic, strong) LYFMusicPlayViewController *lmpvc;

@end

@implementation LYFMusicListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.translucent = NO;
    
    //初始化TableView
    self.listTableView = [[UITableView alloc] initWithFrame: CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 64) style: UITableViewStylePlain];
    [self.view addSubview: self.listTableView];
    //设置代理
    self.listTableView.delegate = self;
    self.listTableView.dataSource = self;
    //注册cell
    [self.listTableView registerNib: [UINib nibWithNibName: @"ListTableViewCell" bundle: nil] forCellReuseIdentifier: musitListCellReuseIdentifier];
    //
    [[ListRequestManager SharedInstance] requestWithURL: MUSIC_URL whenDidFinish:^{
        //数据请求成功，刷新页面
        [self.listTableView reloadData];
    }];
    
    self.lmpvc = [[UIStoryboard storyboardWithName: @"Main" bundle: nil] instantiateViewControllerWithIdentifier: @"LYF_MPVC"];
}

-(void)viewWillAppear:(BOOL)animated
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.title = @"所有音乐";
}

#pragma mark - TableViewDelegate&dataSource

#pragma mark 返回行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[ListRequestManager SharedInstance] countOfDataArray];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}

#pragma mark 返回cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: musitListCellReuseIdentifier forIndexPath: indexPath];
    ListModel *model = [[ListRequestManager SharedInstance] modelWithIndex: indexPath.row];
    cell.model = model;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //获取播放控制器
    self.lmpvc.index = indexPath.row;
    [self.navigationController pushViewController: self.lmpvc animated: YES];
    [self.listTableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
