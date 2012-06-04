//
//  PositionsTVC.h
//  dig
//
//  Created by Nino D'Aversa on 12-06-02.
//  Copyright (c) 2012 Nino D'Aversa. All rights reserved.
//

#import "Parse/Parse.h"
#import "PullRefreshTableViewController.h"
#import "PositionDetailTVC.h"
#import <UIKit/UIKit.h>


@interface PositionsTVC : PullRefreshTableViewController <UITextFieldDelegate, PositionDelegate> {
    NSMutableArray *positions;
    PFObject *employee;
}

- (void) add:(id)sender;
@property (nonatomic) PFObject *employee;

@end
