//
//  AppDelegate.m
//  LandMarker
//
//  Created by David Lathrop on 4/27/15.
//  Copyright (c) 2015 Fry An Egg Technology. All rights reserved.
//

#import "AppDelegate.h"

#import <Parse/Parse.h>

#import "Landmark.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

@synthesize landmarksDocument, landmarksDocumentURL;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // set up motion manager
    motionManager = [[CMMotionManager alloc] init];
    
    // check availability
    if (motionManager.deviceMotionAvailable == NO){
        NSLog(@"motionManager.deviceMotionAvailable == NO");
        
    }
    if (motionManager.gyroAvailable == NO ){
        NSLog(@"motionManager.gyroAvailable == NO");
    }
    
    motion_opQ = [NSOperationQueue currentQueue];
    
    [ self startDeviceMotionUpdates ];
    
    [ self startLocationEvents ];
    
    //[self startAltimeter ];
    
    NSNotificationCenter * nc = [ NSNotificationCenter defaultCenter];
    
    [ nc addObserver:self selector:@selector(addLandmarkNote:) name:@"AddLandmarkNotification" object:nil];
    [ nc addObserver:self selector:@selector(loadLandmarksNote:) name:@"Load_Landmarks_Note" object:nil];
    //[ nc addObserver:self selector:@selector(saveEditUnitNote:) name:@"Save_Edit_Unit_Note" object:nil];
    [ nc addObserver:self selector:@selector(openManagedDocumentNote:) name:@"Open_Managed_Document_Note" object:nil];
    [ nc addObserver:self selector:@selector(createManagedDocumentNote:) name:@"Create_Managed_Document_Note" object:nil];
    [ nc addObserver:self selector:@selector(saveActiveDocumentNote:) name:@"Save_Document_Note" object:nil];
    
    [self setUpFileFolders];
    
    [Parse enableLocalDatastore];
    // Initialize Parse.
    [Parse setApplicationId:@"0A5PJ1DerdD9bROEWG8MhaBDIPD4hehqaCnvm4G5"
                  clientKey:@"VcaoJZlbLjGYi0u3kWczbuEpyQHEff8sUyW4Mlvb"];
    
    // [Optional] Track statistics around application opens.
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    // Register for Push Notitications
    UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert |
                                                    UIUserNotificationTypeBadge |
                                                    UIUserNotificationTypeSound);
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes
                                                                             categories:nil];
    [application registerUserNotificationSettings:settings];
    [application registerForRemoteNotifications];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    //[self saveContext];
}

#pragma mark - Remote Notifications

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // Store the deviceToken in the current installation and save it to Parse.
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    [currentInstallation saveInBackground];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [PFPush handlePush:userInfo];
}

-(void) setUpFileFolders {
    
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * landmarksPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"Landmarks"];
    
    NSError * error;
    if ([fileManager fileExistsAtPath:landmarksPath] == NO) {
        if (! [fileManager createDirectoryAtPath:landmarksPath withIntermediateDirectories:NO attributes:nil error:&error]) {
            NSLog(@"createDirectoryAtPath error: landmarksPath");
        }
    }
    
    NSString * filePath = [landmarksPath stringByAppendingPathComponent:@"FIRST"];
    
    if ([fileManager fileExistsAtPath:filePath]) {
        NSLog(@"fileExistsAtPath");
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Open_Managed_Document_Note" object:@"FIRST" userInfo:nil];
    } else {
        NSLog(@"fileExistsAtPath NOT");
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Create_Managed_Document_Note" object:@"FIRST" userInfo:nil];
    }
}


#pragma mark - Core Data stack obsoleted
/*
@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.fryanegg.LandMarker" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"LandMarker" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"LandMarker.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}
*/


#pragma mark - startDeviceMotionUpdates

-(void) startDeviceMotionUpdates {
    
    //motionManager.deviceMotionUpdateInterval = self.motionInterval;
    
    if (motionManager.deviceMotionAvailable) {
        
        //referenceAttitude = self.deviceMotion.attitude;
        
        CMDeviceMotionHandler motionHandler = ^(CMDeviceMotion  *motionData, NSError *error) {
            
            if (error) { NSLog(@"CMDeviceMotionHandler ERROR"); return;}
            if (!motionData){ NSLog(@"CMDeviceMotionHandler !motionData"); return;}
            
            //[ self motionDataReceived : motionData ];
            
        };
        
        [ motionManager startDeviceMotionUpdatesToQueue:motion_opQ withHandler:motionHandler ];
        
    }
    
}

