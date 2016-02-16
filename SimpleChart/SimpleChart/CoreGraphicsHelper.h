//
// Created by Raj Sathi on 2/21/15.
// Copyright (c) 2015 RajSathi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CoreGraphicsHelper : NSObject
+(void) drawRect: (CGRect) rect fillColor: (UIColor*) fillColor strokeColor: (UIColor*) strokeColor;
+(void) drawLineFrom: (CGPoint) fromPoint toPoint: (CGPoint) toPoint color: (UIColor*) color width: (CGFloat) width antiAlias: (BOOL) antiAlias;
+(void) drawArc: (CGFloat) radius atPoint: (CGPoint) point startAngle: (CGFloat) startAngle endAngle: (CGFloat) endAngle strokeColor: (UIColor*) strokeColor fillColor: (UIColor*) fillColor lineWidth: (CGFloat) lineWidth;
@end