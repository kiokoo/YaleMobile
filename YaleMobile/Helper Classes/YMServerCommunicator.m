//
//  YMServerCommunicator.m
//  YaleMobile
//
//  Created by Danqing on 12/25/12.
//  Copyright (c) 2012 Danqing Liu. All rights reserved.
//

//  Transloc Yale ID: 128
//  Transloc info: routes, vehicles, arrival-estimates, routes, segments

// http://www.yaledining.org/fasttrack/menus.cfm?mDate=04%2F21%2F2013&location=10&version=2

#import "YMServerCommunicator.h"
#import "TFHpple.h"
#import "TFHppleElement.h"

#import "AFHTTPClient.h"
#import "AFHTTPRequestOperation.h"
#import "MBProgressHUD.h"

static AFHTTPClient *globalHTTPClient = nil;
static BOOL cancel = NO;

@implementation YMServerCommunicator

+ (AFHTTPClient *)getHTTPClient
{
    if (!globalHTTPClient) globalHTTPClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"http://www.yale.edu"]];
    return globalHTTPClient;
}

+ (void)cancelAllHTTPRequests
{
    cancel = YES;
    if (globalHTTPClient) [[globalHTTPClient operationQueue] cancelAllOperations];
}

+ (BOOL)isCanceled
{
    return cancel;
}

+ (void)resetCanceled
{
    cancel = NO;
}
#pragma mark - YaleMobile 2.x JSON APIs

+ (NSArray *)getLocationFromName:(NSString *)name
{
    return nil;
}

+ (void)getGlobalSpecialInfoForController:(UIViewController *)controller usingBlock:(array_block_t)completionBlock
{
    cancel = NO;
    
    AFHTTPClient *client = [YMServerCommunicator getHTTPClient];
    NSMutableURLRequest *request = [client requestWithMethod:@"GET" path:@"http://pantheon.yale.edu/~dl479/yalemobile/special.txt" parameters:nil];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD hideHUDForView:controller.view animated:YES];
        NSString *responseString = operation.responseString;
        NSArray *array = [responseString componentsSeparatedByString:@"|"];
        completionBlock(array);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

    }];

    [[client operationQueue] addOperation:operation];
}

+ (void)getRouteInfoForController:(UIViewController *)controller usingBlock:(array_block_t)completionBlock
{
    cancel = NO;

    AFHTTPClient *client = [YMServerCommunicator getHTTPClient];
    NSMutableURLRequest *request = [client requestWithMethod:@"GET" path:@"http://api.transloc.com/1.2/routes.json?agencies=128" parameters:nil];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD hideHUDForView:controller.view animated:YES];
        NSString *responseString = operation.responseString;
        NSData *jsonData = [responseString dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error;
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error];
        completionBlock([[dict objectForKey:@"data"] objectForKey:@"128"]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:controller.view animated:YES];
        if (!cancel) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connection Error"
                                                            message:@"YaleMobile is unable to reach TransLoc server. Please check your Internet connection and try again."
                                                           delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
    }];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:controller.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"Loading Routes...";
    hud.labelFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:16];
    [[client operationQueue] addOperation:operation];
}

+ (void)getSegmentInfoForController:(UIViewController *)controller andRoutes:(NSString *)routes usingBlock:(dict_block_t)completionBlock
{
    cancel = NO;
    
    AFHTTPClient *client = [YMServerCommunicator getHTTPClient];
    NSMutableURLRequest *request = [client requestWithMethod:@"GET" path:[NSString stringWithFormat:@"http://api.transloc.com/1.2/segments.json?agencies=128%@", routes] parameters:nil];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD hideHUDForView:controller.view animated:YES];
        NSString *responseString = operation.responseString;
        NSData *jsonData = [responseString dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error;
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error];
        completionBlock([dict objectForKey:@"data"]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Segment Failed");
        [MBProgressHUD hideHUDForView:controller.view animated:YES];
        if (!cancel) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connection Error"
                                                            message:@"YaleMobile is unable to reach TransLoc server. Please check your Internet connection and try again."
                                                           delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
    }];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:controller.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"Loading Paths...";
    hud.labelFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:16];
    [[client operationQueue] addOperation:operation];
}

