//
//  CaritasAppDelegate.m
//  Caritas
//
//  Created by Engin Kurutepe on 12/4/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CaritasAppDelegate.h"
#import "RootViewController.h"



@implementation CaritasAppDelegate

@synthesize window;
@synthesize navigationController;
@synthesize location;
@synthesize webservice;


#pragma mark -
#pragma mark Application lifecycle

- (void)awakeFromNib {    
    
    RootViewController *rootViewController = (RootViewController *)[navigationController topViewController];
    rootViewController.managedObjectContext = self.managedObjectContext;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
	self.location = nil;
	
	webservice = [DisasterMapsWebservice sharedInstance];
	webservice.delegate = self;
	
	[webservice getTags];
		
	locationManager = [[CLLocationManager alloc] init];
	locationManager.delegate = self;
	locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
	
	[locationManager startUpdatingLocation];
	EventEntryView * eventEntryView = [[EventEntryView alloc] initWithNibName:nil
																	   bundle:nil];
	

	

    // Add the navigation controller's view to the window and display.
    [self.window addSubview:navigationController.view];
    [self.window makeKeyAndVisible];
	
	[navigationController presentModalViewController:[eventEntryView autorelease] animated:NO];

    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
    [self saveContext];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


/**
 applicationWillTerminate: saves changes in the application's managed object context before the application terminates.
 */
- (void)applicationWillTerminate:(UIApplication *)application {
    [self saveContext];
}


- (void)saveContext {
    
    NSError *error = nil;
	NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
             */
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}    


#pragma mark -
#pragma mark Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *)managedObjectContext {
    
    if (managedObjectContext_ != nil) {
        return managedObjectContext_;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        managedObjectContext_ = [[NSManagedObjectContext alloc] init];
        [managedObjectContext_ setPersistentStoreCoordinator:coordinator];
    }
    return managedObjectContext_;
}


/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created from the application's model.
 */
- (NSManagedObjectModel *)managedObjectModel {
    
    if (managedObjectModel_ != nil) {
        return managedObjectModel_;
    }
    NSString *modelPath = [[NSBundle mainBundle] pathForResource:@"Caritas" ofType:@"momd"];
    NSURL *modelURL = [NSURL fileURLWithPath:modelPath];
    managedObjectModel_ = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];    
    return managedObjectModel_;
}


/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    
    if (persistentStoreCoordinator_ != nil) {
        return persistentStoreCoordinator_;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Caritas.sqlite"];
    
    NSError *error = nil;
    persistentStoreCoordinator_ = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![persistentStoreCoordinator_ addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter: 
         [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return persistentStoreCoordinator_;
}


#pragma mark -
#pragma mark Application's Documents directory

/**
 Returns the URL to the application's Documents directory.
 */
- (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
	[locationManager release];
    [managedObjectContext_ release];
    [managedObjectModel_ release];
    [persistentStoreCoordinator_ release];
    
    [navigationController release];
    [window release];
    [super dealloc];
}

- (void) postEvent:(Event*)event
{
	[self.webservice postEvent:event];
}
#pragma mark -
#pragma mark locationManager Delegate

- (void) locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
	double timeSinceLastUpdate = (lastEventsUpdate_)?-[lastEventsUpdate_ timeIntervalSinceNow]:1000;
	NSLog(@"last events update was %f seconds ago", timeSinceLastUpdate);
	
	if (timeSinceLastUpdate > 600) {
		if (lastEventsUpdate_) {
			[lastEventsUpdate_ release];
		}
		[self.webservice getEventsAround:newLocation withRadius:50];
		lastEventsUpdate_ = [[NSDate date] retain];
	}
	
	
	self.location = newLocation;
}

- (void) locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
	NSLog(@"location manager failed: %@", [error userInfo]);
	self.location = nil;
}



#pragma mark -
#pragma mark DisasterMapsWebserviceDelegate

- (void) disasterMapsWebservice:(DisasterMapsWebservice*)service didGetTags:(NSArray*)tagDicts
{
	NSLog(@"tags: %@", [tagDicts description]);
	
	for (NSDictionary * tagDict in tagDicts) {
		NSString * tagName = [tagDict valueForKey:@"name"];
		NSNumber * count = [tagDict valueForKey:@"count"];
		
		Tag * t = [Tag getOrCreateTagWithName:tagName inManagedObjectContext:self.managedObjectContext];
		
		t.count = count;
		

		

	}
	
	NSError *error = nil;
	[self.managedObjectContext save:&error];
	
	if (error) {
		NSLog(@"could not update Tag!");
		abort();
	}
	
	
}
- (void) disasterMapsWebservice:(DisasterMapsWebservice*)service didGetEvents:(NSArray*)eventDicts 
{
	NSLog(@"events: %@", [eventDicts description]);
	
	for (NSDictionary * eventDict in eventDicts) {
		NSString * eid = [eventDict valueForKey:@"_id"];
		NSString * desc = [eventDict valueForKey:@"description"];
		NSArray * tags = [eventDict valueForKey:@"tags"];
		NSArray * coords = [eventDict valueForKey:@"location"];
		NSString * tit = [eventDict valueForKey:@"title"];
		
		Event * event = [Event getOrCreateEventWithID:eid
							   inManagedObjectContext:self.managedObjectContext];
		
		event.descriptionText = desc;
		for (NSString * tagName in tags) {
			[event addTagsObject:
			 [Tag getOrCreateTagWithName:tagName 
				  inManagedObjectContext:self.managedObjectContext]];
		}
		
		event.title = tit;
		
		CLLocation * eventLoc = [[CLLocation alloc] initWithLatitude:[[coords objectAtIndex:1] doubleValue]
														   longitude:[[coords objectAtIndex:0] doubleValue]];
		
		
		Location * newLoc = [NSEntityDescription
					   insertNewObjectForEntityForName:@"Location"
					   inManagedObjectContext:self.managedObjectContext];
		
		newLoc.location = eventLoc;
		
		
		
		event.location = newLoc;
						  
	}
	
	NSError *error = nil;
	[self.managedObjectContext save:&error];
	
	if (error) {
		NSLog(@"could not update Events!");
		abort();
	}
}
- (void) disasterMapsWebservice:(DisasterMapsWebservice*)service didPostEvent:(Event*)event
{
}
- (void) disasterMapsWebservice:(DisasterMapsWebservice*)service didFailWithError:(NSDictionary*)errorDict
{
	if (errorDict == nil) {
		NSLog(@"very big error. the webservice does not work!");
	}
	
	else {
		NSLog(@"error: %@", [errorDict description]);
	}

}



@end

