//
//  StoryViewController.h
//  TheHarvardCrimson
//
//  Created by Maxwell Child on 7/19/09.
//  Copyright The Harvard Crimson, Inc. 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StoryViewController : UIViewController {
	
	//the story dictionary
	NSMutableDictionary *storyInfo;
	
	//section info
	NSString *sectionString;
	
	//for loading
	NSOperationQueue *operationQueue;
	UIActivityIndicatorView *spinner;
	UILabel *loadingLabel;
	
	//all the outlets in the view
	IBOutlet UIScrollView *storyScrollView;
	
	IBOutlet UILabel *dateAndTimeLabel;
	IBOutlet UILabel *sectionLabel;
	IBOutlet UILabel *headlineLabel;
	IBOutlet UILabel *subheadLabel;
	IBOutlet UILabel *photoCreditLabel;
	IBOutlet UILabel *bylineLabel;
	IBOutlet UILabel *storyTextLabel;
	
	IBOutlet UIImageView *storyImageView;
	
}

-(void) didFinishLoadingImageWithResult:(NSDictionary *)result;


@property (copy) NSString *sectionString;
@property (retain) NSMutableDictionary *storyInfo;

@end
