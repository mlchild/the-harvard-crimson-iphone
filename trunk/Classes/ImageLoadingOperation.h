//
//  ImageLoadingOperation.h
//  TheHarvardCrimson
//
//  Created by Maxwell Child on 7/14/09.
//  Copyright The Harvard Crimson, Inc. 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageLoadingOperation : NSOperation {
	
	NSURL *imageURL;
	id target;
	SEL action;

}

- (id) initWithImageURL:(NSURL *)imageURL target:(id)target action:(SEL)action;

@end
