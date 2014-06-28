//
//  MGCommonUtility.m
//  MultipeerGame
//
//  Created by gutiefeng on 14-6-28.
//  Copyright (c) 2014年 baidubox. All rights reserved.
//

#import "MGCommonUtility.h"
#import <math.h>

@implementation MGCommonUtility

+ (UIImage *)getImageByHashString:(NSString *)stringToHash
{
    NSUInteger hashValue = [stringToHash hash]%8 + 1;
    UIImage * image = [UIImage imageNamed:[NSString stringWithFormat:@"icon%lu.png", hashValue]];
    return image;
}

+ (NSMutableArray *)getPolyPointsBySizesCount:(CGFloat)sizeCount radius:(CGFloat)radius startAngle:(CGFloat)startAngle offset:(CGPoint)offset
{
    CGFloat centerX = 0.0;
    CGFloat centerY = 0.0;
    CGFloat angle = startAngle;
    CGFloat angleIncrement = 2 * M_PI / sizeCount;
    CGFloat x = 0.0;
    CGFloat y = 0.0;
    
    NSMutableArray *pointsArray = [NSMutableArray array];
    
    for (NSUInteger i=1; i <= sizeCount; i++ )
    {
        x = centerX + radius * cos(angle) + offset.x;
        y = centerY + radius * sin(angle) + offset.y;
        NSLog(@"%lu,%f,%f", i, x, y);
        
        [pointsArray addObject:[NSValue valueWithCGPoint:CGPointMake(x, y)]];
    
        angle = angle + angleIncrement;
    }
    
    return pointsArray;
}


@end