+ (void)getStopInfoForController:(UIViewController *)controller usingBlock:(array_block_t)completionBlock
{
    cancel = NO;
    
    AFHTTPClient *client = [YMServerCommunicator getHTTPClient];
    NSMutableURLRequest *request = [client requestWithMethod:@"GET" path:@"http://api.transloc.com/1.2/stops.json?agencies=128" parameters:nil];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD hideHUDForView:controller.view animated:YES];
        NSString *responseString = operation.responseString;
        NSData *jsonData = [responseString dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error;
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error];
        completionBlock([dict objectForKey:@"data"]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:controller.view animated:YES];
        if (!cancel) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connection Error"
                                                            message:@"YaleMobile is unable to reach TransLoc server. Please check your Internet connection and try again."
                                                           delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
    }];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:controller.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"Loading Stops...";
    hud.labelFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:16];
    [[client operationQueue] addOperation:operation];
}

+ (void)getShuttleInfoForController:(UIViewController *)controller andRoutes:(NSString *)routes usingBlock:(array_block_t)completionBlock
{
    cancel = NO;
    
    AFHTTPClient *client = [YMServerCommunicator getHTTPClient];
    NSMutableURLRequest *request = [client requestWithMethod:@"GET" path:[NSString stringWithFormat:@"http://api.transloc.com/1.2/vehicles.json?agencies=128%@", routes] parameters:nil];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (controller) [MBProgressHUD hideHUDForView:controller.view animated:YES];
        NSString *responseString = operation.responseString;
        NSData *jsonData = [responseString dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error;
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error];
        completionBlock([[dict objectForKey:@"data"] objectForKey:@"128"]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Shuttle Failed");
        if (controller) [MBProgressHUD hideHUDForView:controller.view animated:YES];
        if (!cancel) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connection Error"
                                                            message:@"YaleMobile is unable to reach TransLoc server. Please check your Internet connection and try again."
                                                           delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
        if (!controller) completionBlock(nil);
    }];
    if (controller) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:controller.view animated:YES];
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.labelText = @"Loading Shuttles...";
        hud.labelFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:16];
    }
    [[client operationQueue] addOperation:operation];
}

+ (void)getArrivalEstimateForStop:(NSString *)stop forController:(UIViewController *)controller andRoutes:(NSString *)routes usingBlock:(array_block_t)completionBlock
{
    cancel = NO;

    AFHTTPClient *client = [YMServerCommunicator getHTTPClient];
    NSMutableURLRequest *request = [client requestWithMethod:@"GET" path:[NSString stringWithFormat:@"http://api.transloc.com/1.2/arrival-estimates.json?agencies=128&stops=%@%@", stop, routes] parameters:nil];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD hideHUDForView:controller.view animated:YES];
        NSString *responseString = operation.responseString;
        NSData *jsonData = [responseString dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error;
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error];
        if ([[dict objectForKey:@"data"] count]) completionBlock([[[dict objectForKey:@"data"] objectAtIndex:0] objectForKey:@"arrivals"]);
        else completionBlock(nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:controller.view animated:YES];
        if (!cancel) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connection Error"
                                                            message:@"YaleMobile is unable to reach TransLoc server. Please check your Internet connection and try again."
                                                           delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
    }];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:controller.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    [[client operationQueue] addOperation:operation];
}

