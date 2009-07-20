//
//  StoryTableViewController.h
//  TheHarvardCrimson
//
//  Created by Maxwell Child on 7/12/09.
//  Copyright The Harvard Crimson, Inc. 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StoryViewController.h"

@interface StoryTableViewController : UITableViewController {
	
	//for tab labels, knowing which section we're in
	NSString *typeString;
	//for hitting up the URLs
	NSString *sectionURLString;
	
	//for storing the whole story package
	NSMutableDictionary *storyDictionary;
	
	//for temporary KEY storage
	NSMutableArray *storyIDs;

	//for the elements of the table
	NSMutableArray *headlines;
	NSMutableArray *thumbnailURLs;
	NSMutableArray *textOfArticles;
	
	//use with threading/caching
	NSMutableDictionary *cachedImages;
	NSOperationQueue *operationQueue;
	
	//for threaded loading of stories
	UIActivityIndicatorView *spinner;
	UILabel *loadingLabel;
	
}


- (id) initWithStyle:(UITableViewStyle)style andTypeString:(NSString *)theTypeString;

- (void) beginLoadingArticleInfo;
- (void) synchronousLoadArticleInfoForTable;
- (void) didFinishLoadingArticleInfo;

- (void) showLoadingIndicators;
- (void) hideLoadingIndicators;

//for threaded image loading
- (UIImage *) cachedImageForURL:(NSURL *)url;
- (void) didFinishLoadingImageWithResult:(NSDictionary *)result;

@end
