//
//  DisasterMapsWebservice.h
//  Caritas
//
//  Created by Engin Kurutepe on 12/4/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+SBJSON.h"
#import "NSString+SBJSON.h"
#import "NSString+MD5.h"
#import "NSData+Base64.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "Event.h"

// Temporary IP URL:
// 

@class DisasterMapsWebservice;

@protocol DisasterMapsWebserviceDelegate

- (void) disasterMapsWebservice:(DisasterMapsWebservice*)service didGetTags:(NSArray*)tagDicts;
- (void) disasterMapsWebservice:(DisasterMapsWebservice*)service didGetEvents:(NSArray*)eventDicts;
- (void) disasterMapsWebservice:(DisasterMapsWebservice*)service didPostEvent:(Event*)event;
- (void) disasterMapsWebservice:(DisasterMapsWebservice*)service didFailWithError:(NSDictionary*)errorDict;

@end


@interface DisasterMapsWebservice : NSObject {

	id <DisasterMapsWebserviceDelegate> delegate;
	
	
}

@property (nonatomic, assign) id <DisasterMapsWebserviceDelegate> delegate;

+ (DisasterMapsWebservice*)sharedInstance;

- (void) getEventsAround:(CLLocation*)loc withRadius:(double)radius;
- (void) getTags;
- (void) postEvent:(Event*)event;

- (void) handleGetTagsResponse:(ASIHTTPRequest*)request;
- (void) handleGetEventsResponse:(ASIHTTPRequest*)request;
- (void) handlePostEventResponse:(ASIHTTPRequest*)request;

@end
