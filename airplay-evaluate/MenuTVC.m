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
@implementation MenuTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.contentInset = UIEdgeInsetsMake(44, 0, 0, 0);
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [UITableViewCell new];
    cell.textLabel.text = indexPath.row == 0 ? @"One player" : @"Two players";
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UIViewController *vc = indexPath.row == 0 ? [OnePlayerVC new] : [TwoPlayersVC new];
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nc animated:YES completion:nil];

}

@end
