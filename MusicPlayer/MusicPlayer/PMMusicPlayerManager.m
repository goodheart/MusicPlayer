//
//  PMMusicPlayerManager.m
//  MusicPlayer
//
//  Created by 马健Jane on 15/9/23.
//  Copyright © 2015年 HSC. All rights reserved.
//

#import "PMMusicPlayerManager.h"
#import <AVFoundation/AVFoundation.h>
@interface PMMusicPlayerManager (){

}
/* header readonly */
@property (nonatomic,copy,readwrite) NSString * currentTimeStatusFormat;//格式:00:05/20:30
@property (nonatomic,assign,readwrite) float currentMusicPlayProgress;

/* private property */
@property (nonatomic,strong) AVPlayer * musicPlayer;
//是否暂停
@property (nonatomic,assign,readwrite,getter=isPaused) BOOL paused;

@end
static PMMusicPlayerManager * _musicPlayerManager;
@implementation PMMusicPlayerManager

#pragma mark - Life Cycle
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.firstAutoPlay = NO;//默认不自动播放
    }
    return self;
}

#pragma mark - Public Method
+ (id)sharedMusicPlayerManager{

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _musicPlayerManager = [[PMMusicPlayerManager alloc] init];
    });
    
    return _musicPlayerManager;
}

- (void)switchToMusicStr:(NSString *)musicURLString {
    if (nil == musicURLString) {
        return;
    }
    
    NSURL * musicURL = [NSURL URLWithString:musicURLString];
    [self switchToMusicURL:musicURL];
}

- (void)switchToMusicURL:(NSURL *)musicURL {
    //检查URL是否合法
    if (nil == musicURL) {
        return;
    }
    
    AVPlayerItem * playerItem = [[AVPlayerItem alloc] initWithURL:musicURL];
    
    if (nil == _musicPlayer) {

        _musicPlayer = [AVPlayer playerWithPlayerItem:playerItem];
        
        __weak typeof(self) wSelf = self;
        //添加监听
        [_musicPlayer addPeriodicTimeObserverForInterval:CMTimeMakeWithSeconds(1.0, NSEC_PER_SEC)
              queue:dispatch_get_global_queue(0, 0)
         usingBlock:^(CMTime time) {
             __strong typeof(wSelf) sSelf = wSelf;
             if (![sSelf isPaused]) {
                 [sSelf calcuteTimeFormatter:time];
             }
         }];
        
        self.firstAutoPlay == NO ? : [self musicPlay];
        
        return;
    }
    
//    [self musicPause];//切换音乐时先把之前的音乐暂停
    self.paused = YES;

    [_musicPlayer replaceCurrentItemWithPlayerItem:playerItem];
}

- (void)musicPlay{
    if (nil != _musicPlayer) {
        if (_musicPlayer.rate == 0.0) {
            [_musicPlayer play];
        }
    }
}

- (void)musicPause{
    if (nil != _musicPlayer) {
        if (_musicPlayer.rate == 1.0) {
            [_musicPlayer pause];
        }
    }
}

- (BOOL)isPaused {
    return self.musicPlayer.rate == 0.0;
}

#pragma mark - Private Method
- (void)calcuteTimeFormatter:(CMTime)time{//该方法运行在多线程，而不是主线程
    if (CMTIME_IS_INVALID(time)) {
        return;
    }
    
    CMTime duration = [self.musicPlayer.currentItem duration];
    int totalTime = floor(CMTimeGetSeconds(duration));
    int totalTimeMinute = totalTime / 60 < 0 ? 0 : totalTime / 60;
    int totalTimeSecond = totalTime % 60 < 0 ? 0 : totalTime % 50;
    
    int currentTime =  floor(CMTimeGetSeconds(time));
    int currentTimeMinute = currentTime / 60 < 0 ? 0 : currentTime / 60 ;
    int currentTimeSecond = currentTime % 60 < 0 ? 0 : currentTime % 60;
    
    NSString * format = [NSString stringWithFormat:@"%.2d:%.2d/%.2d:%.2d", \
                         currentTimeMinute,currentTimeSecond, \
                         totalTimeMinute,totalTimeSecond];
    
    self.currentTimeStatusFormat = format;
    
//    self.currentMusicPlayProgress = CMTimeGetSeconds(time) / CMTimeGetSeconds(duration);
    self.currentMusicPlayProgress = (float)(currentTimeMinute * 60 + currentTimeSecond) / (totalTimeMinute * 60 + totalTimeSecond);
    //以下为通知代理
    if (nil == self.delegate) {
        return;
    }
    
    if (![self.delegate conformsToProtocol:@protocol(PMMusicPlayerManagerProtocol)]) {
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(musicPlayerManager:playerCurrentMusicPlayProgress:)]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate musicPlayerManager:self
               playerCurrentMusicPlayProgress:self.currentMusicPlayProgress];
        });
    }
    
    if ([self.delegate respondsToSelector:@selector(musicPlayerManager:playerCurrentTimeStatusFormat:)]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate musicPlayerManager:self
                playerCurrentTimeStatusFormat:self.currentTimeStatusFormat];
        });
    }
}

/*
 2015-09-23 18:42:19.043 MusicPlayer[37221:750962] 18:42:19.043 ERROR:    177: timed out after 0.012s (192 192); mMajorChangePending=0
 */

@end
