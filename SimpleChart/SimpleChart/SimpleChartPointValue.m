//
// Created by Raj Sathi on 3/15/15.
// Copyright (c) 2015 RajSathi. All rights reserved.
//

#import "SimpleChartPointValue.h"

@implementation SimpleChartPointValue
+ (SimpleChartPointValue*) simpleChartPointValueWithX:(CGFloat) xValue Y: (CGFloat) yValue
{
    SimpleChartPointValue* pointValue = [[SimpleChartPointValue alloc] init];
    pointValue.xValue = xValue;
    pointValue.yValue = yValue;

    return pointValue;
}
@synthesize xValue = xValue_;
@synthesize yValue = yValue_;
@end