+ (void)getLibraryHoursForLocation:(NSString *)location controller:(UIViewController *)controller usingBlock:(array_block_t)completionBlock
{
    cancel = NO;
    
    AFHTTPClient *client = [YMServerCommunicator getHTTPClient];
    NSMutableURLRequest *request = [client requestWithMethod:@"GET" path:[NSString stringWithFormat:@"http://api.libcal.com/api_hours_today.php?iid=457&weeks=18&lid=%@&format=json", location] parameters:nil];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD hideHUDForView:controller.view animated:YES];
        NSString *responseString = operation.responseString;
        NSData *jsonData = [responseString dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error;
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error];
        completionBlock([dict objectForKey:@"locations"]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:controller.view animated:YES];
        if (!cancel) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connection Error"
                                                            message:@"YaleMobile is unable to reach Library Calendar server. Please check your Internet connection and try again."
                                                           delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
    }];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:controller.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"Loading Hours...";
    hud.labelFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:16];
    hud.dimBackground = YES;
    [[client operationQueue] addOperation:operation];
}

+ (void)getAllDiningStatusForController:(UIViewController *)controller usingBlock:(array_block_t)completionBlock
{
    cancel = NO;
    
    AFHTTPClient *client = [YMServerCommunicator getHTTPClient];
    NSMutableURLRequest *request = [client requestWithMethod:@"GET" path:@"http://www.yaledining.org/fasttrack/locations.cfm?version=2" parameters:nil];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD hideHUDForView:controller.view animated:YES];
        NSString *responseString = operation.responseString;
        NSData *jsonData = [responseString dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error;
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error];
        completionBlock([dict objectForKey:@"DATA"]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:controller.view animated:YES];
        if (!cancel) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connection Error"
                                                            message:@"YaleMobile is unable to reach Yale Dining server. Please check your Internet connection and try again."
                                                           delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
    }];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:controller.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"Loading...";
    hud.labelFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:16];
    hud.dimBackground = YES;
    [[client operationQueue] addOperation:operation];
}

+ (void)getDiningDetailForLocation:(NSUInteger)locationID forController:(UIViewController *)controller usingBlock:(array_block_t)completionBlock
{
    cancel = NO;
    //NSURL *url = [NSURL URLWithString:@"http://www.yaledining.org/fasttrack/menus.cfm?mDate=04%2F19%2F2013&location=10&version=2"];
    
    AFHTTPClient *client = [YMServerCommunicator getHTTPClient];
    NSMutableURLRequest *request = [client requestWithMethod:@"GET" path:[NSString stringWithFormat:@"http://www.yaledining.org/fasttrack/menus.cfm?location=%d&version=2", locationID] parameters:nil];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD hideHUDForView:controller.view animated:YES];
        NSString *responseString = operation.responseString;
        NSData *jsonData = [responseString dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error;
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error];
        completionBlock([dict objectForKey:@"DATA"]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:controller.view animated:YES];
        if (!cancel) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connection Error"
                                                            message:@"YaleMobile is unable to reach Yale Dining server. Please check your Internet connection and try again."
                                                           delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
    }];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:controller.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"Loading Menu...";
    hud.labelFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:16];
    hud.dimBackground = YES;
    [[client operationQueue] addOperation:operation];
}

+ (void)getDiningSpecialInfoForController:(UIViewController *)controller usingBlock:(array_block_t)completionBlock
{
    cancel = NO;
    
    AFHTTPClient *client = [YMServerCommunicator getHTTPClient];
    NSMutableURLRequest *request = [client requestWithMethod:@"GET" path:@"http://pantheon.yale.edu/~dl479/yalemobile/dining2.txt" parameters:nil];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD hideHUDForView:controller.view animated:YES];
        NSString *responseString = operation.responseString;
        NSArray *array = [responseString componentsSeparatedByString:@"|"];
        completionBlock(array);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:controller.view animated:YES];
        if (!cancel) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connection Error"
                                                            message:@"YaleMobile is unable to reach Danqing's server. Please check your Internet connection and try again."
                                                           delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
    }];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:controller.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"Loading...";
    hud.labelFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:16];
    hud.dimBackground = YES;
    [[client operationQueue] addOperation:operation];
}

