//
//  LyricModel.h
//  LYF_MusicPlayer
//
//  Created by 罗元丰 on 16/1/15.
//  Copyright © 2016年 罗元丰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LyricModel : NSObject

//歌词属性
@property (nonatomic, assign) float time;
//时间属性
@property (nonatomic, copy) NSString *lyric;

/**
 *便利构造器
 * @param lyric time
 * @return instancetype
 **/
+(instancetype)lyricModelWithLyric:(NSString *)lyric andTime:(float)time;

@end
