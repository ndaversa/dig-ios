//
//  EmployeeTVC.m
//  dig
//
//  Created by Nino D'Aversa on 12-06-03.
//  Copyright (c) 2012 Nino D'Aversa. All rights reserved.
//


#import "EmployeesTVC.h"

@implementation EmployeesTVC

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    // Initialize the data
    employees = [[NSMutableArray alloc] init];
    
    self.navigationItem.title = @"Employees";
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
    return [employees count];
}

- (void) add:(id)sender {
    EmployeeDetailTVC *addController = [[EmployeeDetailTVC alloc] init];
    addController.delegate = self;
	
    PFObject *newEmployee = [[PFObject alloc] initWithClassName:@"Employee"];
	addController.employee = newEmployee;
	
    [self.navigationController pushViewController:addController animated:YES];
}

- (void) didAddEmployee:(PFObject *)employee{
    [self.navigationController popViewControllerAnimated:YES];
    NSUInteger index = [employees indexOfObject:employee];
    if (index == NSNotFound) {
        [employees insertObject:employee atIndex:0];
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

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"EmployeeCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:CellIdentifier];
    }
    
    if (employees.count > indexPath.row) {
        PFObject* employee = [employees objectAtIndex:indexPath.row];
        cell.textLabel.text = [employee objectForKey:@"name"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    EmployeeDetailTVC *detailController = [[EmployeeDetailTVC alloc] initWithStyle:UITableViewStyleGrouped];
    detailController.delegate = self;
    detailController.employee = [employees objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:detailController animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)refreshInCurrentThread {
    @autoreleasepool {
    
        PFQuery *query = [[PFQuery alloc] initWithClassName:@"Employee"];
        [query orderByDescending:@"_created_at"];
        NSMutableArray *newEmployees = [NSMutableArray arrayWithArray:[query findObjects]];
        if (newEmployees == nil) {
            newEmployees = [[NSMutableArray alloc] init];
        }
        employees = newEmployees;
        [self performSelectorOnMainThread:@selector(reloadData)
                               withObject:nil
                            waitUntilDone:NO];
        if (isLoading) {
            [self stopLoading];
        }
    
    }
}

- (void)reloadData {
    if (!isLoading)
        [self.tableView reloadData];
}

- (void)refresh {
    [self performSelectorInBackground:@selector(refreshInCurrentThread)
                           withObject:nil];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Do not allow editing items
    return NO;
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end

