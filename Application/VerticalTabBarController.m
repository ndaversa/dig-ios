//
//  VerticalTabBarController.m
//  dig
//
//  Created by Nino D'Aversa on 12-06-02.
//  Copyright (c) 2012 Nino D'Aversa. All rights reserved.
//

#import "VerticalTabBarController.h"
#import "PositionsTVC.h"
#import "EmployeesTVC.h"

@interface VerticalTabBarController () {
    NSArray* viewControllers;
}

@end

@implementation VerticalTabBarController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.delegate = self;
    
    //Create view controllers
    NSMutableArray* controllersToAdd = [[NSMutableArray alloc] init];
    

    PositionsTVC * positionsTVC = [[PositionsTVC alloc] initWithStyle:UITableViewStyleGrouped];
    positionsTVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Positions" image:[UIImage imageNamed:@"positions"] tag: 0];
    
    UINavigationController *positionsNVC = [[UINavigationController alloc] init];
    positionsNVC.navigationBar.tintColor = [UIColor darkGrayColor];
    [positionsNVC pushViewController:positionsTVC animated:NO];
    
    [controllersToAdd addObject:positionsNVC];
    
    EmployeesTVC * employeesTVC = [[EmployeesTVC alloc] initWithStyle:UITableViewStyleGrouped];
    employeesTVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Employees" image:[UIImage imageNamed:@"employees"] tag: 0];
    
    UINavigationController *employeesNVC = [[UINavigationController alloc] init];
    employeesNVC.navigationBar.tintColor = [UIColor darkGrayColor];
    [employeesNVC pushViewController:employeesTVC animated:NO];
    
    [controllersToAdd addObject:employeesNVC];
    
    viewControllers = [NSArray arrayWithArray:controllersToAdd];
    
    //set the view controllers of the the tab bar controller
    [self setViewControllers:viewControllers];
    
    //set the background color to a texture
    [[self tabBar] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"ios-linen.png"]]];
    
    self.selectedViewController = ((UIViewController*)[viewControllers objectAtIndex:0]);
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
