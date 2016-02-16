//
// Created by Raj Sathi on 3/15/15.
// Copyright (c) 2015 RajSathi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SimpleChartPointValue : NSObject
{
@protected
    CGFloat xValue_;
    CGFloat yValue_;
}
+ (SimpleChartPointValue*) simpleChartPointValueWithX:(CGFloat) xValue Y: (CGFloat) yValue;
@property (assign) CGFloat xValue;
@property (assign) CGFloat yValue;
@end