<p align="center">
  <img width="150" src="https://user-images.githubusercontent.com/11211914/80854827-92824400-8c7e-11ea-898f-7232aaaf69ed.png">
</p>
<p align="center">
     <img src="https://img.shields.io/github/license/AndreaMiotto/PartialSheet">
    <img src="https://img.shields.io/github/v/release/andreamiotto/PartialSheet">
    <img src="https://img.shields.io/github/stars/andreamiotto/PartialSheet">
    <img src="https://img.shields.io/github/last-commit/AndreaMiotto/PartialSheet">
</p>

# PartialSheet

A custom SwiftUI modifier to present a Partial Modal Sheet based on his content size.

**Version 3.0 has been released, there are a lot of breaking changes, make sure to read the guide before update!**

## Index

- [Features](#features)
- [Version 3](#version-3)
- [Installation](#installation)
- [How To Use](#how-to-use)
- [Wiki - Full Guide](https://github.com/AndreaMiotto/PartialSheet/wiki)
- [Version 2](#version-2)


## iPhone Preview

| Dynamic Height | Scrollable Content | Pickers Compatible
--|--|--
<video src="https://user-images.githubusercontent.com/11211914/156180442-0f17b29a-8a7f-4655-a74b-9ef8c58f5b7c.mov">|<video src="https://user-images.githubusercontent.com/11211914/156180453-eaebb944-14d9-4994-b4d2-2adb45e1e136.mov">|<video src="https://user-images.githubusercontent.com/11211914/156180464-52cf9a21-e892-4e1e-bfde-a36d3324977b.mov">

## iPad & Mac Preview
  
iPad Version | Mac Version
--|--
<img src="https://user-images.githubusercontent.com/11211914/79673521-af019380-821d-11ea-82f5-49d75e83d7c0.png" width="500"> | <img src="https://user-images.githubusercontent.com/11211914/79673482-7eb9f500-821d-11ea-93e0-60fc32e554ee.png" width="600">


## Features

#### Availables
- \[x] Slidable and dismissable with drag gesture
- \[x] Variable height based on his content
- \[x] Allow scrollable contents
- \[x] Compatible with pickers
- \[x] Customizable colors
- \[x] Keyboard compatibility
- \[x] Landscape compatibility
- \[x] iOS compatibility
- \[x] iPad compatibility
- \[x] Mac compatibility

#### Nice to have
At the moment we developed all the most requested features, feel free to open an issue if you feel something is missing.

## Version 3
The new version brings a lot of breaking changes and a lot of improvments:
- A more **SwiftUI way** to call the PartialSheet.
- Add support to **scrollable content**.
- Add support to **Material** effect.
- A new **Button** to avoid the *rage tapping*.
- More Support for the pickers.

## Installation

#### Requirements
- iOS 15.0+ / macOS 12.0+
- Xcode 13+
- Swift 5+

#### Via Swift Package Manager

In Xcode 13 or grater, in you project, select: `File > Add Pacakages`.

In the search bar type **PartialSheet** and when you find the package, with the **next** button you can proceed with the installation.

If you can't find anything in the panel of the Swift Packages you probably haven't added yet your github account.
You can do that under the **Preferences** panel of your Xcode, in the **Accounts** section.

##  How to Use

*You can read more on the [wiki - full guide](https://github.com/AndreaMiotto/PartialSheet/wiki).*

To use the **Partial Sheet** you need to follow just two simple steps

1. Attach the **Partial Sheet** instance to your Root View in you
```Swift
rootView.attachPartialSheetToRoot()
```
2. Then in any view on the hierarchy you can use:

```Swift
view
    .partialSheet(isPresented: $isPresented) {
        Text("Content of the Sheet")
     }
```

You can also use the **PSButton** to avoid the rage tapping:
```Swift
PSButton(
    isPresenting: $isSheetPresented,
    label: {
        Text("Display the Partial Sheet")
    })
```

Remember to always add `import PartialSheet` in every file you want to use the PartialSheet.

In the **Example** directory you can find more runnable examples with more complex structures.

## Version 2
The new version brings a lot of new features and improvements, but for now I had to drop the compatibility with iOS systems before the 15.0. If you need you can still use the version 2 pointing to the correct tag in the Package Manager.
