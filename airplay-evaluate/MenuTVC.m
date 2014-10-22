//
//  MenuTVC.m
//  airplay-evaluate
//
//  Created by Anders Frank on 2014-10-21.
//  Copyright (c) 2014 Monterosa. All rights reserved.
//

#import "MenuTVC.h"
#import "OnePlayerVC.h"
#import "TwoPlayersVC.h"
#import "OnePlayerVC_noRAC.h"

#import <ReactiveCocoa/ReactiveCocoa.h>

@implementation MenuTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.contentInset = UIEdgeInsetsMake(44, 0, 0, 0);
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [UITableViewCell new];
    NSString *title = nil;
    switch (indexPath.row) {
        case 0:
            title = @"One Player";
            break;
        case 1:
            title = @"Two Players";
            break;
        case 2:
            title = @"One Player - No RAC";
            break;
        default:
            break;
    }
    cell.textLabel.text = title;
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UIViewController *vc = nil;
    
    switch (indexPath.row) {
        case 0:
            vc = [OnePlayerVC new];
            break;
        case 1:
            vc = [TwoPlayersVC new];
            break;
        case 2:
            vc = [OnePlayerVC_noRAC new];
            break;
        default:
            break;
    }
    
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nc animated:YES completion:nil];

}

@end