-(void) stopMotionUpdates {
    
    if ([motionManager isDeviceMotionActive]) {
        [motionManager stopDeviceMotionUpdates];
    }
    
    [altimeter stopRelativeAltitudeUpdates];
}

-(void) startAltimeter {
    
    if([CMAltimeter isRelativeAltitudeAvailable]){
        altimeter = [[CMAltimeter alloc]init];
        [altimeter startRelativeAltitudeUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMAltitudeData *altitudeData, NSError *error) {
            // This now fires properly
            NSString *data = [NSString stringWithFormat:@"Altitude: %f %f", altitudeData.relativeAltitude.floatValue, altitudeData.pressure.floatValue];
            NSTimeInterval currentTime = [ [NSDate date] timeIntervalSinceReferenceDate ];
            NSLog(@"%@ t = %4.2f", data, currentTime);
            //pressure in kilopascals
            // rel alt in meters
            //self.altimeterLabel.text = data;
        }];
        NSLog(@"Started altimeter");
        //self.altimeterLabel.text = @"-\n-";
    } else {
        NSLog(@"Altimeter not available");
    }
    
}

#pragma mark - CMDeviceMotion
#pragma mark - location events

- (void)startLocationEvents {
    
    if (!locationManager) {
        
        locationManager = [[CLLocationManager alloc] init];
        [locationManager setDelegate:self];
        [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
        
        if([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]){
            [locationManager requestWhenInUseAuthorization];
        }else{
            [locationManager startUpdatingLocation];
        }
        // [self.locationManager allowDeferredLocationUpdatesUntilTraveled:(CLLocationDistance)100000     timeout:(NSTimeInterval)100000];
        
        if( [CLLocationManager deferredLocationUpdatesAvailable]) {
            NSLog(@"self.locationManager.deferredLocationUpdatesAvailable");
        } else {
            NSLog(@"NOT self.locationManager.deferredLocationUpdatesAvailable");
        }
    }
    
    if (locationManager.locationServicesEnabled) {
        NSLog(@"self.locationManager.locationServicesEnabled");
    } else {
        NSLog(@"!self.locationManager.locationServicesEnabled (OFF)");
    }
    
    // Start location services to get the true heading.
    //self.locationManager.distanceFilter = 5.0; // 10 meters
    //self.locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
    
    [locationManager startUpdatingLocation];
    //- (void)startMonitoringSignificantLocationChanges
    
    // Start heading updates.
    //if ([CLLocationManager headingAvailable]) {
    //self.locationManager.headingFilter = 5;
    //   [self.locationManager startUpdatingHeading];
    //}
    
}

#pragma mark CLLocation delegate

- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading {
    
    if (newHeading.headingAccuracy < 0)
        return;
    
    // Use the true heading if it is valid.
    CLLocationDirection  theHeading = ((newHeading.trueHeading > 0) ? newHeading.trueHeading : newHeading.magneticHeading);
    
    //NSNumber * headingNumber = [ NSNumber numberWithDouble:theHeading ];
    //self.currentHeading = theHeading;
    
    //self.headingView.heading = theHeading;
    //[ self.headingView setNeedsDisplay ];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    CLLocation *currentLocation = [locations lastObject];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LOCATION_UPDATED_NOTIF" object:currentLocation userInfo:nil];
    
}


- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"CLLocationManager : didFailWithError");
}

-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
        case kCLAuthorizationStatusRestricted:
        case kCLAuthorizationStatusDenied:
        {
            // do some error handling
            NSLog(@"status");
        }
            break;
        default:{
            [locationManager startUpdatingLocation];
        }
            break;
    }
}

#pragma mark - UIManagedDocument

- (NSURL*)localURL {
    
    static NSURL* url = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        url = [[NSFileManager defaultManager]
               URLForDirectory:NSDocumentDirectory
               inDomain:NSUserDomainMask
               appropriateForURL:nil
               create:NO
               error:nil];
    });
    
    return url;
}

