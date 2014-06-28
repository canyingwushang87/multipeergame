//
//  FriendsExpandView.m
//  MCDemo
//
//  Created by wendy on 6/28/14.
//  Copyright (c) 2014 baidu. All rights reserved.
//

#import "MGFriendsExpandView.h"

@implementation MGFriendsExpandView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    //判断收起状态下是否点在小按钮上
    if (_isAppear == NO)
    {
        BOOL tmp = CGRectContainsPoint(_backButtonFrame, point);
        return tmp;
    }
    
    if (_isAppear)
    {
        return YES;
    }
    else
    {
        return [super pointInside:point withEvent:event];
    }
    return YES;
}

@end
