//
//  ViewController.h
//  MusicPlayer
//
//  Created by 马健Jane on 15/9/23.
//  Copyright © 2015年 HSC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *timeStatusFormatLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *timeStatusProgressView;
@property (weak, nonatomic) IBOutlet UITableView *musicListView;


@end

