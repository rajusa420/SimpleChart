//
// Created by Raj Sathi on 2/22/15.
// Copyright (c) 2015 RajSathi. All rights reserved.
//

#import "SimpleBarChart.h"
#import "CoreGraphicsHelper.h"
#import "DoubleChartPointValue.h"

@implementation SimpleBarChart
{

}

- (void) drawPoints: (CGRect) rect
{
    CGFloat widthPerBar = (maxX_ - origin_.x) / MAX([chartPointValues_ count], 1);

    for (SimpleChartPointValue* pointValue in chartPointValues_)
    {
        CGFloat scaledSecondaryYValue = 0;
        CGFloat secondaryXValue = 0;
        CGFloat secondaryYValue = 0;
        CGFloat primaryWidthPerBar = widthPerBar;

        if ([pointValue isKindOfClass: [DoubleChartPointValue class]])
        {
            DoubleChartPointValue* doubleChartPointValue = (DoubleChartPointValue*)pointValue;
            secondaryXValue = doubleChartPointValue.secondaryXValue;
            secondaryYValue = doubleChartPointValue.secondaryYValue;
            scaledSecondaryYValue = [self scaleSecondaryValueIntoPrimaryYScale: secondaryYValue];
            primaryWidthPerBar = widthPerBar / 2;
        }

        [self drawBarHelper: pointValue.xValue yValue: pointValue.yValue xOffset: 0 widthPerBar: primaryWidthPerBar fillColor: [self getGraphLineColor] strokeColor:  [self getBarStrokeColor]];

        if (scaledSecondaryYValue > 0)
        {
            [self drawBarHelper:  secondaryXValue yValue: scaledSecondaryYValue xOffset: primaryWidthPerBar widthPerBar: primaryWidthPerBar fillColor: [self getSecondaryGraphLineColor] strokeColor: [self getBarSecondaryStrokeColor]];
        }
    }
}

- (void) drawBarHelper: (CGFloat) xValue yValue: (CGFloat) yValue xOffset: (CGFloat) xOffset widthPerBar: (CGFloat) widthPerBar fillColor: (UIColor*) fillColor strokeColor: (UIColor*) strokeColor
{
    CGPoint realPoint = CGPointMake([self getXPointForXValue: xValue] + xOffset, [self getYPointForYValue: yValue]);
    CGRect barRect = CGRectMake(realPoint.x - (widthPerBar / 2), realPoint.y, widthPerBar - 1, origin_.y - realPoint.y);

    [self drawBarHelper: barRect fillColor: fillColor strokeColor: strokeColor];
}

- (void) drawBarHelper: (CGRect) barRect fillColor: (UIColor*) fillColor strokeColor: (UIColor*) strokeColor
{
    [CoreGraphicsHelper drawRect: barRect fillColor: fillColor strokeColor: strokeColor];
}

- (CGFloat) getXPointForXValue: (CGFloat) xValue
{
    CGFloat widthPerBar = (maxX_ - origin_.x) / MAX([chartPointValues_ count], 1);
    CGFloat pointsPerXValue = (maxX_ - origin_.x) / MAX((maxXValue_ - minXValue_), 1);
    CGFloat valueOffset = xValue - minXValue_;
    return origin_.x + valueOffset * pointsPerXValue + (widthPerBar / 2.0f);
}

- (CGFloat) getXValueForXPoint: (CGFloat) xPoint
{
    CGFloat widthPerBar = (maxX_ - origin_.x) / MAX([chartPointValues_ count], 1);
    CGFloat pointsPerXValue = (maxX_ - origin_.x - (widthPerBar / 2.0f)) / MAX((maxXValue_ - minXValue_), 1);
    CGFloat valueOffset = (xPoint - origin_.x) / pointsPerXValue;
    return valueOffset + minXValue_;
}

- (CGFloat) getNumberOfXGridLines
{
    if ([chartPointValues_ count] > 0)
    {
        SimpleChartPointValue *pointValue = [chartPointValues_ objectAtIndex: 0];
        if ([pointValue isKindOfClass: [DoubleChartPointValue class]])
        {
            return (maxX_ - origin_.x) / MAX(([chartPointValues_ count] * 2), 1);
        }
    }
    
    return (maxX_ - origin_.x) / (2 * MAX([chartPointValues_ count], 1));
}

- (UIColor*) getBarStrokeColor
{
    return [UIColor blackColor];
}

- (UIColor*) getBarSecondaryStrokeColor
{
    return [UIColor blackColor];
}

- (UIColor*) getSecondaryGraphLineColor
{
    return [UIColor redColor];
}
@end