+ (void)getAllLaundryStatusForController:(UIViewController *)controller usingBlock:(array_block_t)completionBlock
{
    cancel = NO;
    
    AFHTTPClient *client = [YMServerCommunicator getHTTPClient];
    NSMutableURLRequest *request = [client requestWithMethod:@"GET" path:@"http://classic.laundryview.com/lvs.php?s=695" parameters:nil];
    NSString *userAgent = @"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_6_8) AppleWebKit/537.13+ (KHTML, like Gecko) Version/5.1.7 Safari/534.57.2";
    [request setValue:userAgent forHTTPHeaderField:@"User-Agent"];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD hideHUDForView:controller.view.window animated:YES];
        NSString *responseString = [[operation.responseString stringByReplacingOccurrencesOfString:@"<span class=\"user-avail\">" withString:@"<td class=\"myclass\">"] stringByReplacingOccurrencesOfString:@"</span>" withString:@"</td>"];;
        if ([responseString rangeOfString:@"DEMO LOCATION"].location != NSNotFound) {
            if (((UITableViewController *)controller).refreshControl) [((UITableViewController *)controller).refreshControl endRefreshing];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Access Denied" message:@"This function is only available for devices with Yale IP addresses. Please connect via either YaleSecure or yale wireless and try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
            return;
        }

        NSData *responseData = [responseString dataUsingEncoding:NSUTF8StringEncoding];
        TFHpple *doc = [[TFHpple alloc] initWithHTMLData:responseData];
        NSArray *parse = [doc searchWithXPathQuery:@"//td[@class='myclass']"];          // data
        //NSArray *parse2 = [doc searchWithXPathQuery:@"//a[@class='a-room']/@href"];     // url
        
        NSMutableArray *roomData = [[NSMutableArray alloc] initWithCapacity:parse.count];
        for (TFHppleElement *e in parse) {
            NSString *string = e.content;
            string = [string stringByReplacingOccurrencesOfString:@"(" withString:@""];
            string = [string stringByReplacingOccurrencesOfString:@" D)" withString:@""];
            NSArray *washerDryer = [string componentsSeparatedByString:@" W / "];
            [roomData addObject:washerDryer];
        }
        
        completionBlock(roomData);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (((UITableViewController *)controller).refreshControl) [((UITableViewController *)controller).refreshControl endRefreshing];
        [MBProgressHUD hideHUDForView:controller.view.window animated:YES];
        if (!cancel) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connection Error"
                                                            message:@"YaleMobile is unable to reach laundry status server. Please check your Internet connection and try again."
                                                           delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
    }];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:controller.view.window animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"Loading...";
    hud.labelFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:16];
    hud.dimBackground = YES;
    [[client operationQueue] addOperation:operation];
}