- (LMManagedDocument*)createDocumentObject:(NSString*)fileName {
    
    NSDictionary *options;
    
    options = [NSDictionary dictionaryWithObjectsAndKeys: [NSNumber numberWithBool:YES],
               NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES],
               NSInferMappingModelAutomaticallyOption, nil];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString * landmarksPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"Landmarks"];
    NSString * dbPath = [landmarksPath stringByAppendingPathComponent:@"FIRST"];
    
    NSURL * gdbURL = [NSURL fileURLWithPath:dbPath];
    
    landmarksDocumentURL = gdbURL;
    
    LMManagedDocument* document =  [[LMManagedDocument alloc] initWithFileURL:landmarksDocumentURL];
    
    ////if ([[NSFileManager defaultManager] fileExistsAtPath:[url path]]) {
    
    if (document == nil) {
        NSLog(@"document == nil");
    }
    
    //document.undoManager = nil; // no undo
    
    document.persistentStoreOptions = options;
    
    return document;
}

-(void) createManagedDocumentNote :(NSNotification*) notif {
    
    NSString* filename = (NSString*) notif.object;
    // create document
    landmarksDocument  = [self createDocumentObject:filename];
    
    if(!landmarksDocument) {
        NSLog(@"self.motionRecorder.activeFlightDocument == nil, returning");
        return;
    }
    
    // save document
    [ landmarksDocument  saveToURL:self.landmarksDocumentURL forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success) {
        
        if (success == NO) {
            // error handling here
            NSLog(@"removeItemAtURL here");
            // delete any partially saved data
            [[NSFileManager defaultManager] removeItemAtURL:self.landmarksDocumentURL error:nil];
            // and just exit
            return;
        }
        
        NSLog(@"saveToURL success");
        
    }];
    
}

-(void) addLandmarkNote:(NSNotification*)notif {
    
    NSManagedObjectContext *addingContext = landmarksDocument.managedObjectContext;
    
    CLLocation * lastLocation = notif.object;
    
    NSDictionary * dictionary = notif.userInfo;
    
    NSString * string = [dictionary objectForKey:@"name"];
    
    [addingContext performBlockAndWait:^() {
        
        Landmark * landmarkObject = (Landmark *)[NSEntityDescription insertNewObjectForEntityForName:@"Landmark" inManagedObjectContext:addingContext];
        
        landmarkObject.latitude = [NSNumber numberWithDouble: lastLocation.coordinate.latitude];
        landmarkObject.longitude = [NSNumber numberWithDouble: lastLocation.coordinate.longitude];
        landmarkObject.horiz_accuracy = [NSNumber numberWithDouble: lastLocation.horizontalAccuracy];
        landmarkObject.vert_accuracy = [NSNumber numberWithDouble: lastLocation.verticalAccuracy];
        landmarkObject.altitude = [NSNumber numberWithDouble: lastLocation.altitude];
        landmarkObject.speed = [NSNumber numberWithDouble: lastLocation.speed];
        landmarkObject.course = [NSNumber numberWithDouble: lastLocation.course];
        
        landmarkObject.name = string;
        
    }];
    
    NSError *error = nil;
    
    if (![landmarksDocument.managedObjectContext save:&error])
    {
        NSLog(@"Unresolved save error %@, %@", error, [error userInfo]);
        //[ self.fileData setObject:@"error" forKey:document.localizedName ];
    } else {
        NSLog(@"saveContext success");
    }
    
    [self loadLandmarksNote:nil];

}

-(void) loadLandmarksNote :(NSNotification*)notif {
    
    NSArray * lms = [ landmarksDocument fetchLandmarks ];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"LandmarksLoadedNote" object:lms];
    
}


-(void) saveEditUnitNote:(NSNotification*)notif {
    
    //GameUnit * theUnit = (GameUnit*) notif.object;
    
}


-(void) openManagedDocumentNote:(NSNotification*)notif {
    
    NSString* filename = (NSString*) notif.object;
    
    //bLoadingDocument = YES;
    
    landmarksDocument = [self createDocumentObject:filename];
    
    // start the wait indication
    
    [landmarksDocument openWithCompletionHandler:^(BOOL success) {
        
        if (success == NO) {
            NSLog(@"Could not open the file %@ at %@", filename, landmarksDocument.fileURL);
            //[NSException raise:NSGenericException format:@"Could not open the file %@ at %@", selectedFilename, document.fileURL];
        }
        
        // If we have a document, display it.
        if (landmarksDocument != nil) {
            
        }
    }];
}

