//
//  Location.h
//  Caritas
//
//  Created by Engin Kurutepe on 12/4/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>
#import <MapKit/MapKit.h>

@interface Location :  NSManagedObject <MKAnnotation>
{
	CLLocation * location_;
}

@property (nonatomic, retain) NSNumber * lat;
@property (nonatomic, retain) NSNumber * lon;
@property (nonatomic, retain) NSNumber * alt;

@property (nonatomic, retain) CLLocation * location;

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;


@end



