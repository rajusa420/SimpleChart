//
// Created by Raj Sathi on 2/21/15.
// Copyright (c) 2015 RajSathi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SimpleChartCurrentValueOverlay.h"
#import "SimpleChartLabelProvider.h"

@interface SimpleChart : UIView<SimpleChartCurrentValueDelegate>
{
@protected
    NSArray* chartPointValues_;

    CGFloat maxXValue_;
    CGFloat minXValue_;

    CGFloat maxYValue_;
    CGFloat minYValue_;

    CGFloat secondaryMaxYValue_;
    CGFloat secondaryMinYValue_;

    CGPoint origin_;
    CGFloat maxX_;
    CGFloat maxY_;

    BOOL drawGrid_;
    BOOL drawLabels_;
    BOOL drawAxises_;
    BOOL drawBackground_;

    NSObject<SimpleChartLabelProvider>* labelProvider_;
}

@property (nonatomic, assign) BOOL drawGrid;
@property (nonatomic, assign) BOOL drawLabels;
@property (nonatomic, assign) BOOL drawAxises;
@property (nonatomic, assign) BOOL drawBackground;

- (void) drawBackground:(CGRect) rect;
- (void) drawAxises:(CGRect) rect;
- (void) drawGrid:(CGRect) rect;
- (CGFloat) getXMargin;
- (CGFloat) getYMargin;
- (CGFloat) getLeftLabelMargin;
- (CGFloat) getBottomLabelMargin;
- (UIColor*) getBackgroundColor;
- (UIColor*) getAxisColor;
- (UIColor*) getGridLineColor;
- (CGFloat) getGridLineWidth;

- (CGFloat) getXPointForXValue:(CGFloat) xValue;
- (CGFloat) getXValueForXPoint:(CGFloat) xPoint;

- (CGFloat) getYPointForYValue:(CGFloat) yValue;
- (CGFloat) getYValueForYPoint:(CGFloat) yPoint;
- (CGFloat) scaleSecondaryValueIntoPrimaryYScale: (CGFloat) secondaryYValue;

- (void) drawPoints:(CGRect) rect;
- (CGFloat) getPointRadius;
- (UIColor*) getGraphLineColor;
- (UIColor*) getGraphPointStrokeColor;
- (UIColor*) getGraphPointFillColor;
- (UIColor*) getSecondaryGraphPointStrokeColor;
- (UIColor*) getSecondaryGraphPointFillColor;
- (UIColor*) getSecondaryGraphLineColor;

- (CGFloat) getNumberOfXGridLines;
- (CGFloat) getNumberOfYGridLines;

- (BOOL) shouldDrawLabels;

- (void) setChartPointValue: (NSArray*) chartPointValues;
- (void) setLabelProvider: (NSObject<SimpleChartLabelProvider>*) labelProvider;
@end