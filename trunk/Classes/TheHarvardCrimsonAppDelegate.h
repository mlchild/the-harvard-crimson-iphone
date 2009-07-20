//
//  TheHarvardCrimsonAppDelegate.h
//  TheHarvardCrimson
//
//  Created by Maxwell Child on 7/12/09.
//  Copyright The Harvard Crimson, Inc. 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StoryTableViewController.h"

@interface TheHarvardCrimsonAppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow *window;
	UITabBarController *tabBarController;	

	
	StoryTableViewController *topNewsTableViewController;
	StoryTableViewController *flyByTableViewController;
	StoryTableViewController *opinionTableViewController;
	StoryTableViewController *sportsTableViewController;
	StoryTableViewController *magazineTableViewController;
	StoryTableViewController *artsTableViewController;
	
	//need something for photo, video
	 
	 
}

@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, retain) UITabBarController *tabBarController;

@end

