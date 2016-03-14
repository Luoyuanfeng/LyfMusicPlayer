//
//  MusicPlayManager.h
//  LYF_MusicPlayer
//
//  Created by 罗元丰 on 16/1/14.
//  Copyright © 2016年 罗元丰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ListModel.h"

/**
 * 用来管理音乐播放的相关操作
 **/

/**
 * 播放器协议
 **/
@protocol AVPlayerDelegate <NSObject>

/**
 * 播放过程中一直执行
 * @param 播放进度
 **/
-(void)playerPlayingWithProgress:(float)progress;

/**
 * 播放结束时执行
 **/
-(void)playEndToTime;

@end

@interface MusicPlayManager : NSObject

//记录播放状态
@property (nonatomic, assign) BOOL status;
//代理
@property (nonatomic, assign) id <AVPlayerDelegate> playDelegate;

/**
 * 单例
 **/
+(instancetype)SharedInstance;

/**
 * @param 音乐模型
 * 设置唱片
 **/
-(void)prepareToPlayWithModel:(ListModel *)model;

/**
 * 播放
 **/
-(void)play;

/**
 * 暂停
 **/
-(void)pause;

/**
 * 停止
 **/
-(void)stop;

/**
 * @param 声音的值
 **/
-(void)setVolumeValue:(float)value;

/**
 * @param value float 指定的时间
 **/
-(void)seekTimeToPlay:(float)value;

@end
