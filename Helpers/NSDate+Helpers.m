//
//  NSDate+Helpers.m
//  dig
//
//  Created by Nino D'Aversa on 12-06-06.
//  Copyright (c) 2012 Nino D'Aversa. All rights reserved.
//

#import "NSDate+Helpers.h"

@implementation NSDate(Helpers)
+ (NSDate *)dateWithoutTime
{
    return [[NSDate date] dateAsDateWithoutTime];
}
-(NSDate *)dateByAddingDays:(NSInteger)numDays
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setDay:numDays];
    
    NSDate *date = [gregorian dateByAddingComponents:comps toDate:self options:0];
    return date;
}
- (NSDate *)dateAsDateWithoutTime
{
    NSString *formattedString = [self formattedDateString];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"EEEE MMMM dd, yyyy"];
    NSDate *ret = [formatter dateFromString:formattedString];
    return ret;
}

- (NSDate *)dateAsDateWithTimeRoundedToHour{
	NSString *formattedString = [self formattedStringUsingFormat:@"EEEE MMMM dd, yyyy h a"];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"EEEE MMMM dd, yyyy h a"];
    NSDate *ret = [formatter dateFromString:formattedString];
    return ret;
}

- (int)differenceInDaysTo:(NSDate *)toDate
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDateComponents *components = [gregorian components:NSDayCalendarUnit
                                                fromDate:self
                                                  toDate:toDate
                                                 options:0];
    NSInteger days = [components day];
    return days;
}
- (NSString *)formattedDateString
{
    
    return [self formattedStringUsingFormat:@"EEEE MMMM dd, yyyy"];
}

- (NSString *)formattedDateStringTodayOrLater
{
	NSTimeInterval dt = [self timeIntervalSinceNow];
	if (dt < 0) //self is before now
		return [[NSDate dateWithoutTime] formattedStringUsingFormat:@"EEEE MMMM dd, yyyy"];
    return [self formattedStringUsingFormat:@"EEEE MMMM dd, yyyy"];
}

- (NSString *)formattedStringUsingFormat:(NSString *)dateFormat
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:dateFormat];
    NSString *ret = [formatter stringFromDate:self];
    return ret;
}
@end
