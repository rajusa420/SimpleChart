//
// Created by Raj Sathi on 1/31/15.
// Copyright (c) 2015 RajSathi. All rights reserved.
//

#import "DateHelper.h"


@implementation DateHelper
{

}

+(int) localDaySinceReferenceDate
{
    return [self localDaySinceReferenceDateForDate: [NSDate date]];
}

+(int) localDaySinceReferenceDateForDate: (NSDate*) date
{
    return [self dayFromReferenceDateFromSeconds: [date timeIntervalSinceReferenceDate] + [[NSTimeZone localTimeZone] secondsFromGMT]];
}

+(int) dayFromReferenceDateFromSeconds: (int) seconds
{
    int secondsPerDay = 24 * 60 * 60;
    int days = (seconds/secondsPerDay) + MIN(1, seconds % secondsPerDay);
    return days;
}

+ (NSDate*) dateFromlocalDaySinceReferenceDate: (int) day
{
    double totalSecondsSinceDate = (double)day * 24.0 * 60.0 * 60.0;
    totalSecondsSinceDate -= [[NSTimeZone localTimeZone] secondsFromGMT];
    totalSecondsSinceDate -= 1;

    NSDate* date = [NSDate dateWithTimeIntervalSinceReferenceDate: totalSecondsSinceDate];
    NSTimeInterval DSToffset = [[NSTimeZone localTimeZone] daylightSavingTimeOffsetForDate: date];
    return [date dateByAddingTimeInterval: -DSToffset];
}
@end