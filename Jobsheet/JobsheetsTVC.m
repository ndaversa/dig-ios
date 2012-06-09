//
//  JobsheetsTVC.m
//  dig
//
//  Created by Nino D'Aversa on 12-06-06.
//  Copyright (c) 2012 Nino D'Aversa. All rights reserved.
//

#import "JobsheetsTVC.h"

@implementation JobsheetsTVC

@synthesize delegate;
@synthesize date;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        reporting = NO;
    }
    return self;
}

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
    self.navigationItem.title = reporting ? @"Report by Job" : @"Schedules by Job";

    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonTapped:)];
    self.navigationItem.rightBarButtonItem = doneButton;
    
    [self refresh];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void) doneButtonTapped:(id) sender{
    [delegate didSelectJobsheet];
}

- (void) timesheetSelectionDidFinish{
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [jobsheets count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *JobsheetCell= @"JobsheetCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:JobsheetCell];
    if (cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:JobsheetCell];
    
    if (jobsheets.count > indexPath.row) {
        PFObject* jobsheet = [[jobsheets objectAtIndex:indexPath.row] fetchIfNeeded];
        cell.textLabel.text = [NSString stringWithFormat:@"%@", [[[jobsheet objectForKey:@"job"] fetchIfNeeded] objectForKey:@"location"]];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return !reporting;
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
//    TimesheetSelectionTVC *timesheetTVC = [[TimesheetSelectionTVC alloc] initWithStyle:UITableViewStyleGrouped];
//    timesheetTVC.jobsheet = [jobsheets objectAtIndex:indexPath.row];
//    [self.navigationController pushViewController:timesheetTVC animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)refreshInCurrentThread {
    @autoreleasepool {
    
        PFQuery *query = [[PFQuery alloc] initWithClassName:@"Jobsheet"];
        [query orderByDescending:@"_created_at"];
        NSMutableArray *newJobsheets = [NSMutableArray arrayWithArray:[query findObjects]];
        if (newJobsheets == nil) {
            newJobsheets = [[NSMutableArray alloc] init];
        }
        jobsheets = newJobsheets;
        [self performSelectorOnMainThread:@selector(didRefresh)
                               withObject:nil
                            waitUntilDone:NO];
        if (isLoading) {
            [self stopLoading];
        }
    
    }
}

- (void)refresh {
    [self willRefresh];
    [self performSelectorInBackground:@selector(refreshInCurrentThread)
                           withObject:nil];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        PFObject *objectToRemove = [jobsheets objectAtIndex:indexPath.row];
        [jobsheets removeObject:objectToRemove];
        [objectToRemove deleteInBackground];
        
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                              withRowAnimation:UITableViewRowAnimationAutomatic];
    }   
}

@end
