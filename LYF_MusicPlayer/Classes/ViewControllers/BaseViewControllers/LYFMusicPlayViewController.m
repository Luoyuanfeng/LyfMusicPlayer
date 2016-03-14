//
//  LYFMusicPlayViewController.m
//  LYF_MusicPlayer
//
//  Created by 罗元丰 on 16/1/13.
//  Copyright © 2016年 罗元丰. All rights reserved.
//

#import "LYFMusicPlayViewController.h"
#import "MusicPlayManager.h"
#import "ListRequestManager.h"
#import "ListModel.h"
#import "UIImageView+WebCache.h"
#import "LyricManager.h"
#import "LyricModel.h"

#define LYRIC_CELL_REUSEIDENTIFIER @"lyric_cell"

//枚举器
typedef NS_ENUM(NSInteger)
{
    //单曲
    MyPlayerPlayModeSingle = 0,
    //顺序
    MyPlayerPlayModeOrder,
    //随机
    MyPlayerPlayModeRandom
}MyPlayerPlayMode;

@interface LYFMusicPlayViewController () <AVPlayerDelegate, UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIScrollView *ScrollView;
@property (weak, nonatomic) IBOutlet UITableView *lyricTableView;

@property (weak, nonatomic) IBOutlet UIImageView *singerImgView;

@property (weak, nonatomic) IBOutlet UISlider *progressSlider;
@property (weak, nonatomic) IBOutlet UISlider *volumeSlider;


@property (weak, nonatomic) IBOutlet UILabel *beginTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *endTimeLabel;

@property (weak, nonatomic) IBOutlet UIButton *playPauseBtn;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@property (weak, nonatomic) IBOutlet UIButton *randomBtn;
@property (weak, nonatomic) IBOutlet UIButton *orderBtn;
@property (weak, nonatomic) IBOutlet UIButton *singleBtn;

@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, assign) MyPlayerPlayMode playMode;
@end

@implementation LYFMusicPlayViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.translucent = YES;
    self.ScrollView.delegate = self;
    self.ScrollView.showsHorizontalScrollIndicator = NO;
    self.lyricTableView.delegate = self;
    self.lyricTableView.dataSource = self;
    self.lyricTableView.backgroundColor = [UIColor clearColor];
    self.lyricTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.lyricTableView.showsVerticalScrollIndicator = NO;
    [self.lyricTableView registerClass: [UITableViewCell class] forCellReuseIdentifier: LYRIC_CELL_REUSEIDENTIFIER];
    [self.progressSlider setThumbImage: [UIImage imageNamed: @"progressPoint"] forState: UIControlStateNormal];
    
    [self.singerImgView layoutIfNeeded];
    
    self.singleBtn.alpha = 0.4;
    self.orderBtn.alpha = 1;
    self.randomBtn.alpha = 0.4;
    
    //打开layer的
    self.singerImgView.layer.masksToBounds = YES;
    self.singerImgView.layer.cornerRadius = self.singerImgView.frame.size.width / 2;
    //约束在viewDidApprear执行时才完全生效
    
    //设置代理
    [MusicPlayManager SharedInstance].playDelegate = self;
    //设置时间滑竿的最小值
    self.progressSlider.value = 0;
    self.progressSlider.minimumValue = 0;
    self.playMode = MyPlayerPlayModeOrder;
    self.currentIndex = -1;
    
//    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(nextAction) name: @"next" object: nil];
}

-(void)viewWillAppear:(BOOL)animated
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.translucent = YES;
    //判断要播放的歌曲和正在播放的是否同一首
    if(self.index != self.currentIndex)
    {
        self.currentIndex = self.index;
        [self exchangeMusic];
        [[MusicPlayManager SharedInstance] play];
    }
    BOOL status = [MusicPlayManager SharedInstance].status;
    if(status)
    {
        [self.playPauseBtn setTitle: @"⏸" forState: UIControlStateNormal];
    }
    else
    {
        [self.playPauseBtn setTitle: @"▶️" forState: UIControlStateNormal];
    }
}

#pragma mark - 歌词tableView控制
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[LyricManager SharedInstance] countOfModelArray];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: LYRIC_CELL_REUSEIDENTIFIER forIndexPath: indexPath];
    LyricModel *model = [[LyricManager SharedInstance] modelAtIndex: indexPath.row];
    cell.textLabel.text = model.lyric;
    cell.alpha = 0;
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.numberOfLines = -1;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LyricModel *model = [[LyricManager SharedInstance] modelAtIndex: indexPath.row];
    float progress = model.time;
    [[MusicPlayManager SharedInstance] seekTimeToPlay: progress + 0.1];
}


