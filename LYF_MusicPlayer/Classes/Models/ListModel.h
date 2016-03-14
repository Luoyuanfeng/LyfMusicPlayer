//
//  ListModel.h
//  LYF_MusicPlayer
//
//  Created by 罗元丰 on 16/1/13.
//  Copyright © 2016年 罗元丰. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *
 *音乐列表模型
 *
 */

@interface ListModel : NSObject

//mp3地址
@property(nonatomic, copy) NSString *mp3Url;
//歌曲id
@property(nonatomic, copy) NSString *ID;
//歌名
@property(nonatomic, copy) NSString *name;
//图片地址
@property(nonatomic, copy) NSString *picUrl;
//缩略图
@property(nonatomic, copy) NSString *blurPicUrl;
//专辑名
@property(nonatomic, copy) NSString *album;
//歌手名
@property(nonatomic, copy) NSString *singer;
//歌曲时长
@property(nonatomic, copy) NSString *duration;
//作者名
@property(nonatomic, copy) NSString *artists_name;
//歌词
@property(nonatomic, copy) NSString *lyric;

@end
