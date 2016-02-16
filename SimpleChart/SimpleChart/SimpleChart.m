//
// Created by Raj Sathi on 2/21/15.
// Copyright (c) 2015 RajSathi. All rights reserved.
//

#import "SimpleChart.h"
#import "CoreGraphicsHelper.h"
#import "DoubleChartPointValue.h"
#import "AppFormatters.h"
#import "SimpleChartLabelProvider.h"

@implementation SimpleChart
{

}

@synthesize drawLabels = drawLabels_;
@synthesize drawGrid = drawGrid_;
@synthesize drawAxises = drawAxises_;
@synthesize drawBackground = drawBackground_;

- (id) initWithFrame:(CGRect) frame
{
    if (self = [super initWithFrame: frame])
    {
        [self commonInit: frame];
    }

    return self;
}

#define OVERLAY_TAG 2000
- (void) commonInit: (CGRect) frame
{
    self.backgroundColor = [UIColor clearColor];
    self.drawLabels = YES;
    self.drawGrid = YES;
    self.drawAxises = YES;
    self.drawBackground = YES;

    SimpleChartCurrentValueOverlay* overlay = [[SimpleChartCurrentValueOverlay alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height) delegate:self];
    overlay.tag = OVERLAY_TAG;
    [self addSubview: overlay];
}

- (SimpleChartCurrentValueOverlay*) overlayView
{
    return (SimpleChartCurrentValueOverlay*)[self viewWithTag: OVERLAY_TAG];
}

- (void) layoutSubviews
{
    [super layoutSubviews];
}

- (void) drawRect:(CGRect) rect
{
    [self setOrigin: rect];
    maxX_ = rect.origin.x + rect.size.width - [self getXMargin];
    maxY_ = rect.origin.y + [self getYMargin];
    [self drawBackground: rect];

    [self drawGrid: rect];

    if (chartPointValues_ && [chartPointValues_ count] > 0)
        [self drawPoints: rect];

    if (self.drawAxises)
        [self drawAxises: rect];
}

- (void) setOrigin:(CGRect) rect
{
    origin_ = CGPointMake(rect.origin.x + [self getXMargin] + [self getLeftLabelMargin], rect.origin.y + rect.size.height - 1 - (2 * [self getYMargin]) - [self getBottomLabelMargin]);
}

- (void) drawBackground: (CGRect) rect
{
    [CoreGraphicsHelper drawRect: rect fillColor: [self getBackgroundColor] strokeColor: [self getBackgroundColor]];
}

- (void) drawAxises:(CGRect) rect
{
    CGPoint xAxisTop = CGPointMake(origin_.x, maxY_);
    CGPoint yAxisRight = CGPointMake(maxX_, origin_.y);

    [CoreGraphicsHelper drawLineFrom: origin_ toPoint: xAxisTop color: [self getAxisColor] width: [self getGridLineWidth] antiAlias: NO];
    [CoreGraphicsHelper drawLineFrom: origin_ toPoint: yAxisRight color: [self getAxisColor] width: [self getGridLineWidth] antiAlias: NO];
}

