//
//  StoryTableViewController.m
//  TheHarvardCrimson
//
//  Created by Maxwell Child on 7/12/09.
//  Copyright The Harvard Crimson, Inc. 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StoryTableViewController.h"
#import "JSONHelper.h"
#import "ImageLoadingOperation.h"


@implementation StoryTableViewController

- (id) initWithStyle:(UITableViewStyle)style andTypeString:(NSString *)theTypeString {
	
	if (self = [super initWithStyle:style]) {
		
		// initializing string "tag" so we know what kind of content the table is loading
		typeString = [[NSString alloc] init];
		typeString = theTypeString;
		sectionURLString = [[NSString alloc] init];
		
		//for storing whole article array
		storyDictionary = [[NSMutableDictionary alloc] init];
		
		//for storing story KEYS temporarily (for helping with touches)
		storyIDs = [[NSMutableArray alloc] init];
		
		//for storing elements of table temporarily
		headlines = [[NSMutableArray alloc] init];
		thumbnailURLs = [[NSMutableArray alloc] init];
		textOfArticles = [[NSMutableArray alloc] init];
		
		//operation queue init
		operationQueue = [[NSOperationQueue alloc] init];
		[operationQueue setMaxConcurrentOperationCount:1];
		
		//for use with threading/caching
		cachedImages = [[NSMutableDictionary alloc] init];
				
		//adding the harvard crimson to navbar
		UIImage *crimsonBannerImage = [UIImage imageNamed:@"iphonelogo3.png"];
		UIImageView *crimsonBannerImageView = [[UIImageView alloc] initWithImage:crimsonBannerImage];
		self.navigationItem.titleView = crimsonBannerImageView;
		
		[crimsonBannerImageView release];
	
		
		//for tabitem images and labels
		if (typeString == @"Top News") {
			self.title = @"Top News";
			self.tabBarItem.image = [UIImage imageNamed:@"PLACEHOLDER"];
			sectionURLString = @"news";
		}
		
		if (typeString == @"FlyBy") {
			self.title = @"FlyBy";
			self.tabBarItem.image = [UIImage imageNamed:@"PLACEHOLDER"];
			sectionURLString = @"PLACEHOLDER";
		}
		if (typeString == @"Opinion") {
			self.title = @"Opinion";
			self.tabBarItem.image = [UIImage imageNamed:@"PLACEHOLDER"];
			sectionURLString = @"opinion";
		}
		if (typeString == @"Magazine") {
			self.title = @"FM";
			self.tabBarItem.image = [UIImage imageNamed:@"PLACEHOLDER"];
			sectionURLString = @"fm";
			
			//for back button entitled "magazine"
			UIBarButtonItem *magazineBackButton = [[UIBarButtonItem alloc] initWithTitle:@"Magazine" style:UIBarButtonItemStylePlain target:nil action:nil];
			self.navigationItem.backBarButtonItem = magazineBackButton;
			[magazineBackButton release];
		}
		if (typeString == @"Sports") {
			self.title = @"Sports";
			self.tabBarItem.image = [UIImage imageNamed:@"PLACEHOLDER"];
			sectionURLString = @"sports";
		}
		if (typeString == @"Arts") {
			self.title = @"Arts";
			self.tabBarItem.image = [UIImage imageNamed:@"PLACEHOLDER"];
			sectionURLString = @"arts";
		}
		
		
	}

	return self;
}


- (void) synchronousLoadArticleInfoForTable {
	
	//only load up when table is empty, should probably be adjusted in future use for threaded reloads/hanging onto data, etc.
	if([headlines count] == 0) {
			
		NSArray *storyDownloadArray = [JSONHelper fetchStoriesForSection:sectionURLString];
		
		for(NSDictionary *article in storyDownloadArray) {
			
			//PUT THE KEY IN ARRAY
			NSString *storyID = [article objectForKey:@"id"];
			[storyIDs addObject:storyID];
			
			[storyDictionary setObject:article forKey:storyID];
			
			//get headline, put in array
			NSString *headline = [article objectForKey:@"headline"];
			[headlines addObject:headline];
			
			//get text, put in array
			NSString *articleText = [article objectForKey:@"article_text"];
			[textOfArticles addObject:articleText];
			
			//get thumbnailURL, add to array
			NSString *thumbnailURLString = [article objectForKey:@"thumbnailURL"];
			
			//if there's a thumbnail, put the url in the array
			if (thumbnailURLString != nil) {
				[thumbnailURLs addObject:[NSURL URLWithString:thumbnailURLString]];
				
			}
			//put in a placeholder if there's no thumbnail
			else {
				[thumbnailURLs addObject:@"No Thumbnail"];				
			}
			
		}
		
	}
	
	//finish up operation
	[self performSelectorOnMainThread:@selector(didFinishLoadingArticleInfo)withObject:nil waitUntilDone:NO];
}

