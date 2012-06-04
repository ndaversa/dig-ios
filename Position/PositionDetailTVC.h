//
//  DIGPositionDetailTVC.h
//  dig
//
//  Created by Nino D'Aversa on 12-06-02.
//  Copyright (c) 2012 Nino D'Aversa. All rights reserved.
//

#import "Parse/Parse.h"
#import <UIKit/UIKit.h>

@protocol PositionDelegate <NSObject>
@required
- (void) didAddPosition:(PFObject *)position;
@end

@interface PositionDetailTVC : UITableViewController <UITextFieldDelegate> {
    PFObject *position;
    id <PositionDelegate> __weak delegate;
    NSNumberFormatter *currencyFormatter;
    NSCharacterSet *nonNumberSet;
    
    UITextField *positionDesc;
    UITextField *positionPayRate;
    
    UITableViewCell *positionDescCell;
	UITableViewCell *positionPayRateCell;    
}
@property(nonatomic) PFObject *position;
@property(nonatomic, weak) id <PositionDelegate> delegate;

@property(nonatomic) IBOutlet UITextField *positionDesc;
@property(nonatomic) IBOutlet UITextField *positionPayRate;

@property(nonatomic) IBOutlet UITableViewCell *positionDescCell;
@property(nonatomic) IBOutlet UITableViewCell *positionPayRateCell;    

- (void)save;
- (void)cancel;

@end