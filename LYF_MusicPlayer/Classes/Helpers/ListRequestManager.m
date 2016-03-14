//
//  ListRequestManager.m
//  LYF_MusicPlayer
//
//  Created by 罗元丰 on 16/1/13.
//  Copyright © 2016年 罗元丰. All rights reserved.
//

#import "ListRequestManager.h"

static ListRequestManager *manager = nil;

@interface ListRequestManager ()
//用来存放所有模型
@property (nonatomic, strong) NSMutableArray *modelsArray;
@end

@implementation ListRequestManager

#pragma mark - 单例
+(instancetype)SharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [ListRequestManager new];
    });
    return manager;
}

#pragma mark - modelsArray的懒加载
-(NSMutableArray *)modelsArray
{
    if(!_modelsArray)
    {
        _modelsArray = [NSMutableArray array];
    }
    return _modelsArray;
}

#pragma mark - 数据处理

#pragma mark 根据URL请求数据，并进行回调
-(void)requestWithURL:(NSString *)url whenDidFinish:(void (^)())finish
{
    //开辟子线程
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSArray *dataArray = [NSArray arrayWithContentsOfURL: [NSURL URLWithString: url]];
        //进行数据解析
        if(!dataArray)
        {
            NSLog(@"dataArray is nil");
            return;
        }
        //遍历数组，取出字典
        for(NSDictionary *dict in dataArray)
        {
            //创建模型
            ListModel *model = [[ListModel alloc] init];
            [model setValuesForKeysWithDictionary: dict];
            //将model存入数组
            NSLog(@"%@", model.mp3Url);
            [self.modelsArray addObject: model];
        }
        //回到主线程刷新界面
        dispatch_async(dispatch_get_main_queue(), ^{
            //block回调
            finish();
        });
    });
}

#pragma mark 返回数组个数
-(NSInteger)countOfDataArray
{
    return self.modelsArray.count;
}

#pragma mark 根据下标返回模型
-(ListModel *)modelWithIndex:(NSInteger)index
{
    ListModel *model = self.modelsArray[index];
    return model;
}

@end
