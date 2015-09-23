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

@end
static PMMusicPlayerManager * _musicPlayerManager;
@implementation PMMusicPlayerManager

#pragma mark - Private Method
- (void)calcuteTimeFormatter:(CMTime)time{

    CMTime duration = [self.musicPlayer.currentItem duration];
    int totalTime = floor(CMTimeGetSeconds(duration));
    int totalTimeMinute = totalTime / 60;
    int totalTimeSecond = totalTime % 60;
    
    int currentTime =  floor(CMTimeGetSeconds(time));
    int currentTimeMinute = currentTime / 60;
    int currentTimeSecond = currentTime % 60;
    
    self.currentTimeStatusFormat = [NSString stringWithFormat:@"%.2d:%.2d/%.2d:%.2d", \
                                    currentTimeMinute,currentTimeSecond, \
                                    totalTimeMinute,totalTimeSecond]; \
    self.currentMusicPlayProgress = currentTime / totalTime;
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
        [_musicPlayer addPeriodicTimeObserverForInterval:CMTimeMakeWithSeconds(1.0, NSEC_PER_SEC)
              queue:dispatch_get_global_queue(0, 0)
         usingBlock:^(CMTime time) {
             __strong typeof(wSelf) sSelf = wSelf;
             [sSelf calcuteTimeFormatter:time];
         }];
        
        return;
    }
    
    [_musicPlayer replaceCurrentItemWithPlayerItem:playerItem];
}

- (void)musicPlay{
    if (nil != _musicPlayer) {
        [_musicPlayer play];
    }
}

- (void)musicPause{
    if (nil != _musicPlayer) {
        [_musicPlayer pause];
    }
}




@end
