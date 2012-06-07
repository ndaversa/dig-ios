//
//  ScheduleDetailTVC.h
//  dig
//
//  Created by Nino D'Aversa on 12-06-06.
//  Copyright (c) 2012 Nino D'Aversa. All rights reserved.
//

#import "Parse/Parse.h"
#import <UIKit/UIKit.h>
#import "JobsheetsTVC.h"

@protocol ScheduleDelegate <NSObject>
@required
- (void) didAddSchedule:(PFObject *)schedule;
@end

@interface ScheduleDetailTVC : UITableViewController <UITextViewDelegate, UIPopoverControllerDelegate, JobsheetDelegate/*, ScheduleSummaryDelegate*/> {
    PFObject *schedule;
    id <ScheduleDelegate> __weak delegate;
    NSDateFormatter *dateFormatter;
    UIDatePicker *datePicker;
    UIPopoverController *datePopover;
    BOOL showingPicker;
    
    UILabel *scheduleDate;
    UITextView *scheduleNotes;
    UILabel *planDay;
    
    UITableViewCell *scheduleDateCell;
	UITableViewCell *scheduleNotesCell;
	UITableViewCell *planDayCell;  
    UITableViewCell *summaryCell;  
    
}
@property (nonatomic) PFObject *schedule;
@property (nonatomic, weak) id <ScheduleDelegate> delegate;
@property (nonatomic) NSDateFormatter *dateFormatter;

@property (nonatomic) IBOutlet UILabel *scheduleDate;
@property (nonatomic) IBOutlet UITextView *scheduleNotes;
@property (nonatomic) IBOutlet UILabel *planDay;

@property (nonatomic) IBOutlet UITableViewCell *scheduleDateCell;
@property (nonatomic) IBOutlet UITableViewCell *scheduleNotesCell;
@property (nonatomic) IBOutlet UITableViewCell *planDayCell;
@property (nonatomic) IBOutlet UITableViewCell *summaryCell;

- (void)save;
- (void)cancel;

- (void)displayDatePickerFromCell:(UITableViewCell*)cell animated:(BOOL)animated;
- (void)dismissDatePicker:(id)sender;
- (void)createJobsheetsForDate:(NSDate *)date;

@end
