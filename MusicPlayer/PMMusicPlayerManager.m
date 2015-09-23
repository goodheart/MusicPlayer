//
//  PMMusicPlayerManager.m
//  MusicPlayer
//
//  Created by 马健Jane on 15/9/23.
//  Copyright © 2015年 HSC. All rights reserved.
//

#import "PMMusicPlayerManager.h"
#import <AVFoundation/AVFoundation.h>
@interface PMMusicPlayerManager ()
/* header readonly */
@property (nonatomic,copy,readwrite) NSString * currentTimeStatus;//格式:00:05/20:30

/* private property */
@property (nonatomic,strong) AVPlayer * musicPlayer;

@end


@implementation PMMusicPlayerManager

#pragma mark - Public Method
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
