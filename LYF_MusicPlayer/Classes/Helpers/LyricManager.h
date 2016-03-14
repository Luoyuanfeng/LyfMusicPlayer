//
//  LyricManager.h
//  LYF_MusicPlayer
//
//  Created by 罗元丰 on 16/1/15.
//  Copyright © 2016年 罗元丰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ListModel.h"

@class LyricModel;

/**
 * 处理歌词
 **/

@interface LyricManager : NSObject

/**
 * 单例
 **/
+(instancetype)SharedInstance;

/**
 * @param model 歌曲模型
 * @return void
 **/
-(void)initLyricWithModel:(ListModel *)model;

/**
 * 返回数组元素个数
 * @return modelArray.count
 **/
-(NSInteger)countOfModelArray;

/**
 * @param 数组下标 index
 * @return LyricModel
 **/
-(LyricModel *)modelAtIndex:(NSInteger)index;

/**
 * @param float播放时间
 * @return NSInteger 下标
 **/
-(NSInteger)indexForProgress:(float)progress;

@end
