//
//  SchedulesTVC.m
//  dig
//
//  Created by Nino D'Aversa on 12-06-06.
//  Copyright (c) 2012 Nino D'Aversa. All rights reserved.
//

#import "SchedulesTVC.h"

@implementation SchedulesTVC

- (id)initForReporting {
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        reporting = YES;
    }
    return self; 
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = reporting ? @"Reports" : @"Schedules";
	
    if (!reporting){
        self.navigationItem.leftBarButtonItem = self.editButtonItem;
        
        UIBarButtonItem *addButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(add:)];
        self.navigationItem.rightBarButtonItem = addButtonItem;
        //	self.tableView.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
    }
    
    //configure the date formatter
	dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setTimeStyle:NSDateFormatterNoStyle];
	[dateFormatter setDateStyle:NSDateFormatterLongStyle];
    
    [self refresh];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [schedules count];
}

- (void) add:(id)sender {
    ScheduleDetailTVC *addController = [[ScheduleDetailTVC alloc] init];
    addController.delegate = self;
	
    PFObject *newSchedule = [[PFObject alloc] initWithClassName:@"Schedule"];
	addController.schedule = newSchedule;
	
    [self.navigationController pushViewController:addController animated:YES];
}

- (void) didAddSchedule:(PFObject *)schedule{
    if (schedule) {
        NSUInteger index = [schedules indexOfObject:schedule];
        if (index == NSNotFound) {
            [schedules insertObject:schedule atIndex:0];
            NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:path]
                                  withRowAnimation:UITableViewRowAnimationTop];
        }
        else {
            NSIndexPath *path = [NSIndexPath indexPathForRow:index inSection:0];
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:path]
                                  withRowAnimation:UITableViewRowAnimationFade];
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"ScheduleCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:CellIdentifier];
    }
    
    if (schedules.count > indexPath.row) {
        PFObject* schedule = [[schedules objectAtIndex:indexPath.row] fetchIfNeeded];
        cell.textLabel.text = [dateFormatter stringFromDate:[schedule objectForKey:@"date"]];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger index = [[tableView indexPathsForVisibleRows] indexOfObject:indexPath];
    if (index != NSNotFound) {
        UITableViewCell *cell = [[tableView visibleCells] objectAtIndex:index];
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (reporting){
        JobsheetsTVC *jobsheetTVC = [[JobsheetsTVC alloc] initForReporting];
        jobsheetTVC.delegate = self;
        PFObject *schedule = [[schedules objectAtIndex:indexPath.row] fetchIfNeeded];
        jobsheetTVC.date = [schedule objectForKey:@"date"];
        
        UINavigationController *jobsheetNVC = [[UINavigationController alloc] init];
        jobsheetNVC.modalPresentationStyle = UIModalPresentationPageSheet;
        [jobsheetNVC pushViewController:jobsheetTVC animated:NO];
        [self.navigationController presentModalViewController:jobsheetNVC animated:YES];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
	}
	else{
		ScheduleDetailTVC *detailController = [[ScheduleDetailTVC alloc] initWithStyle:UITableViewStyleGrouped];
        detailController.delegate = self;
        detailController.schedule = [schedules objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:detailController animated:YES];
	}
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void) didSelectJobsheet {
    [self.navigationController dismissModalViewControllerAnimated:YES];
}

- (void)refreshInCurrentThread {
    @autoreleasepool {
    
        PFQuery *query = [[PFQuery alloc] initWithClassName:@"Schedule"];
        [query orderByDescending:@"_created_at"];
        NSMutableArray *newSchedules = [NSMutableArray arrayWithArray:[query findObjects]];
        if (newSchedules == nil) {
            newSchedules = [[NSMutableArray alloc] init];
        }
        schedules = newSchedules;
        [self performSelectorOnMainThread:@selector(didRefresh)
                               withObject:nil
                            waitUntilDone:NO];
    }
}

- (void)refresh {
    [self willRefresh];
    [self performSelectorInBackground:@selector(refreshInCurrentThread)
                           withObject:nil];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        PFObject *objectToRemove = [schedules objectAtIndex:indexPath.row];
        [schedules removeObject:objectToRemove];
        [objectToRemove deleteInBackground];
        
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                              withRowAnimation:UITableViewRowAnimationAutomatic];
    }   
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end