+ (void)getLaundryStatusForLocation:(NSString *)code forController:(UIViewController *)controller usingBlock:(triple_array_block_t)completionBlock
{
    cancel = NO;
    
    AFHTTPClient *client = [YMServerCommunicator getHTTPClient];
    NSMutableURLRequest *request = [client requestWithMethod:@"GET" path:[NSString stringWithFormat:@"http://classic.laundryview.com/laundry_room.php?view=c&lr=%@", code] parameters:nil];
    NSString *userAgent = @"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_6_8) AppleWebKit/537.13+ (KHTML, like Gecko) Version/5.1.7 Safari/534.57.2";
    [request setValue:userAgent forHTTPHeaderField:@"User-Agent"];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD hideHUDForView:controller.view.window animated:YES];
        
        NSString *responseString = operation.responseString;
        if ([responseString rangeOfString:@"YALE UNIVERSITY"].location == NSNotFound) {
            if (((UITableViewController *)controller).refreshControl) [((UITableViewController *)controller).refreshControl endRefreshing];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Access Denied" message:@"This feature is only available on-campus. Please connect via either YaleSecure or yale wireless." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
            return;
        }
        
        NSData *responseData = [responseString dataUsingEncoding:NSUTF8StringEncoding];
        TFHpple *doc = [[TFHpple alloc] initWithHTMLData:responseData];
        
        NSArray *statuses = [doc searchWithXPathQuery:@"//span[@class='stat']"];
        NSArray *machines = [doc searchWithXPathQuery:@"//div[@class='desc']"];
        
        responseString = [responseString stringByReplacingOccurrencesOfString:@"<span class=\"monitor-types\">WASHERS:</span>" withString:@""];
        responseString = [responseString stringByReplacingOccurrencesOfString:@"<span class=\"monitor-types\">DRYERS:</span>" withString:@""];
        responseString = [responseString stringByReplacingOccurrencesOfString:@" available" withString:@""];
        responseData = [responseString dataUsingEncoding:NSUTF8StringEncoding];
        TFHpple *doc2 = [[TFHpple alloc] initWithHTMLData:responseData];
        NSArray *types = [doc2 searchWithXPathQuery:@"//div[@class='monitor-total']"];
        NSString *raw = ((TFHppleElement *)[types objectAtIndex:0]).content;
        raw = [raw stringByReplacingOccurrencesOfString:@" " withString:@""];
        NSArray *processedTypes = [raw componentsSeparatedByString:@"\n"];
        if (types.count < 1) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connection Error" message:@"An error has occured when retrieving the laundry data. Please check your network connectivity" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
            return;
        }
        
        NSMutableArray *washers = [[[processedTypes objectAtIndex:0] componentsSeparatedByString:@"of"] mutableCopy];
        NSUInteger washerNumbers = [[washers objectAtIndex:1] integerValue];
        NSMutableArray *dryers = [[[processedTypes objectAtIndex:1] componentsSeparatedByString:@"of"] mutableCopy];
        
        NSUInteger washersDown = 0, dryersDown = 0, arrayIndex = 0;
        for (TFHppleElement *string in statuses) {
            if ([string.content rangeOfString:@"out of service"].location != NSNotFound) {
                if (arrayIndex < washerNumbers) {
                    washersDown++;
                    washerNumbers++;
                } else dryersDown++;
            }
            arrayIndex++;
        }
        
        [washers addObject:[NSString stringWithFormat:@"%d", washersDown]];
        [dryers addObject:[NSString stringWithFormat:@"%d", dryersDown]];
        
        // process machine status
        NSMutableArray *machineStatuses = [[NSMutableArray alloc] initWithCapacity:machines.count];
        for (int i = 0; i < machines.count; i++) {
            NSString *machineID = ((TFHppleElement *)[machines objectAtIndex:i]).content;
            NSString *machineStatus = ((TFHppleElement *)[statuses objectAtIndex:i]).content;
            NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:machineStatus, machineID, nil];
            [machineStatuses addObject:dict];
        }
        
        completionBlock(washers, dryers, machineStatuses);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (((UITableViewController *)controller).refreshControl) [((UITableViewController *)controller).refreshControl endRefreshing];
        [MBProgressHUD hideHUDForView:controller.view.window animated:YES];
        if (!cancel) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connection Error"
                                                            message:@"YaleMobile is unable to reach laundry status server. Please check your Internet connection and try again."
                                                           delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
    }];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:controller.view.window animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"Loading...";
    hud.labelFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:16];
    hud.dimBackground = YES;
    [[client operationQueue] addOperation:operation];
}

