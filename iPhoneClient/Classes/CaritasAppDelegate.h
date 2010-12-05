//
//  CaritasAppDelegate.h
//  Caritas
//
//  Created by Engin Kurutepe on 12/4/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <CoreLocation/CoreLocation.h>
#import "DisasterMapsWebservice.h"

@interface CaritasAppDelegate : NSObject <UIApplicationDelegate, CLLocationManagerDelegate, DisasterMapsWebserviceDelegate> {
    
    UIWindow *window;
    UINavigationController *navigationController;
	CLLocationManager * locationManager;
	CLLocation * location;
	DisasterMapsWebservice * webservice;
	NSDate * lastEventsUpdate_;

@private
    NSManagedObjectContext *managedObjectContext_;
    NSManagedObjectModel *managedObjectModel_;
    NSPersistentStoreCoordinator *persistentStoreCoordinator_;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;
@property (nonatomic, retain) CLLocation * location;
@property (nonatomic, retain, readonly) DisasterMapsWebservice *webservice;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;


- (NSURL *)applicationDocumentsDirectory;
- (void)saveContext;
- (void) postEvent:(Event*)event;
@end

