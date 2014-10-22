//
//  OnePlayerVC.m
//  airplay-evaluate
//
//  Created by Anders Frank on 2014-10-21.
//  Copyright (c) 2014 Monterosa. All rights reserved.
//

#import "OnePlayerVC.h"
#import "PlayerView.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <ReactiveCocoa/RACEXTScope.h>

#import "AVPlayer+RAC.h"



#import "Config.h"

@interface OnePlayerVC ()

@property (nonatomic) PlayerView *playerView;
@property (nonatomic) RACDisposable *disposable;

@end

@implementation OnePlayerVC

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

//- (void)viewDidAppear:(BOOL)animated {
//    [super viewDidAppear:animated];
//    
//
//    NSTimeInterval commercialBreakTime = 10;
//    
//    AVPlayerItem *mainStreamItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:kMainStreamPath]];
//    AVPlayerItem *adItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:kAdPath]];
//    
//    self.playerView.player = [AVPlayer playerWithPlayerItem:mainStreamItem];
//    [self.playerView.player play];
//    
//    @weakify(self);
//    
//    self.disposable = [[[[[[[self.playerView.player periodicTimeObserveWithRefreshInterval:0.5]
//    
//    filter:^BOOL(NSNumber *currentTime) {
//        return currentTime.floatValue > commercialBreakTime;
//    }]
//    
//    take:1]
//    
//    delay:0.0]
//    
//    // Play commercial
//    flattenMap:^RACStream *(id value) {
//        @strongify(self);
//        [self.playerView.player replaceCurrentItemWithPlayerItem:adItem];
//        return [[self didPlayToEndTimeNotification] take:1];
//    }]
//    // Play main stream again
//    flattenMap:^RACStream *(id value) {
//        @strongify(self);
//        [self.playerView.player replaceCurrentItemWithPlayerItem:mainStreamItem];
//        [self.playerView.player seekToTime:CMTimeMakeWithSeconds(commercialBreakTime, NSEC_PER_SEC)];
//        [self.playerView.player play];
//        return [[self didPlayToEndTimeNotification] take:1];
//    }] subscribeCompleted:^{
//        @strongify(self);
//        [self close];
//    }];
//    
//}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    
    NSTimeInterval commercialBreakTime = 10;
    
    AVPlayerItem *mainStreamItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:kMainStreamPath]];

    

    
    self.playerView.player = [AVPlayer playerWithPlayerItem:mainStreamItem];
    [self.playerView.player play];


    [[[RACSignal interval:1 onScheduler:[RACScheduler mainThreadScheduler]] take:1]
     subscribeNext:^(id x) {
         dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
             AVPlayerItem *adItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:kAdPath]];
             [self.playerView.player replaceCurrentItemWithPlayerItem:adItem];
         });

     }];
    
    
//    [[[RACSignal return:nil] delay:1] subscribeNext:^(id x) {
//        NSLog(@"self.playerView.player.currentItem: %@",self.playerView.player.currentItem);
//        
//        AVPlayerItem *adItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:kAdPath]];
//        [self.playerView.player replaceCurrentItemWithPlayerItem:adItem];
//
    
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [[adItem.errorLog events] enumerateObjectsUsingBlock:^(AVPlayerItemErrorLogEvent *event, NSUInteger idx, BOOL *stop) {
//                NSLog(@"comment: %@",event.errorComment);
//            }];
//        });
        

//        dispatch_async(dispatch_get_main_queue(), ^{
//        [self playAd];
//        });
//    }];
    
    @weakify(self);
    
//    [[[RACSignal return:adItem] delay:10]
//    subscribeNext:^(AVPlayerItem *item) {
//        NSLog(@"current thread: %@",[NSThread currentThread]);
//        @strongify(self);
//        NSLog(@"item: %@",item);
//        dispatch_async(dispatch_get_main_queue(), ^{
//            NSLog(@"current thread: %@",[NSThread currentThread]);
//            [self.playerView.player replaceCurrentItemWithPlayerItem:item];
//        });
//
//        NSLog(@"2 item: %@",self.playerView.player.currentItem.asset.debugDescription);
//    }];
    
    [RACObserve(self.playerView.player, status) subscribeNext:^(id x) {
        NSLog(@"status: %@",x);
    }];
    
    [RACObserve(self.playerView.player, rate) subscribeNext:^(id x) {
        NSLog(@"rate: %@",x);
    }];
    
    
//    AVPlayerStatusUnknown,
//    AVPlayerStatusReadyToPlay,
//    AVPlayerStatusFailed
    
}

- (void)playAd {
    AVPlayerItem *adItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:kAdPath]];
    [self.playerView.player replaceCurrentItemWithPlayerItem:adItem];
}

- (void)didTapCloseButton {
    [self.disposable dispose];
    [self.playerView.player pause];
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
    self.playerView.frame = self.view.bounds;
}


@end