- (void) drawGrid: (CGRect) rect
{
    CGFloat numberOfGridXLines = [self getNumberOfXGridLines];
    if (numberOfGridXLines > 0)
    {
        CGFloat xRange = maxX_ - origin_.x;
        CGFloat extraXSpace = fmodf(xRange, numberOfGridXLines);
        CGFloat gridXOffset = floorf((xRange - extraXSpace) / numberOfGridXLines);

        for (CGFloat gridXPos = origin_.x + gridXOffset; gridXPos <= maxX_; gridXPos += gridXOffset)
        {
            if (self.drawGrid)
                [CoreGraphicsHelper drawLineFrom: CGPointMake(gridXPos, origin_.y) toPoint: CGPointMake(gridXPos, maxY_) color: [self getGridLineColor] width: [self getGridLineWidth] antiAlias: NO];

            if ([self shouldDrawLabels])
            {
                [[UIColor blackColor] set];
                CGFloat xValue = [self getXValueForXPoint: gridXPos];
                xValue = roundf(xValue);

                NSString* xLabel = [self getLabelForXValue: xValue];
                UIFont* labelFont = [UIFont fontWithName: @"Avenir-Book" size: [UIFont systemFontSize] - 4];
                NSDictionary* attrs = [NSDictionary dictionaryWithObjectsAndKeys: labelFont, NSFontAttributeName, nil];
                CGSize labelSize = [xLabel sizeWithAttributes: attrs];

                CGFloat labelMargin = [self getBottomLabelMargin];

                [xLabel drawAtPoint:CGPointMake(gridXPos - (labelSize.width / 2), origin_.y + (labelMargin > 0 ? labelMargin / 2 : -25)) withAttributes: attrs];
            }
        }
    }

    CGFloat numberOfYGridLines = [self getNumberOfYGridLines];
    if (numberOfYGridLines > 0)
    {
        CGFloat yRange = origin_.y - maxY_;
        CGFloat extraYSpace = fmodf(yRange, numberOfYGridLines);
        CGFloat gridYOffset = (yRange - extraYSpace) / numberOfYGridLines;

        for (CGFloat gridYPos = origin_.y - gridYOffset; gridYPos >= maxY_; gridYPos -= gridYOffset)
        {
            if (self.drawGrid)
                [CoreGraphicsHelper drawLineFrom:CGPointMake(origin_.x, gridYPos) toPoint:CGPointMake(maxX_, gridYPos) color: [self getGridLineColor] width: [self getGridLineWidth] antiAlias: NO];

            if ([self shouldDrawLabels])
            {
                [[UIColor blackColor] set];
                CGFloat yValue = [self getYValueForYPoint: gridYPos];
                yValue = roundf(yValue);

                NSString* yLabel = [self getLabelForYValue: yValue];
                UIFont* labelFont = [UIFont fontWithName: @"Avenir-Book" size: [UIFont systemFontSize]];
                NSDictionary* attrs = [NSDictionary dictionaryWithObjectsAndKeys: labelFont, NSFontAttributeName, nil];
                CGSize labelSize = [yLabel sizeWithAttributes: attrs];
                CGFloat labelMargin = [self getLeftLabelMargin];

                [yLabel drawAtPoint:CGPointMake(origin_.x - (labelMargin > 0 ? labelSize.width : - labelSize.width) - 5, gridYPos - (labelSize.height / 2)) withAttributes: attrs];
            }
        }
    }
}

- (NSString*) getLabelForXValue: (CGFloat) xValue
{
    NSString* xLabel;
    if (labelProvider_ && [labelProvider_ respondsToSelector: @selector(labelForXValue:)])
        xLabel = [labelProvider_ labelForXValue: xValue];
    else
        xLabel = [[AppFormatters numberWithDecimalFormatter] stringFromNumber: [NSNumber numberWithFloat: xValue]];

    return xLabel;
}

- (NSString*) getLabelForYValue: (CGFloat) yValue
{
    NSString* yLabel;
    if (labelProvider_ && [labelProvider_ respondsToSelector: @selector(labelForYValue:)])
        yLabel = [labelProvider_ labelForYValue: yValue];
    else
        yLabel = [[AppFormatters numberWithDecimalFormatter] stringFromNumber: [NSNumber numberWithFloat: yValue]];

    return yLabel;
}

- (CGFloat) getXMargin
{
    return 10.0;
}

- (CGFloat) getYMargin
{
    return 10.0;
}

- (CGFloat) getLeftLabelMargin
{
    return 25.0;
}

- (CGFloat) getBottomLabelMargin
{
    return 15.0;
}

- (UIColor*) getBackgroundColor
{
    return [UIColor colorWithRed: 1.0 green: 1.0 blue: 1.0 alpha:1];
}

- (UIColor*) getAxisColor
{
    return [UIColor blackColor];
}

- (UIColor*) getGridLineColor
{
    return [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha: 0.1];
}

- (CGFloat) getGridLineWidth
{
    return 2.0;
}

- (CGFloat) getXPointForXValue: (CGFloat) xValue
{
    CGFloat pointsPerXValue = (maxX_ - origin_.x) / MAX((maxXValue_ - minXValue_), 1);
    CGFloat valueOffset = xValue - minXValue_;
    return origin_.x + valueOffset * pointsPerXValue;
}

- (CGFloat) getXValueForXPoint: (CGFloat) xPoint
{
    CGFloat pointsPerXValue = (maxX_ - origin_.x) / MAX((maxXValue_ - minXValue_), 1);
    CGFloat valueOffset = (xPoint - origin_.x) / pointsPerXValue;
    return valueOffset + minXValue_;
}

