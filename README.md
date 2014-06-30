URLHandler
==========

A small framework that handles url with custom scheme in a clean way

Usage
==========

1. register url handler
   url format should be: scheme://functionname?param1=value1&param2=value2
   and regist like the following
```
    [[URLHandler sharedManager] registerTarget:[yourclass instance]
                                      selector:@selector(functionHandlerName:)
                                 parameterList:@[@"param1", @"param2"]
                                     forScheme:@"scheme"
                                      function:@"functionname"
                                             ];
```
That's it.
