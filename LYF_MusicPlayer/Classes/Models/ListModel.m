//
//  ListModel.m
//  LYF_MusicPlayer
//
//  Created by 罗元丰 on 16/1/13.
//  Copyright © 2016年 罗元丰. All rights reserved.
//

#import "ListModel.h"

@implementation ListModel

-(void)setValue:(id)value forKey:(NSString *)key
{
    //如果key是id，将value赋给ID
    if([key isEqualToString: @"id"])
    {
        self.ID = value;
    }
    [super setValue:value forKey:key];
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

@end
