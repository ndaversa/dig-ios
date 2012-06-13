//
//  ScheduleDetailTVC.m
//  dig
//
//  Created by Nino D'Aversa on 12-06-06.
//  Copyright (c) 2012 Nino D'Aversa. All rights reserved.
//

#import "ScheduleDetailTVC.h"

#define DETAILS_SECTION 0
#define NOTES_SECTION 1
#define PLAN_SECTION 2
#define SUMMARY_SECTION 3

@implementation ScheduleDetailTVC

@synthesize schedule;
@synthesize delegate;
@synthesize dateFormatter;

@synthesize scheduleDate;
@synthesize scheduleNotes;
@synthesize planDay;

@synthesize scheduleDateCell;
@synthesize scheduleNotesCell;
@synthesize planDayCell;
@synthesize summaryCell;

- (id)init {
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:@"ScheduleDetailTVC" owner:self options:nil];
    }
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:@"ScheduleDetailTVC" owner:self options:nil];
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
    
    //configure the date formatter
	dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setTimeStyle:NSDateFormatterNoStyle];
	[dateFormatter setDateStyle:NSDateFormatterLongStyle];
    
    if ([schedule objectForKey:@"date"] == nil){
        self.navigationItem.title = @"Add Schedule";
        
        UIBarButtonItem *cancelButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancel)];
        self.navigationItem.leftBarButtonItem = cancelButtonItem;
    }
    else{
        self.navigationItem.title = @"Edit Schedule";
        [scheduleDate setText:[dateFormatter stringFromDate:[schedule objectForKey:@"date"]]];
        [scheduleNotes setText:[schedule objectForKey:@"notes"]];
    }
    
    UIBarButtonItem *saveButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStyleDone target:self action:@selector(save)];
    self.navigationItem.rightBarButtonItem = saveButtonItem;
    
    self.navigationController.navigationBar.tintColor = NAVIGATIONBAR_TINT_COLOR;
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = TABLEVIEW_BACKGROUND_COLOR;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLineEtched;
    self.tableView.separatorColor = TABLEVIEW_SEPARATOR_COLOR;
    
    scheduleNotes.delegate = self;
    showingPicker = NO;
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *title = nil;
    switch (section) {
        case DETAILS_SECTION:
			title = @"Date";
			break;
        case NOTES_SECTION:
			title = @"Notes";
			break;    
        case PLAN_SECTION:
			title = @"Plan";
			break;     
        case SUMMARY_SECTION:
			title = @"Summary";
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
        case NOTES_SECTION:
			rows = 1;
			break;
        case PLAN_SECTION:
            rows = 1;
            break;
        case SUMMARY_SECTION:
            rows = 1;
            break;
    }
    return rows;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	switch (indexPath.section){
		case DETAILS_SECTION:
        case PLAN_SECTION:
        case SUMMARY_SECTION:
			return 50;
		case NOTES_SECTION:
			return 150;
		default:
			return 44;
	}
	
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
	
	switch (indexPath.section) {
		case DETAILS_SECTION:
			switch (indexPath.row){
				case 0:
					cell = scheduleDateCell;
                    scheduleDate.text = [dateFormatter stringFromDate:[schedule objectForKey:@"date"]];
					break;
			}
			break;
        case NOTES_SECTION:
			switch (indexPath.row){
				case 0:
					cell = scheduleNotesCell;
					break;
			}
			break;
        case PLAN_SECTION:
			switch (indexPath.row){
				case 0:
					cell = planDayCell;
                    cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"cellGradient.png"]];
					break;
			}
			break;
        case SUMMARY_SECTION:
			switch (indexPath.row){
				case 0:
					cell = summaryCell;
                    cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"cellGradient.png"]];
					break;
			}
			break;
	}
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
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    //dismiss all others first
	[self dismissDatePicker:nil];
    [scheduleNotes resignFirstResponder];
    switch (indexPath.section) {
		case DETAILS_SECTION:
			switch (indexPath.row){
				case 0:
					[self displayDatePickerFromCell:cell animated:YES];
                    break;
			}
			break;
        case NOTES_SECTION:
			switch (indexPath.row){
				case 0:
					break;
			}
			break;
        case PLAN_SECTION:
			switch (indexPath.row){
				case 0:
                {
                    [self createJobsheetsForDate:[schedule objectForKey:@"date"]];
                    JobsheetsTVC *jobsheetTVC = [[JobsheetsTVC alloc] initWithStyle:UITableViewStyleGrouped];
                    jobsheetTVC.delegate = self;
                    jobsheetTVC.date = [schedule objectForKey:@"date"];
                    
                    UINavigationController *jobsheetNVC = [[UINavigationController alloc] init];
                    jobsheetNVC.modalPresentationStyle = UIModalPresentationPageSheet;
                    [jobsheetNVC pushViewController:jobsheetTVC animated:NO];
                    
                    [self.navigationController presentModalViewController:jobsheetNVC animated:YES];
					break;
                }
			}
			break;
        case SUMMARY_SECTION:
			switch (indexPath.row){
				case 0:
                {
//                    ScheduleSummaryVC *summaryVC = [[ScheduleSummaryVC alloc] init];
//                    summaryVC.delegate = self;
//                    summaryVC.schedule = schedule;
//
//                    UINavigationController *summaryNVC = [[UINavigationController alloc] init];
//                    summaryNVC.modalPresentationStyle = UIModalPresentationPageSheet;
//                    [summaryNVC pushViewController:summaryVC animated:NO];
//                    
//                    [self.navigationController presentModalViewController:summaryNVC animated:YES];
					break;
                }
			}
			break;
        default:
            break;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void) didSelectJobsheet {
    [self.navigationController dismissModalViewControllerAnimated:YES];
}

