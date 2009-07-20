//
//  JSONHelper.h
//  TheHarvardCrimson
//
//  Created by Maxwell Child on 7/13/09.
//  Copyright The Harvard Crimson, Inc. 2009. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface JSONHelper : NSObject {

}

//Returns an dictionary for the appropriate section
//this method is synchronous
+ (NSArray *)fetchStoriesForSection:(NSString *)section;

//perhaps put in special methods for checking update, just pulling down specific parts of the array, etc

@end