+ (void)getWeatherForController:(UIViewController *)controller usingBlock:(array_block_t)completionBlock
{
    NSURL *url = ([[NSUserDefaults standardUserDefaults] boolForKey:@"Celsius"]) ? [NSURL URLWithString:@"http://xml.weather.yahoo.com/forecastrss/06511_c.xml"] : [NSURL URLWithString:@"http://xml.weather.yahoo.com/forecastrss/06511_f.xml"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD hideHUDForView:controller.view animated:YES];
        NSString *responseString = operation.responseString;
        NSData *data = [responseString dataUsingEncoding:NSUTF8StringEncoding];

        NSMutableArray *results = [[NSMutableArray alloc] initWithCapacity:6];
        
        // namespace hack in XPathQuery.m line 126.
        TFHpple *doc = [[TFHpple alloc] initWithXMLData:data];
        NSArray *parse = [doc searchWithXPathQuery:@"//yweather:condition"];
        NSArray *parse2 = [doc searchWithXPathQuery:@"//yweather:forecast"];
        NSDictionary *current = ((TFHppleElement *)[parse objectAtIndex:0]).attributes;
        [results addObject:current];
        
        for (TFHppleElement *e in parse2) {
            NSDictionary *info = e.attributes;
            [results addObject:info];
        }
        
        completionBlock(results);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:controller.view animated:YES];
    }];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:controller.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    [operation start];
}


# pragma mark - YaleMobile 1.x HTML Parsing APIs

+ (NSMutableDictionary *)getInformationForPerson:(NSString *)responseString
{
    NSData *data = [responseString dataUsingEncoding:NSUTF8StringEncoding];
    TFHpple *doc = [[TFHpple alloc] initWithHTMLData:data];
    
    NSMutableDictionary *dataDict = [[NSMutableDictionary alloc] init];
    
    NSArray *headers = [doc searchWithXPathQuery:@"//th"];
    NSArray *details = [doc searchWithXPathQuery:@"//td"];
    for (NSUInteger i = 0; i < headers.count; i++) {
        NSString *header = ((TFHppleElement *)[headers objectAtIndex:i]).content;
        NSString *detail;
        
        if ([header rangeOfString:@"Email Address:"].location != NSNotFound ||
            [header rangeOfString:@"Student Address:"].location != NSNotFound ||
            [header rangeOfString:@"US Mailing Address:"].location != NSNotFound ||
            [header rangeOfString:@"Office Address:"].location != NSNotFound) {
            detail = ((TFHppleElement *)((TFHppleElement *)[details objectAtIndex:i]).firstChild).content;
        } else {
            detail = ((TFHppleElement *)[details objectAtIndex:i]).content;
        }

        [dataDict setObject:detail forKey:header];
    }
    
    return dataDict;
}

+ (NSArray *)getPeopleList:(NSString *)responseString
{
    NSData *data = [responseString dataUsingEncoding:NSUTF8StringEncoding];
    TFHpple *doc = [[TFHpple alloc] initWithHTMLData:data];
    NSArray *array = [doc searchWithXPathQuery:@"//ul[@class='indented-list']/li"];
    NSMutableArray *list = [[NSMutableArray alloc] init];
    
    for (NSUInteger i = 0; i < array.count; i++) {
        NSString *name = ((TFHppleElement *)[array objectAtIndex:i]).firstChild.content;
        NSString *link = [@"http://directory.yale.edu/phonebook/" stringByAppendingString:[((TFHppleElement *)[array objectAtIndex:i]).firstChild objectForKey:@"href"]];
        NSString *info = ((TFHppleElement *)[array objectAtIndex:i]).content;
        
        if ([info isEqualToString:@"- ()"]) {
            NSArray *infos = ((TFHppleElement *)[array objectAtIndex:i]).children;
            info = ((TFHppleElement *)[infos objectAtIndex:infos.count-1]).content;
        }
        info = [info stringByReplacingOccurrencesOfString:@"- " withString:@""];
        info = [info stringByReplacingOccurrencesOfString:@"(" withString:@""];
        info = [info stringByReplacingOccurrencesOfString:@")" withString:@""];
        
        NSDictionary *person = [[NSDictionary alloc] initWithObjectsAndKeys:name, @"name", link, @"link", info, @"info", nil];
        [list addObject:person];
    }
    
    return list;
}


@end
