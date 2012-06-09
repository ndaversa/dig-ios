//
//  VerticalTabBarController.m
//  dig
//
//  Created by Nino D'Aversa on 12-06-02.
//  Copyright (c) 2012 Nino D'Aversa. All rights reserved.
//

#import "VerticalTabBarController.h"
#import "UIImage+Helpers.h"
#import "PositionsTVC.h"
#import "EmployeesTVC.h"
#import "JobsTVC.h"
#import "SchedulesTVC.h"

@interface VerticalTabBarController () {
    NSArray* viewControllers;
}

@end

@implementation VerticalTabBarController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.delegate = self;
    
    NSMutableArray* controllersToAdd = [[NSMutableArray alloc] init];
    
    UIColor *iconColor      = [UIColor darkGrayColor];
    UIFont  *iconFont       = [UIFont fontWithName:@"FontAwesome" size:40];
    
    //set the background color to a texture
    [[self tabBar] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"darkwall.png"]]];
    [[self tabBar] setSelectedImageTintColor:[UIColor whiteColor]];
    
    UIImage *positionsIcon = [UIImage imageFromFont:iconFont color:iconColor character:0xF0E8];
    PositionsTVC * positionsTVC = [[PositionsTVC alloc] initWithStyle:UITableViewStyleGrouped];
    positionsTVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:nil image:positionsIcon tag: 0];
    UINavigationController *positionsNVC = [[UINavigationController alloc] init];
    [positionsNVC pushViewController:positionsTVC animated:NO];
    [controllersToAdd addObject:positionsNVC];
    
    UIImage *employeesIcon = [UIImage imageFromFont:iconFont color:iconColor character:0xF0C0];
    EmployeesTVC * employeesTVC = [[EmployeesTVC alloc] initWithStyle:UITableViewStyleGrouped];
    employeesTVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:nil image:employeesIcon tag: 0];
    UINavigationController *employeesNVC = [[UINavigationController alloc] init];
    [employeesNVC pushViewController:employeesTVC animated:NO];
    [controllersToAdd addObject:employeesNVC];
    
    UIImage *jobsIcon = [UIImage imageFromFont:iconFont color:iconColor character:0xF018];
    JobsTVC * jobsTVC = [[JobsTVC alloc] initWithStyle:UITableViewStyleGrouped];
    jobsTVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:nil image:jobsIcon tag: 0];
    UINavigationController *jobsNVC = [[UINavigationController alloc] init];
    [jobsNVC pushViewController:jobsTVC animated:NO];
    [controllersToAdd addObject:jobsNVC];
    
    UIImage *schedulesIcon = [UIImage imageFromFont:iconFont color:iconColor character:0xF073];
    SchedulesTVC * schedulesTVC = [[SchedulesTVC alloc] initWithStyle:UITableViewStyleGrouped];
    schedulesTVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:nil image:schedulesIcon tag: 0];
    UINavigationController *schedulesNVC = [[UINavigationController alloc] init];
    [schedulesNVC pushViewController:schedulesTVC animated:NO];
    [controllersToAdd addObject:schedulesNVC];
    
    viewControllers = [NSArray arrayWithArray:controllersToAdd];
    
    //set the view controllers of the the tab bar controller
    [self setViewControllers:viewControllers];
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self setSelectedViewController: ((UIViewController*)[viewControllers objectAtIndex:0])];
}

- (void)viewDidUnload 
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

-(BOOL)tabBarController:(FSVerticalTabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
//    if ([viewControllers indexOfObject:viewController] == 3) {
//        return NO;
//    }
    return YES;
}

@end
