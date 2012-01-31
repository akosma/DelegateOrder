//
//  PTVControllerProxy.h
//  DelegateOrder
//
//  by Joe D'Andrea and Adrian Kosmaczewski
//

#import <Foundation/Foundation.h>

/*!
    @class       PTVControllerProxy 
    @superclass  NSProxy
    @abstract    This class is a proxy that can pose as a UITableViewController instance.
    @discussion  This class uses the Objective-C runtime introspection mechanism
                 to output the individual invocations of delegate and datasource
                 methods.
 
                 This code is adapted from 
                 http://blog.jayway.com/2009/03/06/proxy-based-aop-for-cocoa-touch/

*/
@interface PTVControllerProxy : NSProxy 

+ (id<UITableViewDataSource, UITableViewDelegate>)proxyWithTableViewController:(UITableViewController *)controller;
- (id)initWithTableViewController:(UITableViewController *)controller;

@end
