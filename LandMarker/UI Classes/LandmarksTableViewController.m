//
//  LandmarksTableViewController.m
//  LandMarker
//
//  Created by David Lathrop on 4/27/15.
//  Copyright (c) 2015 Fry An Egg Technology. All rights reserved.
//

#import "LandmarksTableViewController.h"

#import "Landmark.h"


@interface LandmarksTableViewController ()

@end

@implementation LandmarksTableViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    NSNotificationCenter * nc = [ NSNotificationCenter defaultCenter];
    
    [ nc addObserver:self selector:@selector(landmarksLoadedNote:) name:@"LandmarksLoadedNote" object:nil];
    
    [nc postNotificationName:@"Load_Landmarks_Note" object:nil userInfo:nil];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    //PFObject *testObject = [PFObject objectWithClassName:@"TestObject"];
    //testObject[@"foo"] = @"bar";
    //[testObject saveInBackground];
    currentUser = [PFUser currentUser];
    
    if (!currentUser) { // No user logged in
        // Create the log in view controller
        PFLogInViewController *logInViewController = [[PFLogInViewController alloc] init];
        [logInViewController setDelegate:self]; // Set ourselves as the delegate
        
        // Create the sign up view controller
        PFSignUpViewController *signUpViewController = [[PFSignUpViewController alloc] init];
        [signUpViewController setDelegate:self]; // Set ourselves as the delegate
        
        // Assign our sign up controller to be displayed from the login controller
        [logInViewController setSignUpController:signUpViewController];
        
        // Present the log in view controller
        [self presentViewController:logInViewController animated:YES completion:NULL];
    }
    else {
        NSLog(@"user logged in %@",  currentUser.username);
       
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) landmarksLoadedNote : (NSNotification *) notif {
    
    landmarks = notif.object;
    
    [self.tableView reloadData];
    
}

#pragma mark - PFLogInViewControllerDelegate

- (BOOL)logInViewController:(PFLogInViewController *)logInController
                    shouldBeginLogInWithUsername:(NSString *)username
                    password:(NSString *)password {
    if (username && password && username.length && password.length) {
        return YES; // Begin login process
    }
    
    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Missing Information", nil) message:NSLocalizedString(@"Make sure you fill out all of the information!", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
    return NO; // Interrupt login process
}

- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user {
   
    [self dismissViewControllerAnimated:YES completion:NULL];
    
}

//- (void)logInViewController:(PFLogInViewController *)logInController
//    didFailToLogInWithError:(PFUI_NULLABLE NSError *)error {
    
//}

- (void)logInViewControllerDidCancelLogIn:(PFLogInViewController *)logInController {
    NSLog(@"logInViewControllerDidCancelLogIn");
}

#pragma mark - PFSignUpViewControllerDelegate

// Sent to the delegate to determine whether the sign up request should be submitted to the server.
- (BOOL)signUpViewController:(PFSignUpViewController *)signUpController shouldBeginSignUp:(NSDictionary *)info {
    
    BOOL informationComplete = YES;
    
    // loop through all of the submitted data
    for (id key in info) {
        NSString *field = [info objectForKey:key];
        if (!field || field.length == 0) { // check completion
            informationComplete = NO;
            break;
        }
    }
    
    // Display an alert if a field wasn't completed
    if (!informationComplete) {
        [[[UIAlertView alloc] initWithTitle:@"Missing Information"
                                    message:@"Make sure you fill out all of the information!"
                                   delegate:nil
                          cancelButtonTitle:@"ok"
                          otherButtonTitles:nil] show];
    }
    
    return informationComplete;
}

// Sent to the delegate when a PFUser is signed up.
- (void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user {
    [self dismissModalViewControllerAnimated:YES]; // Dismiss the PFSignUpViewController
}

// Sent to the delegate when the sign up attempt fails.
- (void)signUpViewController:(PFSignUpViewController *)signUpController didFailToSignUpWithError:(NSError *)error {
    NSLog(@"Failed to sign up...");
}

// Sent to the delegate when the sign up screen is dismissed.
- (void)signUpViewControllerDidCancelSignUp:(PFSignUpViewController *)signUpController {
    NSLog(@"User dismissed the signUpViewController");
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return landmarks.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LandmarkCell" forIndexPath:indexPath];
    
    Landmark * landmark = [landmarks objectAtIndex:indexPath.row];
    
    cell.textLabel.text = landmark.name;
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - SearchBarDelegate

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    NSLog(@"searchBarTextDidEndEditing");
}


#pragma mark - UISearchDisplayController Delegate Methods
/*
 - (BOOL)searchDisplayController:(UISearchDisplayController *)controller
 shouldReloadTableForSearchString:(NSString*)searchString
 {
 NSString *scope;
 
 NSInteger selectedScopeButtonIndex = [self.searchDisplayController.searchBar selectedScopeButtonIndex];
 if (selectedScopeButtonIndex > 0)
 {
 scope = [[APLProduct deviceTypeNames] objectAtIndex:(selectedScopeButtonIndex - 1)];
 }
 
 [self updateFilteredContentForProductName:searchString type:scope];
 
 // Return YES to cause the search result table view to be reloaded.
 return YES;
 }
 */

-(BOOL)searchDisplayController:(UISearchController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    
    NSLog(@"shouldReloadTableForSearchString - %@", searchString);
    
    //[self filterContentForSearchText:searchString
     //                          scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
     //                                 objectAtIndex:[self.searchDisplayController.searchBar
     //                                                selectedScopeButtonIndex]]];
    
    return YES;
}

- (BOOL)searchDisplayController:(UISearchController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    
    //peopleSearchResults = [NSArray array];
    
    [self.searchDisplayController.searchResultsTableView reloadData];
    
    [self.searchDisplayController.searchBar becomeFirstResponder];
    
    
    // clear search results ....
    
    /* NSString *searchString = [self.searchDisplayController.searchBar text];
     NSString *scope;
     
     if (searchOption > 0)
     {
     scope = [[APLProduct deviceTypeNames] objectAtIndex:(searchOption - 1)];
     }
     
     [self updateFilteredContentForProductName:searchString type:scope];
     */
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}


@end
