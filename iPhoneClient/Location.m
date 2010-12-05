// 
//  Location.m
//  Caritas
//
//  Created by Engin Kurutepe on 12/4/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Location.h"


@implementation Location 

@dynamic lat;
@dynamic lon;
@dynamic alt;

@synthesize location=location_;

- (void) setLocation:(CLLocation *)loc
{
	location_ = loc;
	
	self.lat = [NSNumber numberWithDouble:loc.coordinate.latitude];
	self.lon = [NSNumber numberWithDouble:loc.coordinate.longitude];
	self.alt = [NSNumber numberWithDouble:loc.altitude];	
	
}


- (CLLocationCoordinate2D) coordinate
{
	CLLocationCoordinate2D coord;
	
	coord.latitude = [self.lat doubleValue];
	coord.longitude = [self.lon doubleValue];
	
	return coord;
}



@end