- (CGFloat) getYPointForYValue: (CGFloat) yValue
{
    CGFloat pointsPerYValue = (origin_.y - maxY_) / MAX((maxYValue_ - minYValue_), 1);
    CGFloat valueOffset = yValue - minYValue_;
    return origin_.y - valueOffset * pointsPerYValue;
}

- (CGFloat) getYValueForYPoint: (CGFloat) yPoint
{
    CGFloat pointsPerYValue = (origin_.y - maxY_) / MAX((maxYValue_ - minYValue_), 1);
    CGFloat valueOffset = (origin_.y - yPoint) / pointsPerYValue;
    return valueOffset + minYValue_;
}

- (CGFloat) scaleSecondaryValueIntoPrimaryYScale: (CGFloat) secondaryYValue
{
    CGFloat secondaryValuesPerPrimaryValue = (maxYValue_ - minYValue_) / MAX(secondaryMaxYValue_ - secondaryMinYValue_, 1);
    CGFloat secondaryValueOffset = secondaryYValue - secondaryMinYValue_;
    return minYValue_ + secondaryValueOffset * secondaryValuesPerPrimaryValue;
}

- (SimpleChartPointValue*) getClosestChartValueToXValue: (CGFloat) value
{
    SimpleChartPointValue* prevValue = nil;
    for (SimpleChartPointValue*  pointValue in chartPointValues_)
    {
        if (pointValue.xValue > value)
        {
            if (ABS(pointValue.xValue - value) > ABS(value - prevValue.xValue))
                return prevValue;

            return pointValue;
        }

        prevValue = pointValue;
    }

    return nil;
}

- (void) drawPoints: (CGRect) rect
{
    CGPoint lastPoint = CGPointMake(-1, -1);
    CGPoint secondaryLastPoint = CGPointMake(-1, -1);
    CGFloat pointRadius = [self getPointRadius];

    for (SimpleChartPointValue*  pointValue in chartPointValues_)
    {
        CGPoint realPoint = CGPointMake([self getXPointForXValue: pointValue.xValue], [self getYPointForYValue: pointValue.yValue]);

        if (lastPoint.x != -1 && lastPoint.y != -1)
        {
            [CoreGraphicsHelper drawLineFrom: lastPoint toPoint: realPoint color: [self getGraphLineColor] width: [self getGridLineWidth] antiAlias: YES];

            if (pointRadius > 0)
                [CoreGraphicsHelper drawArc: 3.0 atPoint: lastPoint startAngle: 0 endAngle: 360 strokeColor: [self getGraphPointStrokeColor] fillColor: [self getGraphPointFillColor] lineWidth: [self getPointLineWidth]];
        }

        lastPoint = realPoint;

        if ([pointValue isKindOfClass: [DoubleChartPointValue class]])
        {
            DoubleChartPointValue* doubleValue = (DoubleChartPointValue*)pointValue;
            CGFloat scaledSecondaryValue = [self scaleSecondaryValueIntoPrimaryYScale:doubleValue.secondaryYValue];

            CGPoint secondaryRealPoint = CGPointMake([self getXPointForXValue: doubleValue.secondaryXValue], [self getYPointForYValue: scaledSecondaryValue]);

            if (secondaryLastPoint.x != -1 && secondaryLastPoint.y != -1)
            {
                [CoreGraphicsHelper drawLineFrom: secondaryLastPoint toPoint: secondaryRealPoint color: [self getSecondaryGraphLineColor] width: [self getGridLineWidth] antiAlias: YES];

                if (pointRadius > 0)
                    [CoreGraphicsHelper drawArc: 3.0 atPoint: secondaryLastPoint startAngle: 0 endAngle: 360 strokeColor: [self getSecondaryGraphPointStrokeColor] fillColor: [self getSecondaryGraphPointFillColor] lineWidth: [self getPointLineWidth]];
            }

            secondaryLastPoint = secondaryRealPoint;
        }
    }

    if (pointRadius > 0 && lastPoint.x != -1 && lastPoint.y != -1)
        [CoreGraphicsHelper drawArc: 3.0 atPoint: lastPoint startAngle: 0 endAngle: 360 strokeColor: [self getGraphPointStrokeColor] fillColor: [self getGraphPointFillColor] lineWidth: [self getPointLineWidth]];

    if (pointRadius > 0 && secondaryLastPoint.x != -1 && secondaryLastPoint.y != -1)
        [CoreGraphicsHelper drawArc: 3.0 atPoint: secondaryLastPoint startAngle: 0 endAngle: 360 strokeColor: [self getSecondaryGraphPointStrokeColor] fillColor: [self getSecondaryGraphPointFillColor] lineWidth: [self getPointLineWidth]];

}

