a dynamic layout View Controller which inspired by StoreHouse

```
pod 'CTStoreHouseDynamicLayoutViewController'
```

all you need to do is:
```
CTDynamicLayoutViewController *viewController = [[CTDynamicLayoutViewController alloc] initWithImages:@[
                                                                                                            [UIImage imageNamed:@"test"],
                                                                                                            [UIImage imageNamed:@"test"],
                                                                                                            [UIImage imageNamed:@"test"],
                                                                                                            [UIImage imageNamed:@"test"],
                                                                                                            [UIImage imageNamed:@"test"],
                                                                                                            [UIImage imageNamed:@"test"],
                                                                                                            [UIImage imageNamed:@"test"],
                                                                                                            [UIImage imageNamed:@"test"],
                                                                                                            [UIImage imageNamed:@"test"],
                                                                                                            [UIImage imageNamed:@"test"],
                                                                                                            [UIImage imageNamed:@"test"],
                                                                                                            [UIImage imageNamed:@"test"],
                                                                                                            [UIImage imageNamed:@"test"],
                                                                                                            [UIImage imageNamed:@"test"],
                                                                                                            [UIImage imageNamed:@"test"],
                                                                                                            [UIImage imageNamed:@"test"]
                                                                                                            ]];
[self presentViewController:viewController animated:YES completion:nil];
```

![demo](pics/demo.gif)


