//
//  NSDate+Helpers.h
//  dig
//
//  Created by Nino D'Aversa on 12-06-06.
//  Copyright (c) 2012 Nino D'Aversa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate(Helpers)
+ (NSDate *)dateWithoutTime;
- (NSDate *)dateByAddingDays:(NSInteger)numDays;
- (NSDate *)dateAsDateWithoutTime;
- (NSDate *)dateAsDateWithTimeRoundedToHour;
- (int)differenceInDaysTo:(NSDate *)toDate;
- (NSString *)formattedDateString;
- (NSString *)formattedDateStringTodayOrLater;
- (NSString *)formattedStringUsingFormat:(NSString *)dateFormat;
@end
