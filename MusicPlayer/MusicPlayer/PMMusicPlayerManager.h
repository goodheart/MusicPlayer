//
//  PMMusicPlayerManager.h
//  MusicPlayer
//
//  Created by 马健Jane on 15/9/23.
//  Copyright © 2015年 HSC. All rights reserved.
//

#import <Foundation/Foundation.h>

//不同的错误原因,暂时没有提供错误提示
typedef NS_OPTIONS(NSUInteger, PMMusicPlayerError) {
    PMMusicPlayerErrorMusicAddr,//错误的音乐地址
    
};

@class PMMusicPlayerManager;
@protocol PMMusicPlayerManagerProtocol <NSObject>

- (void)musicPlayerManager:(PMMusicPlayerManager *)musicPlayer playerCurrentTimeStatusFormat:(NSString *)timeStatusFormat;

- (void)musicPlayerManager:(PMMusicPlayerManager *)musicPlayer playerCurrentMusicPlayProgress:(float)progress;

@end


@interface PMMusicPlayerManager : NSObject
/*
    业务方传入一个音乐地址(NSString或NSURL类型),本Manager即开始播放音乐(应该检查网络是否可用),需要提供的功能有：开始/暂停、时间:(已用时间/总时间)、切换歌曲、音乐播放进度
 待定:
   1、后台运行、remote控制、锁屏有封面、电话和听歌打断处理等
   2、currentTimeStatusFormat时间格式可定制
   3、提供业务方当前的错误原因
 */

/*
   1、 根据不同场景，选择是否使用单例实现音频播放。如果希望页面关闭后音乐继续播放，则使用单例比较方便，当然不使用单例也可以，比如appDelegate持有一个musicPlayerManager的实例，供全局使用，当然，能不用单例就不用单例，因为单例的坑很多，大家懂得。
   2、此处使用两种方法使业务方能实时获取currentTimeStatusFormat和currentMusicPlayProgress，第一种KVC和KVO,第二种使用代理，本来想加个block的，但本人不喜欢向业务方提供block形式的接口。当然大家可以自己加。
 */

+ (id)sharedMusicPlayerManager;

//音乐播放时间格式化,建议用KVO进行同步
@property (nonatomic,copy,readonly) NSString * currentTimeStatusFormat;//格式:00:05/20:30
//当前音乐播放进度,建议用KVO进行同步
@property (nonatomic,assign,readonly) float currentMusicPlayProgress;
//是否暂停
@property (nonatomic,assign,readonly,getter=isPaused) BOOL paused;
//第一次是否自动播放,默认不自动播放
@property (nonatomic,assign) BOOL firstAutoPlay;
//通过代理通知业务方当前的已播放时间以及进度，此处不需要使用数组存储所有的代理，只要做到在哪个页面，对应页面的controller设置成代理即可
@property (nonatomic,weak) id<PMMusicPlayerManagerProtocol> delegate;


//开始一首歌/切换至另一首歌
- (void)switchToMusicStr:(NSString *)musicURLString;
- (void)switchToMusicURL:(NSURL *)musicURL;
//播放音乐
- (void)musicPlay;
//暂停音乐
- (void)musicPause;

@end
