//
// Created by Raj Sathi on 2/21/15.
// Copyright (c) 2015 RajSathi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol SimpleChartLabelProvider
@optional
- (NSString*) labelForXValue: (CGFloat) xValue;
- (NSString*) labelForYValue: (CGFloat) yValue;
@end