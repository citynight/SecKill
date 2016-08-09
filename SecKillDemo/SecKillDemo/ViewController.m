//
//  ViewController.m
//  SecKillDemo
//
//  Created by Mekor on 8/8/16.
//  Copyright © 2016 李小争. All rights reserved.
//

#import "ViewController.h"
#import "XZSecKillViewController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)secKill {
    [self.navigationController pushViewController:[XZSecKillViewController new] animated:YES];
}

@end
