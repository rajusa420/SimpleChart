//
// Created by Raj Sathi on 1/31/15.
// Copyright (c) 2015 RajSathi. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DateHelper : NSObject
+(int) localDaySinceReferenceDate;
+(int) localDaySinceReferenceDateForDate: (NSDate*) date;
+(int) dayFromReferenceDateFromSeconds: (int) seconds;
+ (NSDate*) dateFromlocalDaySinceReferenceDate: (int) day;
@end