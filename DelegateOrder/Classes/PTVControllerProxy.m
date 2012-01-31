//
//  PTVControllerProxy.m
//  DelegateOrder
//
//  by Joe D'Andrea and Adrian Kosmaczewski
//

#import "PTVControllerProxy.h"

@interface PTVControllerProxy ()

@property (nonatomic, assign) UITableViewController *controller;

- (void)logInvocation:(NSInvocation *)invocation;

@end


@implementation PTVControllerProxy

@synthesize controller = _controller;

#pragma mark - Initializers

+ (id<UITableViewDataSource, UITableViewDelegate>)proxyWithTableViewController:(UITableViewController *)controller
{
    return [[[[self class] alloc] initWithTableViewController:controller] autorelease];
}

- (id)initWithTableViewController:(UITableViewController *)controller
{
    self.controller = controller;
    return self;
}

#pragma mark - NSObject

- (void)dealloc
{
    [_controller release];
    _controller = nil;
    [super dealloc];
}

- (BOOL)isKindOfClass:(Class)aClass;
{
    return [self.controller isKindOfClass:aClass];
}

- (BOOL)conformsToProtocol:(Protocol *)aProtocol;
{
    return [self.controller conformsToProtocol:aProtocol];
}

- (BOOL)respondsToSelector:(SEL)aSelector;
{
    return [self.controller respondsToSelector:aSelector];
}

#pragma mark - NSProxy

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
    if ([self.controller respondsToSelector:aSelector]) 
    {
        return [self.controller methodSignatureForSelector:aSelector];
    }
    else
    {
        return [super methodSignatureForSelector:aSelector];
    }
}

- (void)forwardInvocation:(NSInvocation *)invocation
{
    SEL selector = [invocation selector];
    if ([self.controller respondsToSelector:selector]) 
    {
        [self logInvocation:invocation];
        [invocation setTarget:self.controller];
        [invocation invoke];
    }
}

#pragma mark - Private

- (void)logInvocation:(NSInvocation *)invocation
{
    SEL selector = [invocation selector];
    NSString *currentMethod = NSStringFromSelector(selector);
    NSString *argument = @"";

    NSMethodSignature *methodSignature = [invocation methodSignature];
    NSInteger argCount = [methodSignature numberOfArguments];
    
    // From the documentation: "There are always at least 2 arguments."
    // In our case, the methods we're interested in are delegate methods that
    // take UITableView as a third parameter.
    // We start looking at the 4th parameter (0-based).
    for (NSInteger index = 3; index < argCount; ++index)
    {
        const char *argType = [methodSignature getArgumentTypeAtIndex:index];
        
        // Typically, arguments in the UITableViewDataSource and UITableViewDelegate
        // protocols either take integers or pointers to NSIndexPath instances.
        // We will check the type of the argument and display it accordingly.
        if (strcmp(argType, "@") == 0)
        {
            id object = nil;
            [invocation getArgument:&object atIndex:index];
            if ([object isKindOfClass:[NSIndexPath class]])
            {
                NSIndexPath *indexPath = (NSIndexPath *)object;
                argument = [NSString stringWithFormat:@"{%d, %d}", indexPath.section, indexPath.row];
            }
        }
        else if (strcmp(argType, "i") == 0)
        {
            NSInteger section;
            [invocation getArgument:&section atIndex:index];
            argument = [NSString stringWithFormat:@"%d", section];
        }
    }
    NSLog(@"%@%@", currentMethod, argument);
}

@end