- (CGFloat) getPointRadius
{
    return 2.0;
}

- (CGFloat) getPointLineWidth
{
    return 2.0f;
}

- (UIColor*) getGraphLineColor
{
    return [UIColor colorWithRed:0.16f green:0.57 blue: 0.75 alpha: 1.0];
}

- (UIColor*) getSecondaryGraphLineColor
{
    return [UIColor redColor];
}

- (UIColor*) getGraphPointStrokeColor
{
    return [UIColor colorWithRed:0.16f green:0.57 blue: 0.75 alpha: 1.0];
}

- (UIColor*) getGraphPointFillColor
{
    return [UIColor whiteColor];
}

- (UIColor*) getSecondaryGraphPointStrokeColor
{
    return [UIColor redColor];
}

- (UIColor*) getSecondaryGraphPointFillColor
{
    return [UIColor whiteColor];
}

- (CGFloat) getNumberOfXGridLines
{
    return 8.0;
}

- (CGFloat) getNumberOfYGridLines
{
    return 8.0;
}

- (BOOL) shouldDrawLabels
{
    if (chartPointValues_ && [chartPointValues_ count] > 0)
    {
        return self.drawLabels;
    }

    return NO;
}

- (CGFloat) xValuePaddingPercentage
{
    return 0.1f;
}

- (CGFloat) yValuePaddingPercentage
{
    return 0.3f;
}

- (BOOL) forceZeroXOrigin
{
    return NO;
}

- (BOOL) forceZeroYOrigin
{
    return YES;
}

-(void) setChartPointValue: (NSArray*) chartPointValues
{
    chartPointValues_ = chartPointValues;

    maxXValue_ = 0;
    minXValue_ = [self forceZeroXOrigin] ? 0 : MAXFLOAT;
    maxYValue_ = 0;
    minYValue_ = [self forceZeroYOrigin] ? 0 : MAXFLOAT;

    for (SimpleChartPointValue*  pointValue in chartPointValues)
    {
        if (pointValue.xValue > maxXValue_)
            maxXValue_ = pointValue.xValue;

        if (pointValue.xValue < minXValue_)
            minXValue_ = pointValue.xValue;

        if (pointValue.yValue > maxYValue_)
            maxYValue_ = pointValue.yValue;

        if (pointValue.yValue < minYValue_)
            minYValue_ = pointValue.yValue;

        if ([pointValue isKindOfClass: [DoubleChartPointValue class]])
        {
            DoubleChartPointValue* doubleValue = (DoubleChartPointValue*)pointValue;
            if (doubleValue.secondaryXValue > maxXValue_)
                maxXValue_ = doubleValue.secondaryXValue;

            if (doubleValue.secondaryXValue < minXValue_)
                minXValue_ = doubleValue.secondaryXValue;

            if (doubleValue.secondaryYValue > secondaryMaxYValue_)
                secondaryMaxYValue_ = doubleValue.secondaryYValue;

            if (doubleValue.secondaryYValue < secondaryMinYValue_)
                secondaryMinYValue_ = doubleValue.secondaryYValue;
        }
    }

    maxXValue_ += ((maxXValue_ - minXValue_)* [self xValuePaddingPercentage]);
    maxYValue_ += ((maxYValue_ - minYValue_) * [self yValuePaddingPercentage]);

    // TODO: Make the axis have nice round numbers
    /*if ([self getNumberOfXGridLines] > 0)
    {
        CGFloat extraXPadding = fmodf(maxXValue_ - minXValue_, [self getNumberOfXGridLines]);
        maxXValue_ = ceilf(extraXPadding + maxXValue_);
    }

    if ([self getNumberOfYGridLines] > 0)
    {
        CGFloat extraYPadding = fmodf(maxYValue_ - minYValue_, [self getNumberOfYGridLines]);
        maxYValue_ = ceilf(extraYPadding + maxYValue_);
    }*/
}

- (CGFloat) getMaxY
{
    return maxY_;
}
- (CGFloat) getOriginY
{
    return origin_.y;
}

- (void) setLabelProvider: (NSObject<SimpleChartLabelProvider>*) labelProvider
{
    labelProvider_ = labelProvider;
}

@end