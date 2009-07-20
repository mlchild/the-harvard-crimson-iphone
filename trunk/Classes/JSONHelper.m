//
//  JSONHelper.m
//  TheHarvardCrimson
//
//  Created by Maxwell Child on 7/13/09.
//  Copyright The Harvard Crimson, Inc. 2009. All rights reserved.
//

#import "JSONHelper.h"
#import "JSON.h"

NSString *const CrimsonHostname = @"10.0.0.194:8000";


@implementation JSONHelper

+ (id)fetchJSONValueForURL:(NSURL *)url {

	//gets a json value for requested url using JSON libraries
	NSString *jsonString = [[NSString alloc] initWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
	
	id jsonValue = [jsonString JSONValue];
	
	[jsonString release];

	return jsonValue;
}

+ (NSArray *)fetchStoriesForSection:(NSString *)section {

	//making the url to go fetch
	NSString *urlString = [NSString stringWithFormat:@"http://%@/iphone/%@/", CrimsonHostname, section];
	NSURL *url = [NSURL URLWithString:urlString];
	return [self fetchJSONValueForURL:url];
		
	
}







@end
