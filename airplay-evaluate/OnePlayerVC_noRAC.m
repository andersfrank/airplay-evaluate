//
//  OnePlayerVC.m
//  airplay-evaluate
//
//  Created by Anders Frank on 2014-10-21.
//  Copyright (c) 2014 Monterosa. All rights reserved.
//

#import "OnePlayerVC_noRAC.h"
#import "PlayerView.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <ReactiveCocoa/RACEXTScope.h>

#import "AVPlayer+RAC.h"



#import "Config.h"

@interface OnePlayerVC_noRAC ()

@property (nonatomic) PlayerView *playerView;
@property (nonatomic) RACDisposable *disposable;
@property (nonatomic) AVPlayerItem *mainStreamItem;
@property (nonatomic, strong) id token;
@end

@implementation OnePlayerVC_noRAC

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.playerView = [PlayerView new];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStylePlain target:self action:@selector(didTapCloseButton)];
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.playerView];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    
    NSTimeInterval commercialBreakTime = 10;
    
    self.mainStreamItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:kMainStreamPath]];
    AVPlayerItem *adItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:kAdPath]];
    
    self.playerView.player = [AVPlayer playerWithPlayerItem:self.mainStreamItem];
    [self.playerView.player play];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(commercialBreakTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.playerView.player replaceCurrentItemWithPlayerItem:adItem];
        [self.playerView.player play];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didPlayToEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    });
    
}

- (void)didPlayToEnd:(NSNotification *)notif {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    [self.playerView.player replaceCurrentItemWithPlayerItem:self.mainStreamItem];
    [self.playerView.player play];
}

- (void)didTapCloseButton {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    [self.playerView.player pause];
    [self close];
}

- (void)close {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.playerView.frame = self.view.bounds;
}


@end
