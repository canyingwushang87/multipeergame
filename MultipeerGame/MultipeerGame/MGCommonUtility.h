//
//  MGCommonUtility.h
//  MultipeerGame
//
//  Created by gutiefeng on 14-6-28.
//  Copyright (c) 2014年 baidubox. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>

@interface MGCommonUtility : NSObject

// 根据用户名哈希获取对应的头像
+ (UIImage *)getImageByHashString:(NSString *)stringToHash;

// 给定边数，外接圆半径，起始角度，计算多边形顶点列表，圆心是0.0
+ (NSMutableArray *)getPolyPointsBySizesCount:(CGFloat)sizeCount radius:(CGFloat)radius startAngle:(CGFloat)startAngle offset:(CGPoint)offset;
@end
