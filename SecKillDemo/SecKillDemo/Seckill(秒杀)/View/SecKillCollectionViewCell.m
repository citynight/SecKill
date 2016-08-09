//
//  SecKillCollectionViewCell.m
//  SecKillDemo
//
//  Created by Mekor on 8/8/16.
//  Copyright © 2016 李小争. All rights reserved.
//

#import "SecKillCollectionViewCell.h"
#import "SecKillModel.h"

@interface SecKillCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *state;
@property (weak, nonatomic) IBOutlet UILabel *time;

@end

@implementation SecKillCollectionViewCell
-(void)setDetail:(Datalist *)detail {
    self.state.text = [NSString stringWithFormat:@"状态:%@",detail.time];
    self.time.text = detail.time;
}
@end
