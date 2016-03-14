//
//  ListRequestManager.h
//  LYF_MusicPlayer
//
//  Created by 罗元丰 on 16/1/13.
//  Copyright © 2016年 罗元丰. All rights reserved.
//

/****
 *
 *用来管理音乐列表页面的数据请求和数据处理
 *
 */

#import <Foundation/Foundation.h>
#import "ListModel.h"

@interface ListRequestManager : NSObject

/**
 *shareInstance 单例
 */
+(instancetype)SharedInstance;

/**
 * @param NSString url 数据接口
 * @param block didFinish 完成回调
 * @return void
 **/
-(void)requestWithURL:(NSString *)url whenDidFinish:(void(^)())finish;

/**
 * @return NSinteger count 数组个数
 **/
-(NSInteger)countOfDataArray;

/**
 * @param index 下标
 * @return model 歌曲模型
 **/
-(ListModel *)modelWithIndex:(NSInteger)index;

@end
