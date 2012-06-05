//
//  JobDetailTVC.h
//  dig
//
//  Created by Nino D'Aversa on 12-06-04.
//  Copyright (c) 2012 Nino D'Aversa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Parse/Parse.h"

@protocol JobDelegate <NSObject>
@required
- (void) didAddJob:(PFObject *)job;
@end

@interface JobDetailTVC : UITableViewController <UITextFieldDelegate> {
    PFObject *job;
    id <JobDelegate> __weak delegate;
    
    UISegmentedControl *jobActive;
    UITextField *jobLocation;
    
    UITableViewCell *jobLocationCell;
	UITableViewCell *jobActiveCell;    
}

@property(nonatomic) PFObject *job;
@property(nonatomic, weak) id <JobDelegate> delegate;

@property(nonatomic) IBOutlet UISegmentedControl *jobActive;
@property(nonatomic) IBOutlet UITextField *jobLocation;

@property(nonatomic) IBOutlet UITableViewCell *jobLocationCell;
@property(nonatomic) IBOutlet UITableViewCell *jobActiveCell;    

- (void)save;
- (void)cancel;

@end
