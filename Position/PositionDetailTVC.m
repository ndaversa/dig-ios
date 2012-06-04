//
//  DIGPositionDetailTVC.h
//  dig
//
//  Created by Nino D'Aversa on 12-06-02.
//  Copyright (c) 2012 Nino D'Aversa. All rights reserved.
//

#import "PositionDetailTVC.h"

#define DETAILS_SECTION 0

@implementation PositionDetailTVC

@synthesize position;
@synthesize delegate;

@synthesize positionDesc;
@synthesize positionPayRate;

@synthesize positionDescCell;
@synthesize positionPayRateCell;

- (id)init {
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:@"PositionDetailTVC" owner:self options:nil];
    }
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:@"PositionDetailTVC" owner:self options:nil];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    currencyFormatter = [[NSNumberFormatter alloc] init];
    [currencyFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
    [currencyFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [currencyFormatter setMaximumFractionDigits:0];
    [currencyFormatter setLocale:[NSLocale currentLocale]];
    
    NSMutableCharacterSet *numberSet = [[NSCharacterSet decimalDigitCharacterSet] mutableCopy];
    [numberSet formUnionWithCharacterSet:[NSCharacterSet whitespaceCharacterSet]];
    nonNumberSet = [numberSet invertedSet];
    
    if ([position objectForKey:@"desc"] == nil){
        self.navigationItem.title = @"Add Position";
        
        UIBarButtonItem *cancelButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancel)];
        self.navigationItem.leftBarButtonItem = cancelButtonItem;
    }
    else{
        self.navigationItem.title = @"Edit Position";
        [positionDesc setText:[position objectForKey:@"desc"]];
        [positionPayRate setText:[currencyFormatter stringFromNumber:[position objectForKey:@"payRate"]]];
    }

    UIBarButtonItem *saveButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStyleDone target:self action:@selector(save)];
    self.navigationItem.rightBarButtonItem = saveButtonItem;
    
    self.tableView.allowsSelection = NO;
    
    positionDesc.clearButtonMode = UITextFieldViewModeWhileEditing;
    positionDesc.delegate = self;
    
    [positionDesc becomeFirstResponder];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

-(BOOL) textFieldShouldReturn:(UITextField*) textField {
    [textField resignFirstResponder]; 
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([textField isEqual:positionPayRate]){
        BOOL result = NO; //default to reject
        
        if([string length] == 0){ //backspace
            result = YES;
        }
        else{
            if([string stringByTrimmingCharactersInSet:nonNumberSet].length > 0){
                result = YES;
            }
        }
        
        //here we deal with the UITextField on our own
        if(result){
            //grab a mutable copy of what's currently in the UITextField
            NSMutableString* mstring = [[textField text] mutableCopy];
            if([mstring length] == 0){
                //special case...nothing in the field yet, so set a currency symbol first
                [mstring appendString:[[NSLocale currentLocale] objectForKey:NSLocaleCurrencySymbol]];
                
                //now append the replacement string
                [mstring appendString:string];
            }
            else{
                //adding a char or deleting?
                if([string length] > 0){
                    [mstring insertString:string atIndex:range.location];
                }
                else {
                    //delete case - the length of replacement string is zero for a delete
                    [mstring deleteCharactersInRange:range];
                }
            }
            
            //to get the grouping separators properly placed
            //first convert the string into a number. The function
            //will ignore any grouping symbols already present -- NOT in iOS4!
            //fix added below - remove locale specific currency separators first
            NSString* localeSeparator = [[NSLocale currentLocale] 
                                         objectForKey:NSLocaleGroupingSeparator];
            NSNumber* number = [currencyFormatter numberFromString:[mstring
                                                                    stringByReplacingOccurrencesOfString:localeSeparator 
                                                                    withString:@""]];
            
            //now format the number back to the proper currency string
            //and get the grouping separators added in and put it in the UITextField
            [textField setText:[currencyFormatter stringFromNumber:number]];
        }
        
        //always return no since we are manually changing the text field
        return NO;
    }
    else
        return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *title = nil;
    switch (section) {
        case DETAILS_SECTION:
			title = @"Details";
			break;
    }
    return title;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rows = 0;
    
    switch (section) {
		case DETAILS_SECTION:
			rows = 2;
			break;
    }
    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
	
	switch (indexPath.section) {
		case DETAILS_SECTION:
			switch (indexPath.row){
				case 0:
					cell = positionDescCell;
					break;
				case 1:
					cell = positionPayRateCell;
					break;
			}
			break;
	}
    return cell;
}


- (void)save {
    [position setObject:positionDesc.text forKey:@"desc"];
    [position setObject:(NSDecimalNumber*)[currencyFormatter numberFromString:positionPayRate.text] forKey:@"payRate"];
    
    [position saveInBackground];
	[self.delegate didAddPosition:position];
}


- (void)cancel {
    [self.delegate didAddPosition:nil];
}


@end
