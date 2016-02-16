//
// Created by Raj Sathi on 3/14/15.
// Copyright (c) 2015 RajSathi. All rights reserved.
//

#import "SimpleChartCurrentValueOverlay.h"
#import "CoreGraphicsHelper.h"
#import "DoubleChartPointValue.h"

@implementation SimpleChartCurrentValueOverlay
{

}

- (id) initWithFrame: (CGRect) frame delegate: (id<SimpleChartCurrentValueDelegate>) delegate
{
    if (self = [super initWithFrame: frame])
    {
        self.backgroundColor = [UIColor clearColor];
        delegate_ = delegate;
        xValue_ = -1;
        yValue_ = -1;
    }
    return self;
}

- (void) dealloc
{
}

- (void) drawRect:(CGRect) rect
{
    if (xValue_ != -1 && yValue_ != -1)
    {
        CGFloat xPos = [delegate_ getXPointForXValue: xValue_];
        UIFont* labelFont = [UIFont fontWithName: @"Avenir-Book" size: [UIFont systemFontSize] - 4];

        NSString* xValueStr = [delegate_ getLabelForXValue: xValue_];
        NSDictionary* attrs = [NSDictionary dictionaryWithObjectsAndKeys: labelFont, NSFontAttributeName, nil];
        CGSize xValueLabelSize = [xValueStr sizeWithAttributes: attrs];

        NSString* yValueStr = [delegate_ getLabelForYValue: yValue_];
        CGSize yValueLabelSize = [yValueStr sizeWithAttributes: attrs];

        CGSize secondaryYValueSize = CGSizeZero;
        NSString* secondaryYValueStr = nil;
        if (secondaryYValue_ > 0)
        {
            secondaryYValueStr = [delegate_ getLabelForYValue: secondaryYValue_];
            secondaryYValueSize = [secondaryYValueStr sizeWithAttributes: attrs];
        }

        CGFloat totalHeight = [delegate_ getMaxY] + xValueLabelSize.height + yValueLabelSize.height + secondaryYValueSize.height;
        CGFloat maxWidth = MAX(xValueLabelSize.width, yValueLabelSize.width);
        maxWidth = MAX(maxWidth, secondaryYValueSize.width);
        maxWidth += 8;

        [CoreGraphicsHelper drawLineFrom: CGPointMake(xPos, [delegate_ getOriginY])
                                 toPoint: CGPointMake(xPos, totalHeight)
                                   color: [UIColor blackColor]
                                   width: 1.0
                               antiAlias: NO];

        [CoreGraphicsHelper drawRect: CGRectMake(xPos - (maxWidth / 2.0f), [delegate_ getMaxY], maxWidth, totalHeight - [delegate_ getMaxY]) fillColor: [UIColor whiteColor] strokeColor: [UIColor blackColor]];

        CGFloat yOffset = [delegate_ getMaxY];

        [xValueStr drawInRect: CGRectMake(xPos - (xValueLabelSize.width / 2.0f), yOffset, xValueLabelSize.width, xValueLabelSize.height) withAttributes: attrs];

        yOffset += xValueLabelSize.height;
        [yValueStr drawInRect: CGRectMake(xPos - (yValueLabelSize.width / 2.0f), yOffset, yValueLabelSize.width, yValueLabelSize.height) withAttributes: attrs];

        yOffset += yValueLabelSize.height;
        if (secondaryYValueStr)
            [secondaryYValueStr drawInRect: CGRectMake(xPos - (secondaryYValueSize.width / 2.0f), yOffset, secondaryYValueSize.width, secondaryYValueSize.height) withAttributes: attrs];
    }
}

- (void) handleTouchWithEvent: (UIEvent*) event
{
    self.alpha = 1.0;
    UITouch* touch = [[event allTouches] anyObject];
    CGPoint touchLocation = [touch locationInView: self];

    CGFloat rawXValue = [delegate_ getXValueForXPoint: touchLocation.x];
    SimpleChartPointValue* chartPointValue = [delegate_ getClosestChartValueToXValue: rawXValue];

    xValue_ = chartPointValue.xValue;
    yValue_ = chartPointValue.yValue;
    if ([chartPointValue isKindOfClass: [DoubleChartPointValue class]])
    {
        DoubleChartPointValue* doubleChartPointValue = (DoubleChartPointValue*)chartPointValue;
        secondaryYValue_ = doubleChartPointValue.secondaryYValue;
    }
    else
    {
        secondaryYValue_ = -1;
    }

    [self setNeedsDisplay];
}

- (void) touchesBegan: (NSSet*) touches withEvent: (UIEvent*) event
{
    [super touchesBegan: touches withEvent: event];
    [self handleTouchWithEvent: event];
}

- (void) touchesMoved: (NSSet*) touches withEvent: (UIEvent*) event
{
    [super touchesMoved: touches withEvent: event];
    [self handleTouchWithEvent: event];
}


- (void) touchesEnded: (NSSet*) touches withEvent: (UIEvent*) event
{
    [super touchesEnded: touches withEvent: event];
    [UIView animateWithDuration: 0.25
                          delay: 0.0
                        options: UIViewAnimationOptionAllowUserInteraction
                     animations: ^{ self.alpha = 0.1; }
                     completion: ^(BOOL value)
                     {
                         xValue_ = -1;
                         yValue_ = -1;
                         [self setNeedsDisplay];
                     }];
}

- (void) touchesCancelled: (NSSet*) touches withEvent: (UIEvent*) event
{
    [super touchesCancelled: touches withEvent: event];
    [UIView animateWithDuration: 0.25
                          delay: 0.0
                        options: UIViewAnimationOptionAllowUserInteraction
                     animations: ^{ self.alpha = 0.1; }
                     completion: ^(BOOL value)
                     {
                         xValue_ = -1;
                         yValue_ = -1;
                         [self setNeedsDisplay];
                     }];
}
@end