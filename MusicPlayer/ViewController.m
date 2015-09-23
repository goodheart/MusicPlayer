//
//  ViewController.m
//  MusicPlayer
//
//  Created by 马健Jane on 15/9/23.
//  Copyright © 2015年 HSC. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface ViewController ()
@property (nonatomic,strong) AVPlayer * player;
@end

#define remote 1

#define k_remotePath @"http://mp4.snh48.com/f4126cff-8282-4f4f-af3e-68d62f7c8b02.mp4"
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString * musicPath = remote == 1 ? k_remotePath : [[NSBundle mainBundle] pathForResource:@"music" ofType:@"mp3"];
    
    NSURL * musicURL = [NSURL URLWithString:musicPath];
//    self.player = [[AVPlayer alloc] initWithURL:musicURL];
    AVPlayerItem * playerItem = [[AVPlayerItem alloc] initWithURL:musicURL];
    
    self.player = [AVPlayer playerWithPlayerItem:playerItem];
    __weak typeof(self) wSelf = self;
    [self.player addPeriodicTimeObserverForInterval:CMTimeMakeWithSeconds(1.0, NSEC_PER_SEC)
                                              queue:dispatch_get_global_queue(0, 0)
                                         usingBlock:^(CMTime cmtime) {
                                             __strong typeof(wSelf) sSelf = wSelf;
                     CMTime duration = [sSelf.player.currentItem duration];
                     int totalTime = floor(CMTimeGetSeconds(duration));
                     int totalTimeMinute = totalTime / 60;
                     int totalTimeSecond = totalTime % 60;
                    
                    int currentTime =  floor(CMTimeGetSeconds(cmtime));
                     int currentTimeMinute = currentTime / 60;
                     int currentTimeSecond = currentTime % 60;
                 NSLog(@"%.2d:%.2d/%.2d:%.2d",currentTimeMinute,currentTimeSecond,totalTimeMinute,totalTimeSecond);
        
    }];
    
    [self.player play];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    1661.270000
//    27m40s


    
    /*
    AVPlayerStatus status = self.player.status;
    switch (status) {
        case AVPlayerStatusFailed:
            NSLog(@"Failed");
        break;
        case AVPlayerStatusUnknown:
            NSLog(@"Unknown");
        break;
        case AVPlayerStatusReadyToPlay:
                [self.player play];
                
            NSLog(@"ReadyToPlay");
        break;
        default:
            break;
    }
     */
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
