//
//  AppDelegate.h
//  LandMarker
//
//  Created by David Lathrop on 4/27/15.
//  Copyright (c) 2015 Fry An Egg Technology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <CoreMotion/CMMotionManager.h>
#import <CoreLocation/CLLocationManager.h>
#import <CoreLocation/CLLocationManagerDelegate.h>
#import <CoreLocation/CLHeading.h>
#import <CoreMotion/CMAltimeter.h>

#import "LMManagedDocument.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, CLLocationManagerDelegate> {
    
    CMMotionManager * motionManager;
    NSOperationQueue *motion_opQ;
    CLLocationManager *locationManager;
    CLLocationDirection currentHeading;
    CMAltimeter *altimeter;
    
}

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) NSURL* landmarksDocumentURL;
@property (strong, nonatomic) LMManagedDocument* landmarksDocument;

//@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
//@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
//@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
//- (void)saveContext;
//- (NSURL *)applicationDocumentsDirectory;


@end

