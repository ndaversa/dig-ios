//
//  EmployeeDetailTVC.h
//  dig
//
//  Created by Nino D'Aversa on 12-06-03.
//  Copyright (c) 2012 Nino D'Aversa. All rights reserved.
//

#import "Parse/Parse.h"
#import <UIKit/UIKit.h>

@protocol EmployeeDelegate <NSObject>
@required
- (void) didAddEmployee:(PFObject *)employee;
@end

@interface EmployeeDetailTVC : UITableViewController <UITextFieldDelegate> {
    PFObject *employee;
    id <EmployeeDelegate> __weak delegate;
    
    UISegmentedControl *employeeActive;
    UITextField *employeeName;
    
    UITableViewCell *employeeNameCell;
	UITableViewCell *employeeActiveCell;    
}
@property(nonatomic) PFObject *employee;
@property(nonatomic, weak) id <EmployeeDelegate> delegate;

@property(nonatomic) IBOutlet UISegmentedControl *employeeActive;
@property(nonatomic) IBOutlet UITextField *employeeName;

@property(nonatomic) IBOutlet UITableViewCell *employeeNameCell;
@property(nonatomic) IBOutlet UITableViewCell *employeeActiveCell;    

- (void)save;
- (void)cancel;

@end

