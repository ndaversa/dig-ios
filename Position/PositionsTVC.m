//
//  PositionsTVC.m
//  dig
//
//  Created by Nino D'Aversa on 12-06-02.
//  Copyright (c) 2012 Nino D'Aversa. All rights reserved.
//

#import "PositionsTVC.h"

@implementation PositionsTVC

@synthesize employee;

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    // Initialize the data
    positions = [[NSMutableArray alloc] init];
    
    if (employee == nil)
		self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    self.navigationItem.title = @"Positions";
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
    return [positions count];
}

- (void) add:(id)sender {
    PositionDetailTVC *addController = [[PositionDetailTVC alloc] init];
    addController.delegate = self;
	
    PFObject *newPosition = [[PFObject alloc] initWithClassName:@"Position"];
	addController.position = newPosition;
	
    [self.navigationController pushViewController:addController animated:YES];
}

- (void) didAddPosition:(PFObject *)position{
    if (position) {
        if (employee != nil){
            [employee setObject:position forKey:@"position"];
        }
        
        NSUInteger index = [positions indexOfObject:position];
        if (index == NSNotFound) {
            [positions insertObject:position atIndex:0];
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
    
    static NSString *CellIdentifier = @"PositionCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:CellIdentifier];
    }
    
    if (positions.count > indexPath.row) {
        PFObject* position = [[positions objectAtIndex:indexPath.row] fetchIfNeeded];
        cell.textLabel.text = [position objectForKey:@"desc"];
    
        if ([position.objectId isEqual: ((PFObject *)[employee objectForKey:@"position"]).objectId]) {
            selectedIndex = indexPath;
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else
            cell.accessoryType = UITableViewCellAccessoryNone;
        
        if (employee == nil)
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
    if (employee != nil){
        if (selectedIndex && selectedIndex != indexPath)
            [tableView cellForRowAtIndexPath:selectedIndex].accessoryType = UITableViewCellAccessoryNone;
        selectedIndex = indexPath;
		[[tableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryCheckmark];    
		
        [employee setObject:[positions objectAtIndex:indexPath.row] forKey:@"position"];
	}
	else{
		PositionDetailTVC *detailController = [[PositionDetailTVC alloc] initWithStyle:UITableViewStyleGrouped];
        detailController.delegate = self;
        detailController.position = [positions objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:detailController animated:YES];
	}
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)refreshInCurrentThread {
    @autoreleasepool {
    
        PFQuery *query = [[PFQuery alloc] initWithClassName:@"Position"];
        [query orderByDescending:@"_created_at"];
        NSMutableArray *newPositions = [NSMutableArray arrayWithArray:[query findObjects]];
        if (newPositions == nil) {
            newPositions = [[NSMutableArray alloc] init];
        }
        positions = newPositions;
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
        PFObject *objectToRemove = [positions objectAtIndex:indexPath.row];
        [positions removeObject:objectToRemove];
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

