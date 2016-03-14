//
//  MusicPlayManager.m
//  LYF_MusicPlayer
//
//  Created by 罗元丰 on 16/1/14.
//  Copyright © 2016年 罗元丰. All rights reserved.
//

#import "MusicPlayManager.h"
#import <AVFoundation/AVFoundation.h>

static MusicPlayManager *manager = nil;

@interface MusicPlayManager ()
//播放器
@property (nonatomic, strong) AVPlayer *musicPlayer;
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation MusicPlayManager

#pragma mark - 单例
+(instancetype)SharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[MusicPlayManager alloc] init];
    });
    return manager;
}

#pragma mark 初始化方法
-(instancetype)init
{
    self.musicPlayer = [[AVPlayer alloc] init];
    //播放器的默认音量
    self.musicPlayer.volume = 0.5;
    //设置起始状态为暂停
    self.status = NO;
    
    //注册播放状态的通知
//    [[NSNotificationCenter defaultCenter] addObserver: self forKeyPath: @"status" options: NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context: nil];
    //注册播放结束的通知
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(playEnd) name: AVPlayerItemDidPlayToEndTimeNotification object: nil];
    
    return self;
}

#pragma mark 接收到播放结束的通知时执行
-(void)playEnd
{
    if(self.playDelegate && [self.playDelegate respondsToSelector: @selector(playEndToTime)])
    {
        //代理执行协议方法
        [self.playDelegate playEndToTime];
    }
}

#pragma mark 调整播放器音量
-(void)setVolumeValue:(float)value
{
    self.musicPlayer.volume = value;
}

#pragma mark 从指定时间进行播放
-(void)seekTimeToPlay:(float)value
{
    [self pause];
    //传递指定 时间 和 单位 转换成CMTime
    CMTime time = CMTimeMakeWithSeconds(value, self.musicPlayer.currentTime.timescale);
    [self.musicPlayer seekToTime: time completionHandler:^(BOOL finished) {
        if(finished == YES)
        {
            [self play];
        }
    }];
}

#pragma mark 设置唱片 准备播放
-(void)prepareToPlayWithModel:(ListModel *)model
{
    //获取音乐播放地址 创建唱片
    AVPlayerItem *item = [AVPlayerItem playerItemWithURL: [NSURL URLWithString: model.mp3Url]];
    //给播放器配置唱片
    [self.musicPlayer replaceCurrentItemWithPlayerItem: item];
    
}

#pragma mark 播放
-(void)play
{
    if(self.status == NO)
    {
        //播放状态
        self.status = YES;
        //创建一个计时器
        self.timer = [NSTimer scheduledTimerWithTimeInterval: 0.1 target: self selector: @selector(playing) userInfo: nil repeats: YES];
        [self.musicPlayer play];
    }
}

#pragma mark 播放过程中持续执行
-(void)playing
{
    //让代理操作UI
    //计算当前播放时间（秒）
    CGFloat value = self.musicPlayer.currentTime.value;
    CGFloat scale = self.musicPlayer.currentTime.timescale;
    CGFloat seconds = value / scale;
    //让代理执行协议方法
    if(self.playDelegate && [self.playDelegate respondsToSelector: @selector(playerPlayingWithProgress:)])
    {
        [self.playDelegate playerPlayingWithProgress: seconds];
    }
}

#pragma mark 暂停
-(void)pause
{
    [self.timer invalidate];
    self.timer = nil;
    if(self.status == YES)
    {
        self.status = NO;
        [self.musicPlayer pause];
    }
}

#pragma mark 停止
-(void)stop
{
    
}

@end
