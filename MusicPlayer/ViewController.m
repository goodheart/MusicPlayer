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
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) AVPlayer * player;
@property (nonatomic,strong) PMMusicPlayerManager * musicPlayerManager;
@property (nonatomic,strong) NSArray * musicArray;
@end

#define currentTimeStatusFormat @"currentTimeStatusFormat"
#define currentMusicPlayProgress @"currentMusicPlayProgress"
#define remote 1
#define k_remotePath @"http://mp4.snh48.com/f4126cff-8282-4f4f-af3e-68d62f7c8b02.mp4"
#define k_remotePath2 @"http://mp4.snh48.com/nightwords/0df12e50-56af-4ca8-9c8d-00c1eb7d7286.mp3"
#define k_remotePath3 @"http://mp4.snh48.com/nightwords/91027591-d9aa-48b3-9b41-d6cea020e033.mp3"

@implementation ViewController
#pragma mark - Action
- (IBAction)play:(id)sender {
    if (YES == [[PMMusicPlayerManager sharedMusicPlayerManager] isPaused]) {
        [[PMMusicPlayerManager sharedMusicPlayerManager] musicPlay];
    }
}

- (IBAction)pause:(id)sender {
    if (NO == [[PMMusicPlayerManager sharedMusicPlayerManager] isPaused]    ) {
        [[PMMusicPlayerManager sharedMusicPlayerManager] musicPause];
    }
}

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    /* Table View */
    self.musicArray = @[k_remotePath,k_remotePath2,k_remotePath3];
    
    self.musicListView.delegate = self;
    self.musicListView.dataSource = self;
    
    [self.musicListView registerClass:[UITableViewCell class]
               forCellReuseIdentifier:NSStringFromClass([self class])];
    
    /* Music Play */
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
            self.timeStatusFormatLabel.text = format;
        });
    } else if ([keyPath isEqualToString:currentMusicPlayProgress]) {
        dispatch_async(dispatch_get_main_queue(), ^{//必须在主线程
            [self.timeStatusProgressView setProgress: \
             [[change objectForKey:NSKeyValueChangeNewKey] floatValue]];
        });
    }
}

#pragma mark - UITableViewDelegate

#pragma mark - UITableView Delegate and DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.musicArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([self class])];
    
    cell.textLabel.text = [self.musicArray objectAtIndex:indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.textLabel.font = [UIFont systemFontOfSize:10];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [[PMMusicPlayerManager sharedMusicPlayerManager] switchToMusicStr: \
                                        [self.musicArray objectAtIndex:indexPath.row]];
    [[PMMusicPlayerManager sharedMusicPlayerManager] musicPlay];
}

@end








