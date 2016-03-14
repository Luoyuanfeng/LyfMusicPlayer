//
//  LyricManager.m
//  LYF_MusicPlayer
//
//  Created by 罗元丰 on 16/1/15.
//  Copyright © 2016年 罗元丰. All rights reserved.
//

#import "LyricManager.h"
#import "LyricModel.h"
#import <UIKit/UIKit.h>

static LyricManager *manager = nil;

@interface LyricManager ()

@property (nonatomic, strong) NSMutableArray *modelArray;

@end

@implementation LyricManager

/**
 * 单例
 **/
+(instancetype)SharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[LyricManager alloc] init];
    });
    return manager;
}

-(NSMutableArray *)modelArray
{
    if(!_modelArray)
    {
        _modelArray = [NSMutableArray array];
    }
    return _modelArray;
}

/**
 * 解析歌词
 * @param model 歌曲模型
 * @return void
 **/
-(void)initLyricWithModel:(ListModel *)model
{
    NSString *sourceLyric = model.lyric;
    //将歌词切割成行
    NSArray *lyricArr = [sourceLyric componentsSeparatedByString: @"\n"];
    //分割时间与歌词
    [self.modelArray removeAllObjects];
    for (NSString *item in lyricArr)
    {
//        NSString *copyItem = item;
        if([item isEqualToString: @""])
        {
//            copyItem = @"[5:00]-----END-----";
//            return;
            break;
        }
        NSArray *itemArr = [item componentsSeparatedByString: @"]"];
        float timeInSec = [self timeFormatter: itemArr[0]];
        LyricModel *model = [LyricModel lyricModelWithLyric: itemArr[1] andTime: timeInSec];
        //将创建好的模型装入数组
        [self.modelArray addObject: model];
    }
}

/**
 * 返回数组元素个数
 * @return modelArray.count
 **/
-(NSInteger)countOfModelArray
{
    return self.modelArray.count;
}

/**
 * @param 数组下标 index
 * @return LyricModel
 **/
-(LyricModel *)modelAtIndex:(NSInteger)index
{
    LyricModel *model = self.modelArray[index];
    return model;
}

/**
 * @param float播放时间
 * @return NSInteger 下标
 **/
-(NSInteger)indexForProgress:(float)progress
{
    NSInteger result = 0;
    for(int i = 0; i < [self countOfModelArray] - 1; i++)
    {
//        if(i == [self countOfModelArray] - 1)
//        {
////            result = i;
//            break;
//        }
        LyricModel *nowModel = [self modelAtIndex: i];
        LyricModel *nextModel = [self modelAtIndex: i + 1];
        if(nowModel.time < progress && progress < nextModel.time)
        {
            result = i;
        }
        if(progress > nextModel.time)
        {
            result = i + 1;
        }
    }
    return result;
}

#pragma mark 时间格式转换器
-(float)timeFormatter:(NSString *)stringTime
{
    NSString *timeStr = [[NSString alloc] init];
    timeStr = [stringTime substringFromIndex: 1];
    NSArray *arr = [timeStr componentsSeparatedByString: @":"];
    float min = [arr[0] floatValue];
    float sec = [arr[1] floatValue];
    return min * 60 + sec;
}

@end
