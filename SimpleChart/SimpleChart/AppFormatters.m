//
// Created by Raj Sathi on 8/6/15.
// Copyright (c) 2015 RajSathi. All rights reserved.
//

#import "AppFormatters.h"

@implementation AppFormatters

static NSNumberFormatter* numberWithDecimalFormatter;
static NSDateFormatter* timeFormatter;

+ (NSNumberFormatter*) numberWithDecimalFormatter
{
    if (numberWithDecimalFormatter == nil )
    {
        numberWithDecimalFormatter = [[NSNumberFormatter alloc] init];
        [numberWithDecimalFormatter setLocale: [NSLocale currentLocale]];
        [numberWithDecimalFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
        [numberWithDecimalFormatter setMaximumFractionDigits:1];
    }

    return numberWithDecimalFormatter;
}

+ (NSDateFormatter*) timeFormatter
{
    if (timeFormatter == nil)
    {
        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setLocale: [NSLocale currentLocale]];
        [dateFormatter setDateFormat: @"HH:mm:ss"];
        return dateFormatter;
    }

    return timeFormatter;
}

@end