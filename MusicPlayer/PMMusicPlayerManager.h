//
//  PMMusicPlayerManager.h
//  MusicPlayer
//
//  Created by 马健Jane on 15/9/23.
//  Copyright © 2015年 HSC. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_OPTIONS(NSUInteger, PMMusicPlayerError) {
    PMMusicPlayerErrorMusicAddr,//错误的音乐地址
    
};


@interface PMMusicPlayerManager : NSObject
/*
    业务方传入一个音乐地址(NSString或NSURL类型),本Manager即开始播放音乐(应该检查网络是否可用),需要提供的功能有：开始/暂停、时间:(已用时间/总时间)、切换歌曲、音乐播放进度
 待定:
    后台运行、remote控制、锁屏有封面、电话和听歌打断处理等
 */

+ (id)sharedMusicPlayerManager;

//音乐播放时间格式化,建议用KVO进行同步
@property (nonatomic,copy,readonly) NSString * currentTimeStatusFormat;//格式:00:05/20:30
//当前音乐播放进度,建议用KVO进行同步
@property (nonatomic,assign,readonly) float currentMusicPlayProgress;

//开始一首歌/切换至另一首歌
- (void)switchToMusicStr:(NSString *)musicURLString;
- (void)switchToMusicURL:(NSURL *)musicURL;
//播放音乐
- (void)musicPlay;
//暂停音乐
- (void)musicPause;


@end
