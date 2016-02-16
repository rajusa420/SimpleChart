//
// Created by Raj Sathi on 2/21/15.
// Copyright (c) 2015 RajSathi. All rights reserved.
//

#import "CoreGraphicsHelper.h"


@implementation CoreGraphicsHelper
{

}

+(void) drawRect: (CGRect) rect fillColor: (UIColor*) fillColor strokeColor: (UIColor*) strokeColor
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGContextSetFillColorWithColor(context, fillColor.CGColor);
    CGContextSetStrokeColorWithColor(context, strokeColor.CGColor);
    CGContextFillRect(context, rect);
    CGContextStrokeRect(context, rect);
    CGContextRestoreGState(context);
}

+(void) drawLineFrom: (CGPoint) fromPoint toPoint: (CGPoint) toPoint color: (UIColor*) color width: (CGFloat) width antiAlias: (BOOL) antiAlias
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    fromPoint = [self ensurePixelAlignment: fromPoint context: context];
    toPoint = [self ensurePixelAlignment: toPoint context: context];

    CGContextSetShouldAntialias(context, antiAlias);
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineWidth(context, width);
    CGContextSetStrokeColorWithColor(context, color.CGColor);

    CGContextBeginPath(context);
    CGContextMoveToPoint(context, fromPoint.x, fromPoint.y);
    CGContextAddLineToPoint(context, toPoint.x, toPoint.y);
    CGContextStrokePath(context);

    CGContextRestoreGState(context);
}

+(void) drawArc: (CGFloat) radius atPoint: (CGPoint) point startAngle: (CGFloat) startAngle endAngle: (CGFloat) endAngle strokeColor: (UIColor*) strokeColor fillColor: (UIColor*) fillColor lineWidth: (CGFloat) lineWidth
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);

    CGContextSetStrokeColorWithColor(context, strokeColor.CGColor);
    CGContextSetFillColorWithColor(context, fillColor.CGColor);
    point = [self ensurePixelAlignment: point context: context];

    UIBezierPath* path = [UIBezierPath bezierPathWithArcCenter: point radius: radius startAngle: startAngle endAngle: endAngle clockwise: YES];
    path.lineWidth = lineWidth;

    [path stroke];
    [path fill];

    CGContextRestoreGState(context);
}

+ (CGPoint) ensurePixelAlignment: (CGPoint) point context: (CGContextRef) context
{
    CGPoint alignedPoint = CGContextConvertPointToDeviceSpace(context, point);
    alignedPoint.x = (CGFloat)floor(alignedPoint.x);
    alignedPoint.y = (CGFloat)floor(alignedPoint.y);
    alignedPoint = CGContextConvertPointToUserSpace(context, alignedPoint);

    return alignedPoint;
}
@end