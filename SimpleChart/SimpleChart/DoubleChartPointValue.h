//
// Created by Raj Sathi on 7/22/15.
// Copyright (c) 2015 RajSathi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SimpleChartPointValue.h"


@interface DoubleChartPointValue : SimpleChartPointValue
{
@protected
    CGFloat secondaryXValue_;
    CGFloat secondaryYValue_;
}

+ (DoubleChartPointValue*) doubleChartPointValueWithX:(CGFloat) xValue Y: (CGFloat) yValue secondaryX: (CGFloat) secondaryX secondaryY: (CGFloat) secondaryY;

@property (assign) CGFloat secondaryXValue;
@property (assign) CGFloat secondaryYValue;
@end