//
//  Event.h
//  Caritas
//
//  Created by Engin Kurutepe on 12/4/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>


@interface Event :  NSManagedObject  
{
}

@property (nonatomic, retain) NSDate * timeStamp;
@property (nonatomic, retain) NSData * photoData;
@property (nonatomic, retain) NSString * descriptionText;
@property (nonatomic, retain) NSString * eventId;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSSet* tags;
@property (nonatomic, retain) NSManagedObject * location;

@property (nonatomic, readonly) double distanceFromCurrentLocation;

+ (Event*) getOrCreateEventWithID:(NSString*)eid
			 inManagedObjectContext:(NSManagedObjectContext*)context;

@end


@interface Event (CoreDataGeneratedAccessors)
- (void)addTagsObject:(NSManagedObject *)value;
- (void)removeTagsObject:(NSManagedObject *)value;
- (void)addTags:(NSSet *)value;
- (void)removeTags:(NSSet *)value;

@end

