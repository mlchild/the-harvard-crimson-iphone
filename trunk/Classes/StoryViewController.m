//
//  StoryViewController.m
//  TheHarvardCrimson
//
//  Created by Maxwell Child on 7/19/09.
//  Copyright The Harvard Crimson, Inc. 2009. All rights reserved.
//

#import "StoryViewController.h"
#import "ImageLoadingOperation.h"


@implementation StoryViewController

@synthesize storyInfo, sectionString;


 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
		
		storyInfo = [[NSMutableDictionary alloc] init];
		
		operationQueue = [[NSOperationQueue alloc] init];
		[operationQueue setMaxConcurrentOperationCount:1];
		
    }
    return self;
}




// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	
	//"flags" on the two things that change scroll heights
	BOOL isTherePhoto = YES;
	BOOL isThereSubhead = YES;
	
	//points of origin, sizes to be used throughout
	CGPoint headlineOrigin;
	CGPoint subheadOrigin;
	CGPoint photoOrigin;
	CGPoint bylineOrigin;
	CGPoint storyTextOrigin;
	
	CGSize headlineSize;
	CGSize subheadSize;
	CGSize photoSize;
	CGSize bylineSize;
	CGSize storyTextSize;
	
	
	//SECTION SECTION (ha ha)--basically just capitalization
	if (sectionString == @"Top News") {
		sectionString = @"TOP NEWS";
	}
	if (sectionString == @"FlyBy") {
		sectionString = @"FLYBYBLOG";
	}
	if (sectionString == @"Opinion") {
		sectionString = @"OPINION";
	}
	if (sectionString == @"Magazine") {
		sectionString = @"MAGAZINE";
	}
	if (sectionString == @"Sports") {
		sectionString = @"SPORTS";
	}
	if (sectionString == @"Arts") {
		sectionString = @"ARTS";
	}
	
	sectionLabel.text = sectionString;
	
	
	//DATE AND TIME SECTION
	dateAndTimeLabel.text = [NSString stringWithFormat:@"%@", [storyInfo objectForKey:@"date_and_time"]];
	
	
	//HEADLINE SECTION
	NSString *headlineText = [storyInfo objectForKey:@"headline"];
	CGSize preHeadlineSize = CGSizeMake(300, 175); //enough for like 7 lines
	headlineSize = [headlineText sizeWithFont:[UIFont fontWithName:@"Georgia" size:20.0] constrainedToSize:preHeadlineSize lineBreakMode:UILineBreakModeWordWrap];
	//get current headline height
	headlineOrigin = headlineLabel.frame.origin;
	CGRect headlineFrame = CGRectMake(headlineOrigin.x, headlineOrigin.y, 300, headlineSize.height);
	headlineLabel.frame = headlineFrame;	
	headlineLabel.text = [NSString stringWithFormat:@"%@", headlineText];
	
		
	//SUBHEAD SECTION
	NSObject *subheadObject = [storyInfo objectForKey:@"subhead"];
	if ([subheadObject isKindOfClass:[NSNull class]]) {
		subheadLabel.hidden = YES;
		isThereSubhead = NO;
	}
	else {
		NSString *subheadText = [storyInfo objectForKey:@"subhead"];
		CGSize preSubheadSize = CGSizeMake(300, 150); //enough for a lot
		subheadSize = [subheadText sizeWithFont:[UIFont fontWithName:@"Georgia" size:14.0] constrainedToSize:preSubheadSize lineBreakMode:UILineBreakModeWordWrap];
		//put 2 points btw headline and subhead
		subheadOrigin = CGPointMake(headlineOrigin.x,(headlineOrigin.y + headlineSize.height + 3));
		CGRect subheadFrame = CGRectMake(subheadOrigin.x, subheadOrigin.y, 300, subheadSize.height);
		subheadLabel.frame = subheadFrame;
		subheadLabel.text = [NSString stringWithFormat:@"%@", subheadText];
		
	}
	
	
	//PHOTO/CREDIT SECTION
	NSString *imageURLString = [storyInfo objectForKey:@"photoURL"];
	
	//if there's no photo
	if ([imageURLString length] == 0) {
		storyImageView.hidden = YES;
		photoCreditLabel.hidden = YES;
		isTherePhoto = NO;
	}
	
	//if there is a photo
	else {		
		//set up layout of imageView before running operation
		
		//playing out the difference btw subhead and no subhead
		//w/subhead, add 3 points
		if (isThereSubhead) {
			photoOrigin = CGPointMake(subheadOrigin.x, (subheadOrigin.y + subheadSize.height + 3));
		}
		//w/o subhead, go with headline origin + size + 3
		else {
			photoOrigin = CGPointMake(headlineOrigin.x, (headlineOrigin.y + headlineSize.height + 3));
		}
		
		
		//image loading operation
		NSURL *storyImageURL = [NSURL URLWithString:[storyInfo objectForKey:@"photoURL"]];
		ImageLoadingOperation *operation = [[ImageLoadingOperation alloc] initWithImageURL:storyImageURL target:self action:@selector(didFinishLoadingImageWithResult:)];
		[operationQueue addOperation:operation];
		//START SPINNERS PLEASE!!!
		[operation release];
		
		
		//get the height of the frame, only adjust if there is an image differently sized--NOT SURE IF THIS IS WORKING
//		if ([storyImage isKindOfClass:[UIImage class]]) {
//			photoSize = CGSizeMake(300, [storyImage size].height);
//		}
//		else {
			photoSize = CGSizeMake(300, 240);
		//}
		//sizing the frame
		CGRect imageFrame = CGRectMake(photoOrigin.x, photoOrigin.y, photoSize.width, photoSize.height);
		storyImageView.frame = imageFrame;
		
		
		//photo credit--NEED REAL ONES
		CGRect photoCreditFrame = CGRectMake(photoOrigin.x, (photoOrigin.y + photoSize.height), 300, 13);
		photoCreditLabel.frame = photoCreditFrame;
		
	}
	
	
	
	//BYLINE SECTION--NEED REAL ONES
	//getting byline origin
	if (isTherePhoto && isThereSubhead) {
		bylineOrigin = CGPointMake(photoOrigin.x, (photoOrigin.y + photoSize.height + 22));
	}
	else if (isTherePhoto) {
		bylineOrigin = CGPointMake(photoOrigin.x, (photoOrigin.y + photoSize.height + 22));
	}
	else if (isThereSubhead) {
		bylineOrigin = CGPointMake(subheadOrigin.x, (subheadOrigin.y + subheadSize.height + 6));
	}
	else {
		bylineOrigin = CGPointMake(headlineOrigin.x, (headlineOrigin.y + headlineSize.height + 6));
	}
	
	//for now, don't have real bylines, so don't need to measure sizes NEED LATER
	bylineSize = CGSizeMake(300, 13);
	CGRect bylineFrame = CGRectMake(bylineOrigin.x, bylineOrigin.y, 300, bylineSize.height);
	bylineLabel.frame = bylineFrame;
	
	
	
	//STORY SECTION
	NSString *storyText = [storyInfo objectForKey:@"article_text"];
	CGSize preStoryTextSize = CGSizeMake(300, 50000); //arbitrary, hopefully longer than any story
	storyTextSize = [storyText sizeWithFont:[UIFont fontWithName:@"Helvetica" size:13.0] constrainedToSize:preStoryTextSize lineBreakMode:UILineBreakModeWordWrap];
	storyTextOrigin = CGPointMake(bylineOrigin.x, (bylineOrigin.y + bylineSize.height + 1));
	CGRect storyTextFrame = CGRectMake(storyTextOrigin.x, storyTextOrigin.y, 300, storyTextSize.height);
	storyTextLabel.frame = storyTextFrame;
	storyTextLabel.text = [NSString stringWithFormat:@"%@", storyText];
	
	
	//adjusting scroll view height
	storyScrollView.frame = CGRectMake(0, 0, 320, 416);
	storyScrollView.contentSize = CGSizeMake(320, (storyTextOrigin.y + storyTextSize.height + 10));
	
		
    [super viewDidLoad];
}


-(void) didFinishLoadingImageWithResult:(NSDictionary *)result {
	
	UIImage *storyImage = [result objectForKey:@"image"];
	
	if(storyImage != nil) {
		
		storyImageView.image = storyImage;
		[storyImageView setNeedsDisplay];
	
	}
	
	
}



/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
	
	[storyInfo release];
	[operationQueue release];
	[storyScrollView release];
	[dateAndTimeLabel release];
	[sectionLabel release];
	[headlineLabel release];
	[subheadLabel release];
	[photoCreditLabel release];
	[bylineLabel release];
	[storyTextLabel release];
	[storyImageView release];

    [super dealloc];
}


@end
