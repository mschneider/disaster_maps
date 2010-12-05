//
//  TagFieldDataSource.m
//  Caritas
//
//  Created by Engin Kurutepe on 12/4/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "TagTableDataSource.h"


@implementation TagTableDataSource

@synthesize managedObjectContext;
@synthesize searchResults;

- (id) initWithManagedObjectContext:(NSManagedObjectContext*)context
{
	if (self = [super init]) {
		managedObjectContext = context;
	}
	
	return self;
}

- (void)dealloc {
	[super dealloc];
}



- (void)search:(NSString*)text {

	

	
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Tag"
											  inManagedObjectContext:self.managedObjectContext];

	[fetchRequest setEntity:entity];
	
	NSPredicate * predicate = [NSPredicate predicateWithFormat:@"tagName CONTAINS[cd] %@", text];
	[fetchRequest setPredicate:predicate];
	
	NSError * error;
	
	self.searchResults = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
	
	if (self.searchResults == nil) {
		NSLog(@"could not execute fetch request for %@", text);
	}
	
	[fetchRequest release];

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"tagCell"];
	
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"tagCell"] autorelease];
	}
	
	cell.textLabel.text = [[self.searchResults objectAtIndex:indexPath.row] tagName];
	
	return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [self.searchResults count];
}
@end
