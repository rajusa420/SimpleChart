//
// Created by Raj Sathi on 3/14/15.
// Copyright (c) 2015 RajSathi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SimpleChartPointValue.h"

@protocol SimpleChartCurrentValueDelegate
@required
- (CGFloat) getXValueForXPoint: (CGFloat) xPoint;
- (CGFloat) getYValueForYPoint: (CGFloat) yPoint;
- (CGFloat) getXPointForXValue: (CGFloat) xValue;
- (CGFloat) getYPointForYValue: (CGFloat) yValue;
- (CGFloat) getMaxY;
- (CGFloat) getOriginY;
- (SimpleChartPointValue*) getClosestChartValueToXValue: (CGFloat) value;
- (NSString*) getLabelForXValue: (CGFloat) xValue;
- (NSString*) getLabelForYValue: (CGFloat) yValue;
@end

@interface SimpleChartCurrentValueOverlay : UIView
{
@private
    CGFloat xPos_;
    CGFloat yPos_;
    CGFloat xValue_;
    CGFloat yValue_;
    CGFloat secondaryYValue_;
    id<SimpleChartCurrentValueDelegate> delegate_;
}
- (id) initWithFrame: (CGRect) frame delegate: (id<SimpleChartCurrentValueDelegate>) delegate;

@end