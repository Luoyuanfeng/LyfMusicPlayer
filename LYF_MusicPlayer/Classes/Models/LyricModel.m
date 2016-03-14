//
//  LyricModel.m
//  LYF_MusicPlayer
//
//  Created by 罗元丰 on 16/1/15.
//  Copyright © 2016年 罗元丰. All rights reserved.
//

#import "LyricModel.h"

@implementation LyricModel

+(instancetype)lyricModelWithLyric:(NSString *)lyric andTime:(float)time
{
    LyricModel *model = [[LyricModel alloc] init];
    model.lyric = lyric;
    model.time = time;
    return model;
}

@end
