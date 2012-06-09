//
//  JobsTVC.m
//  dig
//
//  Created by Nino D'Aversa on 12-06-04.
//  Copyright (c) 2012 Nino D'Aversa. All rights reserved.
//

#import "JobsTVC.h"

@implementation JobsTVC

- (void)viewDidLoad {
    [super viewDidLoad];

    // Initialize the data
    jobs = [[NSMutableArray alloc] init];
    
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    self.navigationItem.title = @"Jobs";
    UIBarButtonItem *addButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(add:)];
    self.navigationItem.rightBarButtonItem = addButtonItem;
    
    [self refresh];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [jobs count];
}

- (void) add:(id)sender {
    JobDetailTVC *addController = [[JobDetailTVC alloc] init];
    addController.delegate = self;
	
    PFObject *newJob = [[PFObject alloc] initWithClassName:@"Job"];
	addController.job = newJob;
	
    [self.navigationController pushViewController:addController animated:YES];
}

- (void) didAddJob:(PFObject *)job{
    if (job) {
        
        NSUInteger index = [jobs indexOfObject:job];
        if (index == NSNotFound) {
            [jobs insertObject:job atIndex:0];
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
    
    static NSString *CellIdentifier = @"JobCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:CellIdentifier];
    }
    
    if (jobs.count > indexPath.row) {
        PFObject* job = [[jobs objectAtIndex:indexPath.row] fetchIfNeeded];
        cell.textLabel.text = [job objectForKey:@"location"];
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
    JobDetailTVC *detailController = [[JobDetailTVC alloc] initWithStyle:UITableViewStyleGrouped];
    detailController.delegate = self;
    detailController.job = [jobs objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:detailController animated:YES];
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)refreshInCurrentThread {
    @autoreleasepool {
    
        PFQuery *query = [[PFQuery alloc] initWithClassName:@"Job"];
        [query orderByDescending:@"_created_at"];
        NSMutableArray *newJobs = [NSMutableArray arrayWithArray:[query findObjects]];
        if (newJobs == nil) {
            newJobs = [[NSMutableArray alloc] init];
        }
        jobs = newJobs;
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
        PFObject *objectToRemove = [jobs objectAtIndex:indexPath.row];
        [jobs removeObject:objectToRemove];
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