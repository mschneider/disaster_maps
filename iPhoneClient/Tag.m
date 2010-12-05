// 
//  Tag.m
//  Caritas
//
//  Created by Engin Kurutepe on 12/4/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Tag.h"


@implementation Tag 

@dynamic tagName;
@dynamic count;

+ (NSArray*) tagsWithName:(NSString*)text
   inManagedObjectContext:(NSManagedObjectContext*)context
{
	

	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Tag"
											  inManagedObjectContext:context];
	
	[fetchRequest setEntity:entity];
	
	NSPredicate * predicate = [NSPredicate predicateWithFormat:@"tagName CONTAINS[cd] %@", text];
	[fetchRequest setPredicate:predicate];
	
	NSError * error;
	
	NSArray * tags = [context executeFetchRequest:fetchRequest error:&error];
	[fetchRequest release];
	
	if (tags == nil) {
		NSLog(@"could not execute fetch request for %@", text);
	}
	return tags;

}

+ (Tag*) getOrCreateTagWithName:(NSString*)name
		 inManagedObjectContext:(NSManagedObjectContext*)context
{
	NSArray * tags = [self tagsWithName:name
				 inManagedObjectContext:context];

	if ([tags count] > 0) {
		return [tags lastObject];
	}
	else {

		Tag* newTag = [NSEntityDescription
					   insertNewObjectForEntityForName:@"Tag"
					   inManagedObjectContext:context];
		
		newTag.tagName = name;
		
		
		NSError *error = nil;
		[context save:&error];
		
		if (error) {
			NSLog(@"could not create Tag!");
			abort();
		}
		
		return newTag;
	}
	
}


@end
