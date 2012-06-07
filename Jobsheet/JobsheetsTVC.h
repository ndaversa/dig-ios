//
//  JobsheetsTVC.h
//  dig
//
//  Created by Nino D'Aversa on 12-06-06.
//  Copyright (c) 2012 Nino D'Aversa. All rights reserved.
//

#import "Parse/Parse.h"
#import "PullRefreshTableViewController.h"

@protocol JobsheetDelegate <NSObject>
@required
- (void) didSelectJobsheet;
@end


@interface JobsheetsTVC : PullRefreshTableViewController {
    id<JobsheetDelegate> __weak delegate;
    NSDate *date;
    NSMutableArray *jobsheets;
    BOOL reporting;
}

- (id)initForReporting;

@property (nonatomic, weak) id <JobsheetDelegate> delegate;
@property (nonatomic) NSDate *date;

- (void) doneButtonTapped:(id) sender;

@end
