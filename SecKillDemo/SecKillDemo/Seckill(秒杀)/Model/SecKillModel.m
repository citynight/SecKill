//
//  SecKillModel.m
//  SecKillDemo
//
//  Created by Mekor on 8/8/16.
//  Copyright © 2016 李小争. All rights reserved.
//

#import "SecKillModel.h"

@implementation SecKillModel


+ (NSDictionary *)objectClassInArray{
    return @{@"datalist" : [Datalist class]};
}
@end


@implementation Datalist

@end


@implementation Detail

+ (NSDictionary *)objectClassInArray{
    return @{@"valid" : [Valid class], @"invalid" : [Invalid class]};
}

@end


@implementation Valid

@end


@implementation Invalid

@end