- (UIImage *)cachedImageForURL:(NSURL *)url {
	
	id cachedObject = [cachedImages objectForKey:url];
	
	//if there's nothing in the cache, load image via operation
	if (cachedObject == nil) {
		[cachedImages setObject:@"Loading" forKey:url];
		
		//run the op!
		ImageLoadingOperation *operation = [[ImageLoadingOperation alloc] initWithImageURL:url target:self action:@selector(didFinishLoadingImageWithResult:)];
		[operationQueue addOperation:operation];
		[operation release];		
	}
	
	//if it's not nil, but not an image...
	else if(![cachedObject isKindOfClass:[UIImage class]]) {
		//we're already trying to load the image, so nil it out and give it its shot at the operation queue later, when it's free
		cachedObject = nil;
		}
	
	return cachedObject;
}

-(void)didFinishLoadingImageWithResult:(NSDictionary *)result {
	
	NSURL *url = [result objectForKey:@"url"];
	UIImage *image = [result objectForKey:@"image"];
	
	if (image != nil) {
		
		[cachedImages setObject:image forKey:url];
		[self.tableView reloadData];
		
	}
	
}




 - (void)viewDidLoad {
	
	 //thought it would look nice, adjustable
	 self.tableView.rowHeight = 70;
	 
	 //nav bar color
	 UIColor *crimsonLinkColor = [UIColor colorWithRed:.7294 green:.0235 blue:0 alpha:1.0];	
	 self.navigationController.navigationBar.tintColor = crimsonLinkColor;
	 //for the "more" tab
	 self.tabBarController.moreNavigationController.navigationBar.tintColor = crimsonLinkColor;
	 
	 
//	 //wtffff why will this not work--not even WSJ can do it, so w/e
//	 UIImage *crimsonBannerImage = [UIImage imageNamed:@"iphonelogo3.png"];
//	 UIImageView *crimsonBannerImageView = [[UIImageView alloc] initWithImage:crimsonBannerImage];
//	 self.tabBarController.moreNavigationController.navigationItem.titleView = crimsonBannerImageView;
//	 
//	 [crimsonBannerImageView release];
	 
	 
	 [super viewDidLoad];
 
 // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
 // self.navigationItem.rightBarButtonItem = self.editButtonItem;
 }
 


 - (void)viewWillAppear:(BOOL)animated {
	 [super viewWillAppear:animated];
	 
	 [self showLoadingIndicators];
	 [self beginLoadingArticleInfo];
	 
 }
 
- (void) showLoadingIndicators {
	if (!spinner) {
		spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		[spinner startAnimating];
		
		loadingLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		loadingLabel.font = [UIFont systemFontOfSize:20];
		loadingLabel.textColor = [UIColor grayColor];
		loadingLabel.text = @"Loading...";
		[loadingLabel sizeToFit];
		
		static CGFloat bufferWidth = 8.0;
		
		CGFloat totalWidth = spinner.frame.size.width + bufferWidth + loadingLabel.frame.size.width;
		
		CGRect spinnerFrame = spinner.frame;
		spinnerFrame.origin.x = (self.tableView.bounds.size.width - totalWidth)/2.0;
		spinnerFrame.origin.y = (self.tableView.bounds.size.height - spinnerFrame.size.height)/2.0;
		spinner.frame = spinnerFrame;
		[self.tableView addSubview:spinner];
		
		CGRect labelFrame = loadingLabel.frame;
        labelFrame.origin.x = (self.tableView.bounds.size.width - totalWidth) / 2.0 + spinnerFrame.size.width + bufferWidth;
        labelFrame.origin.y = (self.tableView.bounds.size.height - labelFrame.size.height) / 2.0;
        loadingLabel.frame = labelFrame;
        [self.tableView addSubview:loadingLabel];		
		
	}
}

- (void) beginLoadingArticleInfo {
	
	//start up loading operation
	NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(synchronousLoadArticleInfoForTable) object:nil];
	[operationQueue addOperation:operation];
	[operation release];
	
}

- (void) didFinishLoadingArticleInfo {
	
	[self hideLoadingIndicators];
	[self.tableView reloadData];
	[self.tableView flashScrollIndicators]; //hint to user on length of list
	
}

- (void) hideLoadingIndicators {
	if (spinner) {
		[spinner stopAnimating];
		[spinner removeFromSuperview];
		[spinner release];
		spinner = nil;
		
		[loadingLabel removeFromSuperview];
		[loadingLabel release];
		loadingLabel = nil;
		
	}
}

/*
 - (void)viewDidAppear:(BOOL)animated {
 [super viewDidAppear:animated];
 }
 */
/*
 - (void)viewWillDisappear:(BOOL)animated {
 [super viewWillDisappear:animated];
 }
 */
