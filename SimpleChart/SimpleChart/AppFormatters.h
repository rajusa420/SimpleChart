//
// Created by Raj Sathi on 8/6/15.
// Copyright (c) 2015 RajSathi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppFormatters : NSObject
+ (NSNumberFormatter*) numberWithDecimalFormatter;
+ (NSDateFormatter*) timeFormatter;
@end