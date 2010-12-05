//
//  TagFieldDataSource.h
//  Caritas
//
//  Created by Engin Kurutepe on 12/4/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface TagTableDataSource: NSObject <UITableViewDataSource, UITableViewDelegate> {
	NSManagedObjectContext * managedObjectContext;
	NSArray * searchResults;
}

@property (nonatomic, retain) NSManagedObjectContext * managedObjectContext;
@property (nonatomic, retain) NSArray * searchResults;

- (id) initWithManagedObjectContext:(NSManagedObjectContext*)context;

@end