- (void) saveActiveDocumentNote:(NSNotification*)notif {
    
    NSError *error = nil;
    
    if (landmarksDocument.managedObjectContext != nil) //self.activeFlightDocument
    {
        //if ([document.managedObjectContext hasChanges] ) {
        //    NSLog(@"hasChanges");
        //} else {
        //    NSLog(@"!hasChanges");
        //}
        
        if (![landmarksDocument.managedObjectContext save:&error])
        {
            NSLog(@"Unresolved save error %@, %@", error, [error userInfo]);
            //[ self.fileData setObject:@"error" forKey:document.localizedName ];
        } else {
            //NSLog(@"saveContext success");
            //NSUserDefaults	*application_Defaults = [NSUserDefaults standardUserDefaults];
            //NSString * pilotString = [application_Defaults stringForKey:DEFAULTS_PILOT_NAME];
            //NSString * planeString = [application_Defaults stringForKey:DEFAULTS_PLANE_NAME];
            
            /*if(document.metaData) {
             NSLog(@"we have document.metaData");
             //document.metaData.pilot;
             //document.metaData.plane;
             
             NSNumber * flightLength = [NSNumber numberWithDouble:[document.metaData.stopTime doubleValue] - [document.metaData.startTime  doubleValue]];
             
             [ self.fileData setObject:[NSString stringWithFormat:@"%@ %@ %6.2f",pilotString, planeString, [flightLength floatValue]] forKey:document.localizedName ];
             }
             else {
             NSLog(@"no document.metaData desc-%@", document.description);
             NSNumber * flightLength = [NSNumber numberWithDouble:self.motionRecorder.motionEndTime - self.motionRecorder.motionStartTime ];
             [ self.fileData setObject:[NSString stringWithFormat:@"%@ %@ %6.2f",pilotString, planeString, [flightLength floatValue]] forKey:document.localizedName ];
             }*/
            
            // this is ok for current recording
            //
            // how to for copied document ...
            
            //NSString * string = [ self.fileData objectForKey:document.localizedName ];
            //NSLog(@"string - %@",string);
        }
        
        //NSLog(@"saveContext pre setObject");
        //[[ NSUserDefaults standardUserDefaults ] setObject:self.fileData forKey:DEFAULTS_FILES_DICT ];
        
        
        //[ self.flightDocsController.tableView reloadData ];
    }
    
    //[[ NSNotificationCenter defaultCenter ] postNotificationName:@"reload_tableview_notification" object:nil userInfo:nil];
}

/*
 // extra data for UIManagedDocument subclass, from StackOverflow
 - (BOOL)readAdditionalContentFromURL:(NSURL *)absoluteURL error:(NSError **)error
 {
 NSURL *myURL = [absoluteURL URLByAppendingPathComponent:@"AdditionalInformation.plist"];
 self.extraInfo = [NSDictionary dictionaryWithContentsOfURL:myURL];
 return YES;
 }
 
 - (id)additionalContentForURL:(NSURL *)absoluteURL error:(NSError **)error
 {
 if (!self.extraInfo) {
 return [NSDictionary dictionaryWithObjectsAndKeys: @"Picard", @"Captain", [[NSDate date] description], @"RightNow", nil];
 } else {
 NSMutableDictionary *updatedFriendInfo = [self.extraInfo mutableCopy];
 [updatedFriendInfo setObject:[[NSDate date] description] forKey:@"RightNow"];
 [updatedFriendInfo setObject:@"YES" forKey:@"Updated"];
 
 return updatedFriendInfo;
 }
 }
 
 - (BOOL)writeAdditionalContent:(id)content toURL:(NSURL *)absoluteURL originalContentsURL:(NSURL *)absoluteOriginalContentsURL error:(NSError **)error
 {
 if (content) {
 NSURL *myURL = [absoluteURL URLByAppendingPathComponent:@"AdditionalInformation.plist"];
 [(NSDictionary *)content writeToURL:myURL atomically:NO];
 }
 
 return YES;
 }
 */

@end
