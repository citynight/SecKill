//
//  SecKillModel.h
//  SecKillDemo
//
//  Created by Mekor on 8/8/16.
//  Copyright © 2016 李小争. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Datalist,Detail,Valid,Invalid;
@interface SecKillModel : NSObject

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong) NSArray<Datalist *> *datalist;

@property (nonatomic, assign) NSInteger code;

@end

@interface Datalist : NSObject

@property (nonatomic, strong) Detail *detail;

@property (nonatomic, copy) NSString *time;

@end

@interface Detail : NSObject

@property (nonatomic, strong) NSArray<Valid *> *valid;

@property (nonatomic, strong) NSArray<Invalid *> *invalid;

@end

@interface Valid : NSObject

@property (nonatomic, assign) NSInteger welcome_index;

@property (nonatomic, copy) NSString *shopname;

@property (nonatomic, copy) NSString *juli;

@property (nonatomic, assign) NSInteger wz_auth;

@property (nonatomic, copy) NSString *productname;

@property (nonatomic, copy) NSString *shopid;

@property (nonatomic, strong) NSArray<NSString *> *productimgs;

@property (nonatomic, copy) NSString *price;

@property (nonatomic, copy) NSString *productnum;

@property (nonatomic, copy) NSString *salenum;

@property (nonatomic, strong) NSArray<NSString *> *detail_pics;

@property (nonatomic, copy) NSString *telphone;

@property (nonatomic, copy) NSString *spikeprice;

@property (nonatomic, copy) NSString *likenum;

@property (nonatomic, copy) NSString *spikestock;

@property (nonatomic, assign) NSInteger wz_redpaper;

@property (nonatomic, copy) NSString *productid;

@end

@interface Invalid : NSObject

@property (nonatomic, assign) NSInteger welcome_index;

@property (nonatomic, copy) NSString *shopname;

@property (nonatomic, copy) NSString *juli;

@property (nonatomic, assign) NSInteger wz_auth;

@property (nonatomic, copy) NSString *productname;

@property (nonatomic, copy) NSString *shopid;

@property (nonatomic, strong) NSArray<NSString *> *productimgs;

@property (nonatomic, copy) NSString *price;

@property (nonatomic, copy) NSString *productnum;

@property (nonatomic, copy) NSString *salenum;

@property (nonatomic, strong) NSArray<NSString *> *detail_pics;

@property (nonatomic, copy) NSString *telphone;

@property (nonatomic, copy) NSString *spikeprice;

@property (nonatomic, copy) NSString *likenum;

@property (nonatomic, copy) NSString *spikestock;

@property (nonatomic, assign) NSInteger wz_redpaper;

@property (nonatomic, copy) NSString *productid;

@end