- (void) scheduleSummaryDidFinish {
    [self.navigationController dismissModalViewControllerAnimated:YES];
}

- (void) createJobsheetsForDate:(NSDate *)date{
//    NSSet *jobsheets = [[AppDelegate managedObjectContext] fetchObjectsForEntityName:@"Jobsheet" withPredicate:@"date = %@", date];
//    
//    if ([jobsheets count] == 0){ //only create Jobsheets one time
//        NSSet *jobs = [[AppDelegate managedObjectContext] fetchObjectsForEntityName:@"Job" withPredicate:@"active = YES"];
//        for (Job *job in jobs) {
//            //check if each Job already has a corresponding Jobsheet
//            if (0 == [[jobsheets filteredSetUsingPredicate:[NSPredicate predicateWithFormat:@"job==%@", job]] count]){ //not needed with jobsheets.count==0, but leave for now
//                
//                Jobsheet *newJobsheet = [NSEntityDescription insertNewObjectForEntityForName:@"Jobsheet" inManagedObjectContext:[AppDelegate managedObjectContext]];
//                
//                newJobsheet.date = date;
//                newJobsheet.job = job;
//                
//                Jobsheet *lastJobsheet = (Jobsheet *)[[AppDelegate managedObjectContext] fetchFirstObjectForEntityName:@"Jobsheet" sortedBy:@"date" ascending:NO withPredicate:@"job = %@ AND date < %@", job, date];
//                
//                //get Timesheets already existing for this Job and date
//                NSSet *timesheets = [[AppDelegate managedObjectContext] fetchObjectsForEntityName:@"Timesheet" 
//                                                                                    withPredicate:@"job = %@ AND date = %@", job, date];
//                
//                if ([timesheets count] == 0){
//                    //get Timesheets from last visit to this Job
//                    NSSet *lastTimesheets = [[AppDelegate managedObjectContext] fetchObjectsForEntityName:@"Timesheet" 
//                                                                                            withPredicate:@"job = %@ AND date = %@", job, lastJobsheet.date];
//                    
//                    for (Timesheet *timesheet in lastTimesheets) { 
//                        //check if a timesheet already exists for this employee
//                        if (0 == [[timesheets filteredSetUsingPredicate:[NSPredicate predicateWithFormat:@"employee==%@", timesheet.employee]] count]){  //not needed with timesheets.count==0, but leave for now
//                            //create a new timesheet for this employee since they were here last time
//                            Timesheet *newTimesheet = [NSEntityDescription insertNewObjectForEntityForName:@"Timesheet" inManagedObjectContext:[AppDelegate managedObjectContext]];
//                            newTimesheet.date = date;
//                            newTimesheet.nightWork = timesheet.nightWork;
//                            newTimesheet.job = job;
//                            newTimesheet.position = timesheet.position;
//                            newTimesheet.employee = timesheet.employee;
//                            
//                            //save: called removed to handle dropbox sync
//                        }
//                    }
//                }
//
//                //save: called removed to handle dropbox sync
//            }
//        }
//    }
}

- (void)displayDatePickerFromCell:(UITableViewCell*)cell animated:(BOOL)animated{	
    showingPicker = YES;
    
    datePicker = [[UIDatePicker alloc] init];
    
    UIViewController *datePickerVC = [[UIViewController alloc] init];
    datePickerVC.view = datePicker;
    datePickerVC.title =  @"Create a schedule for";
    
    UINavigationController *datePickerNVC = [[UINavigationController alloc] init];
    [datePickerNVC pushViewController:datePickerVC animated:NO];
    
    datePopover = [[UIPopoverController alloc] initWithContentViewController:datePickerNVC];
    datePopover.popoverContentSize = CGSizeMake(320, 256);
    datePopover.delegate = self;
    [datePopover presentPopoverFromRect:cell.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp|UIPopoverArrowDirectionDown animated:animated];

    datePicker.datePickerMode = UIDatePickerModeDate;
    datePicker.date = [NSDate dateWithoutTime];
    
    if ([schedule objectForKey:@"date"] != nil)
        datePicker.date = [schedule objectForKey:@"date"];
}

- (void)dismissDatePicker:(id)sender {
    if (showingPicker){
        PFQuery *query = [[PFQuery alloc] initWithClassName:@"Schedule"];
        [query whereKey:@"date" equalTo:[datePicker date]];
        [query orderByDescending:@"_created_at"];
        NSMutableArray *previousSchedule = [NSMutableArray arrayWithArray:[query findObjects]];
        
        if ([previousSchedule count] == 0) {
            [schedule setObject:[datePicker date] forKey:@"date"];
        }
        else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Cannot Create Schedule" 
                                                                message:[NSString stringWithFormat:@"A schedule for %@ already exists.", [dateFormatter stringFromDate:[datePicker date]]]
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
            [alertView show];
        }

        [self.tableView reloadData];
        
        if (datePopover != nil){
            [datePopover dismissPopoverAnimated:YES];
            datePopover.delegate = nil;
            datePopover = nil;
        }
        datePicker = nil;
        showingPicker = NO; 
    }
}

- (void) popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
    [self dismissDatePicker:popoverController];
}

- (BOOL)popoverControllerShouldDismissPopover:(UIPopoverController *)popoverController {
    return YES;
}

- (void)save {
    @try {
        if (![schedule objectForKey:@"date"])
            [schedule setObject:[NSDate dateWithoutTime] forKey:@"date"];
        [schedule setObject:[scheduleNotes text] forKey:@"notes"];
        
        [schedule saveInBackground];
    }
    @catch (NSException *exception) {
        schedule = nil;
    }
    @finally {
        [self.delegate didAddSchedule:schedule];
    }
}

- (void)cancel {
    [self.delegate didAddSchedule:nil];
}


@end
