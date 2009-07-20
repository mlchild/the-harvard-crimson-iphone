//
//  ImageLoadingOperation.m
//  TheHarvardCrimson
//
//  Created by Maxwell Child on 7/14/09.
//  Copyright The Harvard Crimson, Inc. 2009. All rights reserved.
//

#import "ImageLoadingOperation.h"


@implementation ImageLoadingOperation

- (id) initWithImageURL:(NSURL *)theImageURL target:(id)theTarget action:(SEL)theAction {
	
	self = [super init];
	if (self) {
		imageURL = [theImageURL retain];
		target = theTarget;
		action = theAction;		
		
	}
	
	return self;	
}

- (void) main {
	
	//get image synchronously
	NSURL *url = imageURL;
	NSData *imageData = [[NSData alloc] initWithContentsOfURL:imageURL];
	UIImage *image = [[UIImage alloc] initWithData:imageData];
	
	if (image != nil) {
					
		//returning dictionary via threaded function
		NSDictionary *result = [NSDictionary dictionaryWithObjectsAndKeys:image,@"image",imageURL,@"url",nil];
		[target performSelectorOnMainThread:action withObject:result waitUntilDone:NO];
	
	[imageData release];
	[image release];	
	}
}



- (void) dealloc {
	[imageURL release];
	[super dealloc];	
	
}




@end
