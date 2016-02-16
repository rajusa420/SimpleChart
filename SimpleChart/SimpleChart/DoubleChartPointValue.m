//
// Created by Raj Sathi on 7/22/15.
// Copyright (c) 2015 RajSathi. All rights reserved.
//

#import "DoubleChartPointValue.h"


@implementation DoubleChartPointValue
{

}
+ (DoubleChartPointValue*) doubleChartPointValueWithX:(CGFloat) xValue Y: (CGFloat) yValue secondaryX: (CGFloat) secondaryX secondaryY: (CGFloat) secondaryY
{
    DoubleChartPointValue* pointValue = [[DoubleChartPointValue alloc] init];
    pointValue.xValue = xValue;
    pointValue.yValue = yValue;
    pointValue.secondaryXValue = secondaryX;
    pointValue.secondaryYValue = secondaryY;

    return pointValue;
}

@synthesize secondaryXValue = secondaryXValue_;
@synthesize secondaryYValue = secondaryYValue_;

@end