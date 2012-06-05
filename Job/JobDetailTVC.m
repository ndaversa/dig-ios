//
//  JobDetailTVC.m
//  dig
//
//  Created by Nino D'Aversa on 12-06-04.
//  Copyright (c) 2012 Nino D'Aversa. All rights reserved.
//

#import "JobDetailTVC.h"

#define DETAILS_SECTION 0
#define ACTIVE_SECTION 1

@implementation JobDetailTVC

@synthesize job;
@synthesize delegate;

@synthesize jobLocation;
@synthesize jobActive;

@synthesize jobLocationCell;
@synthesize jobActiveCell;

- (id)init {
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:@"JobDetailTVC" owner:self options:nil];
    }
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:@"JobDetailTVC" owner:self options:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    if ([job objectForKey:@"location"] == nil){
        self.navigationItem.title = @"Add Job";
        
        UIBarButtonItem *cancelButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancel)];
        self.navigationItem.leftBarButtonItem = cancelButtonItem;
    }
    else{
        self.navigationItem.title = @"Edit Job";
        [jobLocation setText:[job objectForKey:@"location"]];
        [jobActive setSelectedSegmentIndex:([[job objectForKey:@"active"] intValue]?0:1)];
    }
    jobActive.frame = CGRectMake(10, 8, 185, 30);
    
    UIBarButtonItem *saveButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStyleDone target:self action:@selector(save)];
    self.navigationItem.rightBarButtonItem = saveButtonItem;
    
    self.tableView.allowsSelection = NO;
    
    jobLocation.clearButtonMode = UITextFieldViewModeWhileEditing;
    jobLocation.delegate = self;
    
    [jobLocation becomeFirstResponder];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
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

#pragma mark - Table view data source


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *title = nil;
    switch (section) {
        case DETAILS_SECTION:
			title = @"Details";
			break;
        case ACTIVE_SECTION:
			title = @"Status";
			break;
    }
    return title;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rows = 0;
    
    switch (section) {
		case DETAILS_SECTION:
			rows = 1;
			break;
        case ACTIVE_SECTION:
			rows = 1;
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
					cell = jobLocationCell;
					break;
			}
			break;
        case ACTIVE_SECTION:
			switch (indexPath.row){
				case 0:
					cell = jobActiveCell;
					break;
			}
			break;
	}
    return cell;
}

- (void)save {
    [job setObject:jobLocation.text forKey:@"location"];
    [job setObject:[NSNumber numberWithInteger:(jobActive.selectedSegmentIndex?0:1)] forKey:@"active"];
    
    [job saveInBackground];
    
	[self.delegate didAddJob:job];
}


- (void)cancel {
    [self.delegate didAddJob:nil];
}

@end