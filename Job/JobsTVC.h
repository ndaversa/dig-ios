//
//  JobsTVC.h
//  dig
//
//  Created by Nino D'Aversa on 12-06-04.
//  Copyright (c) 2012 Nino D'Aversa. All rights reserved.
//

#import "PullRefreshTableViewController.h"
#import "Parse/Parse.h"
#import "JobDetailTVC.h"

@interface JobsTVC : PullRefreshTableViewController <UITextFieldDelegate, JobDelegate> {
    NSMutableArray *jobs;
}
@end
