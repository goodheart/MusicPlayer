//
//  PMMusicPlayerManager.h
//  MusicPlayer
//
//  Created by 马健Jane on 15/9/23.
//  Copyright © 2015年 HSC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PMMusicPlayerManager : NSObject
/*
    业务方传入一个音乐地址(NSString或NSURL类型),本Manager即开始播放音乐(应该检查网络是否可用),需要提供的功能有：开始/暂停、时间:(已用时间/总时间)、切换歌曲
 */

@property (nonatomic,copy,readonly) NSString * currentTimeStatus;//格式:00:05/20:30

- (void)switchToMusicStr:(NSString *)musicURLString;
- (void)switchToMusicURL:(NSURL *)musicURL;

- (void)musicPlay;
- (void)musicPause;


@end
