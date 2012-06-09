//
//  EmployeeDetailTVC.m
//  dig
//
//  Created by Nino D'Aversa on 12-06-03.
//  Copyright (c) 2012 Nino D'Aversa. All rights reserved.
//


#import "EmployeeDetailTVC.h"
#import "PositionsTVC.h"

#define DETAILS_SECTION 0
#define ACTIVE_SECTION 1
#define POSITION_SECTION 2

@implementation EmployeeDetailTVC

@synthesize employee;
@synthesize delegate;

@synthesize employeeName;
@synthesize employeeActive;

@synthesize employeeNameCell;
@synthesize employeeActiveCell;

- (id)init {
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:@"EmployeeDetailTVC" owner:self options:nil];
    }
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:@"EmployeeDetailTVC" owner:self options:nil];
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

    if ([employee objectForKey:@"name"] == nil){
        self.navigationItem.title = @"Add Employee";
        
        UIBarButtonItem *cancelButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancel)];
        self.navigationItem.leftBarButtonItem = cancelButtonItem;
    }
    else{
        self.navigationItem.title = @"Edit Employee";
        [employeeName setText:[employee objectForKey:@"name"]];
        [employeeActive setSelectedSegmentIndex:([[employee objectForKey:@"active"] intValue]?0:1)];
    }
    employeeActive.frame = CGRectMake(10, 8, 185, 30);
    
    UIBarButtonItem *saveButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStyleDone target:self action:@selector(save)];
    self.navigationItem.rightBarButtonItem = saveButtonItem;
    
    self.tableView.allowsSelection = YES;
    
    employeeName.clearButtonMode = UITextFieldViewModeWhileEditing;
    employeeName.delegate = self;
    
    [employeeName becomeFirstResponder];
    
    self.navigationController.navigationBar.tintColor = NAVIGATIONBAR_TINT_COLOR;
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = TABLEVIEW_BACKGROUND_COLOR;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorColor = TABLEVIEW_SEPARATOR_COLOR;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData]; 
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
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
        case POSITION_SECTION:
			title = @"Position";
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
        case POSITION_SECTION:
			rows = 1;
			break;
    }
    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
	static NSString *MyIdentifier = @"EmployeeDetailCell";
	
	cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
	}
    
    NSString *text = nil;
	
	switch (indexPath.section) {
		case DETAILS_SECTION:
			switch (indexPath.row){
				case 0:
					cell = employeeNameCell;
					break;
			}
			break;
        case ACTIVE_SECTION:
			switch (indexPath.row){
				case 0:
					cell = employeeActiveCell;
					break;
			}
			break;
        case POSITION_SECTION:
			switch (indexPath.row){
				case 0:
                    text = [[[employee objectForKey:@"position"] fetchIfNeeded] objectForKey:@"desc"];
					break;
			}
			break;
	}
    
	cell.textLabel.text = text;
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row % 2)
    {
        cell.backgroundColor = TABLEVIEW_CELL1_BACKGROUND_COLOR;
        cell.textLabel.textColor = TABLEVIEW_CELL1_TEXT_COLOR;
    }
    else { 
        cell.backgroundColor = TABLEVIEW_CELL2_BACKGROUND_COLOR;
        cell.textLabel.textColor = TABLEVIEW_CELL2_TEXT_COLOR;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIViewController *nextViewController = nil;
    
    switch (indexPath.section) {
		case DETAILS_SECTION:
        case ACTIVE_SECTION:
            break;
        case POSITION_SECTION:
            nextViewController = [[PositionsTVC alloc] initWithStyle:UITableViewStyleGrouped];
            ((PositionsTVC *)nextViewController).employee = employee;
            break;
        default:
            break;
    }
    
    if (nextViewController) {
        [self.navigationController pushViewController:nextViewController animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (void)save {
    @try {
        [employee setObject:employeeName.text forKey:@"name"];
        [employee setObject:[NSNumber numberWithInteger:(employeeActive.selectedSegmentIndex?0:1)] forKey:@"active"];
        
        [employee saveInBackground];
    }
    @catch (NSException *exception) {
        employee = nil;
    }
    @finally {
        [self.delegate didAddEmployee:employee];
    }
}


- (void)cancel {
    [self.delegate didAddEmployee:nil];
}


@end
