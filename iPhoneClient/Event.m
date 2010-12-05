// 
//  Event.m
//  Caritas
//
//  Created by Engin Kurutepe on 12/4/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Event.h"


@implementation Event 

@dynamic timeStamp;
@dynamic photoData;
@dynamic descriptionText;
@dynamic tags;
@dynamic location;
@dynamic eventId;
@dynamic title;


+ (Event*) getOrCreateEventWithID:(NSString*)eid
		   inManagedObjectContext:(NSManagedObjectContext*)context
{
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Event"
											  inManagedObjectContext:context];
	
	[fetchRequest setEntity:entity];
	
	NSPredicate * predicate = [NSPredicate predicateWithFormat:@"eventId LIKE[cd] %@", eid];
	[fetchRequest setPredicate:predicate];
	
	NSError * error;
	
	NSArray * events = [context executeFetchRequest:fetchRequest error:&error];
	[fetchRequest release];
	
	if( [events count] == 0 )
	{
		Event * newEvent = [NSEntityDescription
							insertNewObjectForEntityForName:@"Event"
							inManagedObjectContext:context];
		
		newEvent.eventId = eid;
		
		
		NSError *error = nil;
		[context save:&error];
		
		if (error) {
			NSLog(@"could not create Event!");
			abort();
		}
		
		return newEvent;
		
	}
	else {
		return [events lastObject];
	}

}
-(double) distanceFromCurrentLocation
{
	CaritasAppDelegate * delegate = [[UIApplication sharedApplication] delegate];
	
	CLLocation * currentLoc = [delegate location];
	double distance = [currentLoc distanceFromLocation:[self.location location]];
	NSLog(@"distance: %f",distance);
	return distance;
	
}

@end
