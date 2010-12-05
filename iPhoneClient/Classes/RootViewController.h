//
//  RootViewController.h
//  Caritas
//
//  Created by Engin Kurutepe on 12/4/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "EventDetailView.h"

@interface RootViewController : UITableViewController <NSFetchedResultsControllerDelegate> {

@private
	NSArray * eventsNearby;
	double eventRadius;
    NSFetchedResultsController *fetchedResultsController_;
    NSManagedObjectContext *managedObjectContext_;
	UIView * changeRadiusView;
}

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;

- (void) sliderDidMove:(id)sender;

@end
