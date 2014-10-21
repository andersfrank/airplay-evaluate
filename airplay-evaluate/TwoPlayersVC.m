//
//  OnePlayerVC.m
//  airplay-evaluate
//
//  Created by Anders Frank on 2014-10-21.
//  Copyright (c) 2014 Monterosa. All rights reserved.
//

#import "TwoPlayersVC.h"
#import "PlayerView.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <ReactiveCocoa/RACEXTScope.h>

#import "AVPlayer+RAC.h"

#import "Config.h"


@interface TwoPlayersVC ()

@property (nonatomic) PlayerView *mainStreamPlayerView;
@property (nonatomic) PlayerView *adPlayerView;
@property (nonatomic) RACDisposable *disposable;

@end

@implementation TwoPlayersVC

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.mainStreamPlayerView = [PlayerView new];
        self.mainStreamPlayerView.alpha = 0;
        
        self.adPlayerView = [PlayerView new];
        self.adPlayerView.alpha = 0;
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStylePlain target:self action:@selector(didTapCloseButton)];
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view addSubview:self.mainStreamPlayerView];
    [self.view addSubview:self.adPlayerView];
    
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    

    NSTimeInterval commercialBreakTime = 10;
    
    AVPlayerItem *mainStreamItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:kMainStreamPath]];
    AVPlayerItem *adItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:kAdPath]];
    
    self.mainStreamPlayerView.player = [AVPlayer playerWithPlayerItem:mainStreamItem];
    [self.mainStreamPlayerView.player play];
    self.mainStreamPlayerView.alpha = 1;
    
    @weakify(self);
    
    self.disposable = [[[[[[[[[[self.mainStreamPlayerView.player periodicTimeObserveWithRefreshInterval:0.5]
    
    filter:^BOOL(NSNumber *currentTime) {
        return currentTime.floatValue > commercialBreakTime;
    }]
    
    take:1] doNext:^(id x) {
        NSLog(@"before delay");
    }]
                           
    delay:1.0f] doNext:^(id x) {
        NSLog(@"after delay");
    }]

    // Play commercial
    flattenMap:^RACStream *(id value) {
        @strongify(self);
        
        self.mainStreamPlayerView.alpha = 0;
        [self.mainStreamPlayerView.player pause];
        
        self.adPlayerView.alpha = 1;
        self.adPlayerView.player = [AVPlayer playerWithPlayerItem:adItem];
        [self.adPlayerView.player play];
        return [[self didPlayToEndTimeNotification] take:1];
    }] delay:1.0]
    // Play main stream again
    flattenMap:^RACStream *(id value) {
        @strongify(self);
        
        self.adPlayerView.alpha = 0;
        self.adPlayerView.player.rate = 0.0f;
        
        self.mainStreamPlayerView.alpha = 1;
        [self.mainStreamPlayerView.player play];

        return [[self didPlayToEndTimeNotification] take:1];
    }] subscribeCompleted:^{
        @strongify(self);
        [self close];
    }];
    
}

- (void)didTapCloseButton {
    [self.disposable dispose];
    self.adPlayerView.player.rate = 0.0f;
    self.mainStreamPlayerView.player.rate = 0.0f;
    [self close];
}

- (void)close {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (RACSignal *)didPlayToEndTimeNotification {
    return [[NSNotificationCenter.defaultCenter rac_addObserverForName:AVPlayerItemDidPlayToEndTimeNotification object:nil] takeUntil:self.rac_willDeallocSignal];
}


- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.mainStreamPlayerView.frame = self.view.bounds;
    self.adPlayerView.frame = self.view.bounds;
}


@end
