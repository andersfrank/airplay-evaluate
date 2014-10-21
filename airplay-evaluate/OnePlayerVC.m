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

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    

    NSTimeInterval commercialBreakTime = 10;
    
    AVPlayerItem *mainStreamItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:kMainStreamPath]];
    AVPlayerItem *adItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:kAdPath]];
    
    self.playerView.player = [AVPlayer playerWithPlayerItem:mainStreamItem];
    [self.playerView.player play];
    
    @weakify(self);
    
    self.disposable = [[[[[[[[self.playerView.player periodicTimeObserveWithRefreshInterval:0.5]
    
    filter:^BOOL(NSNumber *currentTime) {
        return currentTime.floatValue > commercialBreakTime;
    }]
    
    take:1] doNext:^(id x) {
        [self.playerView.player pause];
        NSLog(@"delaying value: %@",x);
    }] delay:0.0]
    // Play commercial
    flattenMap:^RACStream *(id value) {
        NSLog(@"value: %@",value);
        NSLog(@"thread: %d",[NSThread isMainThread]);
        @strongify(self);
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [self.playerView.player replaceCurrentItemWithPlayerItem:adItem];
//        });
        [self.playerView.player replaceCurrentItemWithPlayerItem:adItem];
        return [[self didPlayToEndTimeNotification] take:1];
    }]// delay:1.0]
    // Play main stream again
    flattenMap:^RACStream *(id value) {
        @strongify(self);
        [self.playerView.player replaceCurrentItemWithPlayerItem:mainStreamItem];
        [self.playerView.player seekToTime:CMTimeMakeWithSeconds(commercialBreakTime, NSEC_PER_SEC)];
        [self.playerView.player play];
        return [[self didPlayToEndTimeNotification] take:1];
    }] subscribeCompleted:^{
        @strongify(self);
        [self close];
    }];
    
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
