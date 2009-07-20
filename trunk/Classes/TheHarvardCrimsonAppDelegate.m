//
//  TheHarvardCrimsonAppDelegate.m
//  TheHarvardCrimson
//
//  Created by Maxwell Child on 7/12/09.
//  Copyright The Harvard Crimson, Inc. 2009. All rights reserved.
//

#import "TheHarvardCrimsonAppDelegate.h"

@implementation TheHarvardCrimsonAppDelegate

@synthesize window, tabBarController;

#pragma mark -
#pragma mark Application lifecycle

- (void)applicationDidFinishLaunching:(UIApplication *)application {    
    
	//creating tab bar controller, creating array of view controllers
	tabBarController = [[UITabBarController alloc] init];
	NSMutableArray *viewControllersArray = [[NSMutableArray alloc] init];
	
	//initialize root view controller with "top news" tag
	topNewsTableViewController = [[StoryTableViewController alloc] initWithStyle:UITableViewStylePlain andTypeString:@"Top News"];
	
	//create the nav controller with the correct root view
	UINavigationController *localNavigationController = [[UINavigationController alloc] initWithRootViewController:topNewsTableViewController];
	
	//add the new nav contoller (with root view controller inside it) to the array
	[viewControllersArray addObject:localNavigationController];
	[topNewsTableViewController release];
	[localNavigationController release];
	
	
	
	
	//flyby controller, same shit as above
	flyByTableViewController = [[StoryTableViewController alloc] initWithStyle:UITableViewStylePlain andTypeString:@"FlyBy"];
	localNavigationController = [[UINavigationController alloc] initWithRootViewController:flyByTableViewController];
	[viewControllersArray addObject:localNavigationController];
	[flyByTableViewController release];
	[localNavigationController release];
	
	//opinion
	opinionTableViewController = [[StoryTableViewController alloc] initWithStyle:UITableViewStylePlain andTypeString:@"Opinion"];
	localNavigationController = [[UINavigationController alloc] initWithRootViewController:opinionTableViewController];
	[viewControllersArray addObject:localNavigationController];
	[opinionTableViewController release];
	[localNavigationController release];
	
	//FM
	magazineTableViewController = [[StoryTableViewController alloc] initWithStyle:UITableViewStylePlain andTypeString:@"Magazine"];
	localNavigationController = [[UINavigationController alloc] initWithRootViewController:magazineTableViewController];
	[viewControllersArray addObject:localNavigationController];
	[magazineTableViewController release];
	[localNavigationController release];
	
	//sports
	sportsTableViewController = [[StoryTableViewController alloc] initWithStyle:UITableViewStylePlain andTypeString:@"Sports"];
	localNavigationController = [[UINavigationController alloc] initWithRootViewController:sportsTableViewController];
	[viewControllersArray addObject:localNavigationController];
	[sportsTableViewController release];
	[localNavigationController release];
	
	//arts
	artsTableViewController = [[StoryTableViewController alloc] initWithStyle:UITableViewStylePlain andTypeString:@"Arts"];
	localNavigationController = [[UINavigationController alloc] initWithRootViewController:artsTableViewController];
	[viewControllersArray addObject:localNavigationController];
	[artsTableViewController release];
	[localNavigationController release];
	
	
	
	//need to put photo picker in here somewhere
	
	
	
	//adding all VCs to tab bar
	tabBarController.viewControllers = viewControllersArray;
	[viewControllersArray release];
	
	
	[window addSubview:[tabBarController view]];
    [window makeKeyAndVisible];
}


- (void)applicationWillTerminate:(UIApplication *)application {
	// Save data if appropriate
}


#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	[tabBarController release];
	
	[window release];
	[super dealloc];
}

@end
