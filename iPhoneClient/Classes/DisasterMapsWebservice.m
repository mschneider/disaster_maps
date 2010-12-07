//
//  DisasterMapsWebservice.m
//  Caritas
//
//  Created by Engin Kurutepe on 12/4/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "DisasterMapsWebservice.h"


static DisasterMapsWebservice *sharedInstance = nil;
static NSString * serviceHost = @"http://192.168.1.110:9292";

@implementation DisasterMapsWebservice

+ (DisasterMapsWebservice*)sharedInstance
{
    @synchronized(self)
    {
        if (sharedInstance == nil)
			sharedInstance = [[DisasterMapsWebservice alloc] init];
    }
    return sharedInstance;
}

+ (id)allocWithZone:(NSZone *)zone {
    @synchronized(self) {
        if (sharedInstance == nil) {
            sharedInstance = [super allocWithZone:zone];
            return sharedInstance;  // assignment and return on first allocation
        }
    }
    return nil; // on subsequent allocation attempts return nil
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (id)retain {
    return self;
}

- (unsigned)retainCount {
    return UINT_MAX;  // denotes an object that cannot be released
}

- (void)release {
    //do nothing
}

- (id)autorelease {
    return self;
}




@synthesize delegate;

- (void) getEventsAround:(CLLocation*)loc withRadius:(double)radius
{
	NSLog(@"getting events around %@", [loc description]);
	
//	NSString * serviceString = [serviceHost 
//								stringByAppendingString:
//								[[NSString stringWithFormat:@"/api/v1/events?within_radius=[[%f,%f],%f]",
//								 loc.coordinate.longitude, 
//								 loc.coordinate.latitude,
//								 radius] stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
//	
	NSString * serviceString = [serviceHost 
								stringByAppendingString:
								[NSString stringWithFormat:@"/api/v1/events"]];
	NSURL * url = [NSURL URLWithString:serviceString];
	
	ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
	request.delegate = self;
	[request startAsynchronous];
	
}
- (void) getTags
{
	
	NSLog(@"requesting tags");
	
	NSString * serviceString = [serviceHost stringByAppendingString:@"/api/v1/tags"];
	NSURL * url = [NSURL URLWithString:serviceString];
	
	ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
	request.delegate = self;
	[request startAsynchronous];
	
	
	
	
}
- (void) postEvent:(Event*)event
{
	NSMutableDictionary * eventDict = [NSMutableDictionary dictionary];
	
	[eventDict setValue:event.title forKey:@"title"];
	[eventDict setValue:event.descriptionText forKey:@"description"];
	
	Location * eventLocation = event.location;
	NSArray * coordArray = [NSArray arrayWithObjects:eventLocation.lon, eventLocation.lat,nil];
	[eventDict setValue:coordArray forKey:@"location"];
	
	NSMutableArray * tagNames = [NSMutableArray array];
	
	for (Tag * t  in event.tags) {
		[tagNames addObject:t.tagName];
	}
	
	[eventDict setValue:tagNames forKey:@"tags"];
	
	if ([event.eventId length] > 1) {
		[eventDict setValue:event.eventId forKey:@"_id"];
	}

	[eventDict setValue:@"/markers/fire.png" forKey:@"marker"];
	
	NSLog(@"my event dict: %@", [eventDict description]);
	
	NSString * eventString = [eventDict JSONRepresentation];
	
	
	NSString * serviceString = [serviceHost 
								stringByAppendingString:
								[NSString stringWithFormat:@"/api/v1/events"]];
	NSURL * url = [NSURL URLWithString:serviceString];
	
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
	request.delegate = self;
	[request setPostBody:[NSData dataWithBytes:[eventString UTF8String]
										length:[eventString length]]];
	[request startAsynchronous];
	
	
}

- (void)requestFinished:(ASIHTTPRequest *)request
{

	
	NSString * func = [[[request.url relativeString] lastPathComponent] stringByDeletingPathExtension];
	NSLog(@"request finished: %@",func);
	if ([func isEqualToString:@"tags"]) {
		[self handleGetTagsResponse:request];
	}		 
	else if ([func hasPrefix:@"events"]) {
		if ([request.requestMethod hasPrefix:@"POST"]) {
			[self handlePostEventResponse:request];	
		}
		else {
			[self handleGetEventsResponse:request];	
		}


	}

	else {
		NSLog(@"RESPONSE TO UNKNOWN REQUEST %@", func);
		return;
	}
	
	
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
	NSError *error = [request error];
	NSLog(@"request failed: %@", [error localizedDescription]);
	
	[self.delegate disasterMapsWebservice:self didFailWithError:nil];
}

- (void) handleGetTagsResponse:(ASIHTTPRequest*)request
{
	NSString *response = [request responseString];
	//	NSLog(@"library response: %@", response);
	
	NSDictionary * responseDict = [response JSONValue];
	NSLog(@"response: %@",[responseDict description]);
	[self.delegate disasterMapsWebservice:self didGetTags:[responseDict valueForKey:@"tags"]];
}
	
- (void) handleGetEventsResponse:(ASIHTTPRequest*)request
{
	NSString *response = [request responseString];
//	NSLog(@"library response: %@", response);
	
	int statusCode = [request responseStatusCode];
	NSString *statusMessage = [request responseStatusMessage];
	
	if (statusCode != 200) {
		NSLog(@"no events found: %@", statusMessage);
		return;
	}
	
	NSDictionary * responseDict = [response JSONValue];
	NSLog(@"response: %@",[responseDict description]);
	[self.delegate disasterMapsWebservice:self didGetEvents:[responseDict valueForKey:@"events"]];

}
		
- (void) handlePostEventResponse:(ASIHTTPRequest*)request
{
	NSLog([request responseString]);
	
	NSDictionary * responseDict = [[request responseString] JSONValue];
	
	
}




@end