/*
 - (void)viewDidDisappear:(BOOL)animated {
 [super viewDidDisappear:animated];
 }
 */

/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations.
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release anything that can be recreated in viewDidLoad or on demand.
	// e.g. self.myOutlet = nil;
}


#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

		return [headlines count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
		 
	 //THE DRAW BY MYSELF OPTION
	
	static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
    }
	else {
        NSArray *cellSubs = cell.contentView.subviews;
        for (int i = 0 ; i < [cellSubs count] ; i++) {
            [[cellSubs objectAtIndex:i] removeFromSuperview];
		}
	}
	
	//crimson color
	UIColor *crimsonLinkColor = [UIColor colorWithRed:.7294 green:.0235 blue:0 alpha:1.0];		
	
	
	//drawing headline label
	CGSize preHeadlineSize = CGSizeMake(240, 50);
	CGSize headlineSize = [[headlines objectAtIndex:indexPath.row] sizeWithFont:[UIFont fontWithName:@"Georgia-Bold" size:12.0] constrainedToSize:preHeadlineSize lineBreakMode:UILineBreakModeWordWrap];
	CGRect headlineFrame = CGRectMake(75, 5, 240, headlineSize.height);
	UILabel *headlineLabel = [[UILabel alloc] initWithFrame:headlineFrame];
	if ([headlines objectAtIndex:indexPath.row] !=nil) {
		headlineLabel.text = [headlines objectAtIndex:indexPath.row];
	}
	else {
		headlineLabel.text = @"Headline Placeholder Kills 20 in Harvard Square, Witnesses Exclaim Holy F***ing S***!!!";
	}
	headlineLabel.font = [UIFont fontWithName:@"Georgia-Bold" size:12.0];
	headlineLabel.lineBreakMode = UILineBreakModeWordWrap;
	headlineLabel.numberOfLines = 0;
	headlineLabel.textColor = crimsonLinkColor;
	
	
	//drawing lede label
	CGRect ledeFrame = CGRectMake(75, headlineSize.height+6, 240, 61-headlineSize.height);
	UILabel *ledeLabel = [[UILabel alloc] initWithFrame:ledeFrame];
	if ([textOfArticles objectAtIndex:indexPath.row] != nil) {
		ledeLabel.text = [textOfArticles objectAtIndex:indexPath.row];
	}
	else {
		ledeLabel.text = @"Lede placeholder is much longer, as you might expect after such a horrible tragedy, we're all gonna die";
	}
	ledeLabel.font = [UIFont fontWithName:@"Helvetica" size:11.0];
	ledeLabel.numberOfLines = 0;	
	
	
	//drawing imageview
	CGRect thumbnailFrame = CGRectMake(0, 0, 70, 69);
	UIImageView *thumbnailImageView = [[UIImageView alloc] initWithFrame:thumbnailFrame];
	
	//if there's a thumbnail, load it up via operation, if not, throw in the placeholder, (also, there's a second check for success)
	if ([thumbnailURLs objectAtIndex:indexPath.row] != @"No Thumbnail") {
		UIImage *thumbnailImage = [self cachedImageForURL:[thumbnailURLs objectAtIndex:indexPath.row]];
		thumbnailImageView.image = thumbnailImage;
	}
	else {		
		UIImage *thumbnailPlaceholderImage = [UIImage imageNamed:@"thumbnailPlaceholder2.png"];
		thumbnailImageView.image = thumbnailPlaceholderImage;
	}

	
	
	[cell.contentView addSubview:headlineLabel];
	[cell.contentView addSubview:ledeLabel];
	[cell.contentView addSubview:thumbnailImageView];
	
	[thumbnailImageView release];
	[headlineLabel release];
	[ledeLabel release];
	
	 
    return cell;
}




 // Override to support row selection in the table view.
 - (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
 
 // Navigation logic may go here -- for example, create and push another view controller.
	 StoryViewController *storyViewController = [[StoryViewController alloc] initWithNibName:@"StoryViewController" bundle:nil];
	 
	 //setting which article, giving storyviewcontroller the data
	 NSString *storyKey = [storyIDs objectAtIndex:indexPath.row];
	 storyViewController.storyInfo = [storyDictionary objectForKey:storyKey];
	 storyViewController.sectionString = typeString;
	 
	 //hide tab bar
	 storyViewController.hidesBottomBarWhenPushed = YES;
	 
	 [self.navigationController pushViewController:storyViewController animated:YES];
	 [storyViewController release];
 }
 


/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */


/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source.
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }   
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
 }   
 }
 */


/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */


/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */


- (void)dealloc {
	[typeString release];
	[sectionURLString release];
	[storyIDs release];
	[storyDictionary release];
	[headlines release];
	[textOfArticles release];
	[thumbnailURLs release];
	[cachedImages release];
	[operationQueue release];
	
    [super dealloc];
}
@end

