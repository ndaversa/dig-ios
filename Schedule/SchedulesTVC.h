//
//  SchedulesTVC.h
//  dig
//
//  Created by Nino D'Aversa on 12-06-06.
//  Copyright (c) 2012 Nino D'Aversa. All rights reserved.
//

#import "Parse/Parse.h"
#import "PullRefreshTableViewController.h"
#import "ScheduleDetailTVC.h"

@interface SchedulesTVC : PullRefreshTableViewController <UITextFieldDelegate, ScheduleDelegate, JobsheetDelegate>  {
    NSDateFormatter *dateFormatter;
    NSMutableArray *schedules;
    BOOL reporting;
}

- (id)initForReporting;

@end
