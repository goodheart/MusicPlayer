//
//  ViewController.m
//  MusicPlayer
//
//  Created by 马健Jane on 15/9/23.
//  Copyright © 2015年 HSC. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "PMMusicPlayerManager.h"
@interface ViewController ()
@property (nonatomic,strong) AVPlayer * player;
@property (nonatomic,strong) PMMusicPlayerManager * musicPlayerManager;
@end

#define currentTimeStatusFormat @"currentTimeStatusFormat"
#define currentMusicPlayProgress @"currentMusicPlayProgress"
#define remote 1
#define k_remotePath @"http://mp4.snh48.com/f4126cff-8282-4f4f-af3e-68d62f7c8b02.mp4"
@implementation ViewController
- (IBAction)play:(id)sender {
    [[PMMusicPlayerManager sharedMusicPlayerManager] musicPlay];
}

- (IBAction)pause:(id)sender {
    [[PMMusicPlayerManager sharedMusicPlayerManager] musicPause];
}

- (IBAction)next:(id)sender {
    
    NSString * musicPath = @"http://mp4.snh48.com/nightwords/0df12e50-56af-4ca8-9c8d-00c1eb7d7286.mp3";
    
    [[PMMusicPlayerManager sharedMusicPlayerManager] switchToMusicStr:musicPath];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString * musicPath = remote == 1 ? k_remotePath : [[NSBundle mainBundle] pathForResource:@"music" ofType:@"mp3"];

    NSURL * musicURL = [NSURL URLWithString:musicPath];
    
    [[PMMusicPlayerManager sharedMusicPlayerManager] switchToMusicURL:musicURL];
    
    //监听manager的值
    [[PMMusicPlayerManager sharedMusicPlayerManager] addObserver:self
                                                      forKeyPath:currentTimeStatusFormat
                                                         options:NSKeyValueObservingOptionNew
                                                         context:nil];
    [[PMMusicPlayerManager sharedMusicPlayerManager] addObserver:self
                                                    forKeyPath:currentMusicPlayProgress
                                                         options:NSKeyValueObservingOptionNew
                                                         context:nil];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [[PMMusicPlayerManager sharedMusicPlayerManager] musicPlay];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:currentTimeStatusFormat]) {
        NSString * format = [change objectForKey:NSKeyValueChangeNewKey];
        dispatch_async(dispatch_get_main_queue(), ^{//必须在主线程上
            self.timeStatusFormat.text = format;
        });
    } else if ([keyPath isEqualToString:currentMusicPlayProgress]) {
        dispatch_async(dispatch_get_main_queue(), ^{//必须在主线程
            [self.timeStatusProgress setProgress: \
             [[change objectForKey:NSKeyValueChangeNewKey] floatValue]];
        });

    }
}
@end