#pragma mark - 切歌控制

-(void)exchangeMusic
{
    //1.根据index获取模型
    ListModel *model = [[ListRequestManager SharedInstance] modelWithIndex: self.currentIndex];
    //2.设置唱片
    [[MusicPlayManager SharedInstance] prepareToPlayWithModel: model];
    [[MusicPlayManager SharedInstance] play];
    [[LyricManager SharedInstance] initLyricWithModel: model];
    self.navigationItem.title = model.name;
    self.titleLabel.text = [NSString stringWithFormat:@"%@", model.singer];
    //3.设置歌曲图片
    [self.singerImgView sd_setImageWithURL: [NSURL URLWithString: model.picUrl] placeholderImage: [UIImage imageNamed: @""]];
//    self.singerImgView.contentMode = UIViewContentModeBottom;
    //设置图片的起始角度
    self.singerImgView.transform = CGAffineTransformMakeRotation(M_PI_4);
    //获取歌曲时长
    CGFloat duration = [model.duration floatValue] / 1000;
    //设置时间滑竿最大值
    self.progressSlider.maximumValue = duration;
    //设置音量滑竿
    self.volumeSlider.minimumValue = 0;
    self.volumeSlider.maximumValue = 1;
    [self.lyricTableView reloadData];
}

#pragma mark - 模式按钮点击方法

#pragma mark 单曲
-(IBAction)singleMode
{
    //设置播放模式为单曲
    self.playMode = MyPlayerPlayModeSingle;
    self.singleBtn.alpha = 1;
    self.orderBtn.alpha = 0.4;
    self.randomBtn.alpha = 0.4;
}

#pragma mark 顺序
-(IBAction)orderMode
{
    //设置播放模式为顺序
    self.playMode = MyPlayerPlayModeOrder;
    self.singleBtn.alpha = 0.4;
    self.orderBtn.alpha = 1;
    self.randomBtn.alpha = 0.4;
}

#pragma mark 随机
-(IBAction)randomMode
{
    //设置播放模式为随机
    self.playMode = MyPlayerPlayModeRandom;
    self.singleBtn.alpha = 0.4;
    self.orderBtn.alpha = 0.4;
    self.randomBtn.alpha = 1;
}

#pragma mark 上一首
- (IBAction)lastBtnClick:(UIButton *)sender
{
    if(self.currentIndex == 0)
    {
        self.currentIndex = [[ListRequestManager SharedInstance] countOfDataArray] - 1;
        [self exchangeMusic];
    }
    else
    {
        self.currentIndex -= 1;
        NSLog(@"%ld", self.currentIndex);
        [self exchangeMusic];
    }
}

#pragma mark 播放/暂停
- (IBAction)playOrPauseAction:(UIButton *)sender
{
    //获取当前播放状态
    BOOL status = [MusicPlayManager SharedInstance].status;
    if(status)
    {
        [self.playPauseBtn setTitle: @"▶️" forState: UIControlStateNormal];
        [[MusicPlayManager SharedInstance] pause];
    }
    else
    {
        [self.playPauseBtn setTitle: @"⏸" forState: UIControlStateNormal];
        [[MusicPlayManager SharedInstance] play];
    }
}

#pragma mark 下一首
- (IBAction)nextBtnClick:(UIButton *)sender
{
    [self.playPauseBtn setTitle: @"▶️" forState: UIControlStateNormal];
    [[MusicPlayManager SharedInstance] pause];
    [self whichMode];
    [self.playPauseBtn setTitle: @"⏸" forState: UIControlStateNormal];
}

#pragma mark 播放完毕跳转下一首
-(void)nextAction
{
    NSLog(@"get notification");
    [[MusicPlayManager SharedInstance] pause];
    if(self.currentIndex == [[ListRequestManager SharedInstance] countOfDataArray] - 1)
    {
        self.currentIndex = 0;
        [self exchangeMusic];
    }
    else
    {
        self.currentIndex += 1;
        [self exchangeMusic];
    }
}

#pragma mark 改变播放进度
- (IBAction)changeTimeAction:(UISlider *)sender
{
    [[MusicPlayManager SharedInstance] seekTimeToPlay: sender.value];
}

#pragma mark 改变音量
- (IBAction)changeVolumeAction:(UISlider *)sender
{
    //改变播放器的音量
    [[MusicPlayManager SharedInstance] setVolumeValue: sender.value];
}

