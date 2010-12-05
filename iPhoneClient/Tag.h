//
//  Tag.h
//  Caritas
//
//  Created by Engin Kurutepe on 12/4/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>


@interface Tag :  NSManagedObject  
{
}

@property (nonatomic, retain) NSNumber * count;
@property (nonatomic, retain) NSString * tagName;

+ (NSArray*) tagsWithName:(NSString*)name 
   inManagedObjectContext:(NSManagedObjectContext*)context;
+ (Tag*) getOrCreateTagWithName:(NSString*)name
		 inManagedObjectContext:(NSManagedObjectContext*)context;

@property (nonatomic, retain) NSSet* events;

// coalesce these into one @interface Tag (CoreDataGeneratedAccessors) section

- (void)addEventsObject:(Event *)value;
- (void)removeEventsObject:(Event *)value;
- (void)addEvents:(NSSet *)value;
- (void)removeEvents:(NSSet *)value;




@end



