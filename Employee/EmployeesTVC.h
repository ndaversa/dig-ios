//
//  EmployeeTVC.h
//  dig
//
//  Created by Nino D'Aversa on 12-06-03.
//  Copyright (c) 2012 Nino D'Aversa. All rights reserved.
//

#import "Parse/Parse.h"
#import "PullRefreshTableViewController.h"
#import "EmployeeDetailTVC.h"
#import <UIKit/UIKit.h>


@interface EmployeesTVC : PullRefreshTableViewController <UITextFieldDelegate, EmployeeDelegate> {
    NSMutableArray *employees;
}

- (void) add:(id)sender;

@end