#pragma mark - AVPlayerPlayDalegate
-(void)playerPlayingWithProgress:(float)progress
{
    //设置图片旋转
    [UIView animateWithDuration: 0.1 animations:^{
        self.singerImgView.transform = CGAffineTransformRotate(self.singerImgView.transform, M_PI / 180);
    }];
    
    //设置进度条的value
    self.progressSlider.value = progress;
    
    //设置播放时间
    self.beginTimeLabel.text = [self transFromTime: progress];
    
    //设置剩余时间
    ListModel *model = [[ListRequestManager SharedInstance] modelWithIndex: self.currentIndex];
    self.endTimeLabel.text = [self transFromTime: (([model.duration floatValue] / 1000) - progress)];
//    CGFloat timeRemain = ([model.duration floatValue] / 1000) - progress;
//    if(timeRemain <= 0.5)
//    {
//        [[NSNotificationCenter defaultCenter] postNotificationName: @"next" object: nil];
//    }
    
    NSInteger i = [[LyricManager SharedInstance] indexForProgress: progress];
    //让tableView自动滚动到对应的行
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow: i inSection: 0];
    [self.lyricTableView selectRowAtIndexPath: indexPath animated: YES scrollPosition:UITableViewScrollPositionMiddle];
    UITableViewCell *cell = [self.lyricTableView cellForRowAtIndexPath: indexPath];
    cell.textLabel.highlightedTextColor = [UIColor colorWithRed:0.03 green:0.42 blue:0.85 alpha:1];
}

#pragma mark 播放结束跳转下一首(管理类代理)
-(void)playEndToTime
{
    [[MusicPlayManager SharedInstance] pause];
    [self whichMode];
}

#pragma mark 判定当前播放模式
-(void)whichMode
{
    //判定当前播放模式
    switch(self.playMode)
    {
        //单曲
        case MyPlayerPlayModeSingle:
        {
            //设置时间为0
            [[MusicPlayManager SharedInstance] seekTimeToPlay: 0];
            break;
        }
        //顺序
        case MyPlayerPlayModeOrder:
        {
            if(self.currentIndex == [[ListRequestManager SharedInstance] countOfDataArray] - 1)
            {
                self.currentIndex = 0;
            }
            else
            {
                self.currentIndex ++;
            }
            [self exchangeMusic];
            break;
        }
        //随机
        case MyPlayerPlayModeRandom:
        {
            //获取随机下标
            self.currentIndex = arc4random() % [[ListRequestManager SharedInstance] countOfDataArray];
            [self exchangeMusic];
            break;
        }
        default:
            break;
    }
}

#pragma mark 转换时间格式
-(NSString *)transFromTime:(CGFloat)progress
{
    //计算分钟
    NSString *min = [NSString stringWithFormat: @"%02ld", (NSInteger)(progress / 60)];
    //计算秒数
    NSString *sec = [NSString stringWithFormat: @"%02ld", (NSInteger)progress % 60];
    return [NSString stringWithFormat: @"%@:%@", min, sec];
}

#pragma mark - pageControl控制
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat n = self.ScrollView.contentOffset.x / (CGFloat)self.view.frame.size.width;
    NSInteger i = (NSInteger)(n + 0.5);
    if(i == 0)
    {
        self.pageControl.currentPage = 0;
    }
    if(i == 1)
    {
        self.pageControl.currentPage = 1;
    }
}

#pragma mark - 音量调整按钮

#pragma mark 音量加
- (IBAction)volumeUpAction:(UIButton *)sender
{
    if((self.volumeSlider.value + 0.1) <= 1)
    {
        self.volumeSlider.value += 0.1;
        [[MusicPlayManager SharedInstance] setVolumeValue: self.volumeSlider.value];
    }
    else if((self.volumeSlider.value + 0.1) > 1 && (self.volumeSlider.value + 0.1) < 1.1)
    {
        self.volumeSlider.value = 1;
        [[MusicPlayManager SharedInstance] setVolumeValue: self.volumeSlider.value];
    }
}

#pragma mark 音量减
- (IBAction)volumeDownAction:(UIButton *)sender
{
    if((self.volumeSlider.value - 0.1) >= 0)
    {
        self.volumeSlider.value -= 0.1;
        [[MusicPlayManager SharedInstance] setVolumeValue: self.volumeSlider.value];
    }
    else if((self.volumeSlider.value - 0.1) < 0 && (self.volumeSlider.value - 0.1) > -0.1)
    {
        self.volumeSlider.value = 0;
        [[MusicPlayManager SharedInstance] setVolumeValue: self.volumeSlider.value];
    }
}

-(void)dealloc
{
    NSLog(@"111");
}

#pragma mark -
-(void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
