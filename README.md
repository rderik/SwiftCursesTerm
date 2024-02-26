# SwiftCursesTerm

You can use the SwiftcursesTerm library to create text based interfaces for your command-line tools. The library uses C `ncurses(3)` library. Currently the library is a work in progress, so the API might change to prived a more Swifty library.

If you are interested in seeing a full implementation, the following post shows how to build a text-based clock using this library:

[https://rderik.com/blog/building-a-text-based-application-using-swift-and-ncurses/](https://rderik.com/blog/building-a-text-based-application-using-swift-and-ncurses/)

And the code for that application can be found in the following GitHub repository:

[https://github.com/rderik/clock](https://github.com/rderik/clock)

# Using it on your command-line tools


You need to add it as a dependencty to your package manifesto `Package.swift`. For example:

```swift
// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "clock",
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(name: "SwiftCursesTerm", url: "https://github.com/rderik/SwiftCursesTerm.git", from: "0.1.1"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "clock",
            dependencies: ["SwiftCursesTerm"]),
        .testTarget(
            name: "clockTests",
            dependencies: ["clock"]),
    ]
)
```

Check the latest release version at [https://github.com/rderik/SwiftCursesTerm/releases/latest](https://github.com/rderik/SwiftCursesTerm/releases/latest).


Now you can import `SwiftCursesTerm` and use all of its functionality.

#Example usage


Text format:

```swift
import Foundation
import SwiftCursesTerm

var term = SwiftCursesTerm()
term.addStr(content: "Hello, world!", refresh: true)
let green = term.defineColorPair(foreground: CursesColor.white, background: CursesColor.green)
term.setAttributes([TextAttribute.bold, TextAttribute.underline], colorPair: green)
term.addStr(content: "Hello, in Green!", refresh: true)
getch()
term.shutdown()
exit(EXIT_SUCCESS)
```

The `SwiftCursesTerm` object frees memory when it is deinitilized, but if you want to make sure it frees the memory call the function `shutdown()` and it'll close the ncurses session and free any window you created.

Windows

```swift
import Foundation
import SwiftCursesTerm

var term = SwiftCursesTerm()
term.refresh()
var win1 = term.newWindow(height: 20, width: 20, line: 0, column: 0)
var win2 = term.newWindow(height: 20, width: 20, line: 0, column: 21)
term.addStr(window: win1, content: "Hello, world!", refresh: true)
let green = term.defineColorPair(foreground: CursesColor.white, background: CursesColor.green)
term.setWindowColorPair(window: win2, colorPair: green)
term.setAttributes(window: win2, [TextAttribute.dim, TextAttribute.underline], colorPair: green)
term.addStrTo(window: win2, content: "Hello, in Green!", line: 10, column: 0, refresh: true)
getch()
term.shutdown()
exit(EXIT_SUCCESS)
```

Notice that you can call `addStr` to add a String on the current cursor position or call `addStrTo` to move to a position and then add the string.

I encourage you to read the `SwiftCursesTerm.swift` file to view all the available options.

# Contributing

If you want to contribute:

+ Fork the project
+ Create a branch to hold your changes
+ Create a pull request

# Author

Derik Ramirez - [https://rderik.com](https://rderik.com)

# License

This library is under the [MIT Licence][./LICENSE]
