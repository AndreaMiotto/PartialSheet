# PartialSheet

A custom SwiftUI modifier to present a Partial Modal Sheet based on his content size.

## iPhone Preview

<img src="https://user-images.githubusercontent.com/11211914/68700576-6c100580-0585-11ea-847b-99f0450311a4.gif" width="250"><img src="https://user-images.githubusercontent.com/11211914/68700574-6c100580-0585-11ea-9727-8a02ec36b118.gif" width="250">

## iPad Preview
<img src="https://user-images.githubusercontent.com/11211914/79673521-af019380-821d-11ea-82f5-49d75e83d7c0.png" width="500">

## Mac Preview
<img src="https://user-images.githubusercontent.com/11211914/79673482-7eb9f500-821d-11ea-93e0-60fc32e554ee.png" width="600">


## Features

#### Availables
- \[x]  Slidable and dismissable with drag gesture
- \[x]  Variable height based on his content
- \[x]  Customizable colors
- \[x] Keyboard compatibility
- \[x]  Landscape compatibility
- \[x]  iOS compatibility
- \[x] iPad compatibility
- \[x] Mac compatibility

#### Nice to have
- \[ ] ScrcrollView and List compatibility: as soon as Apple adds some API to handle better ScrollViews

## Installation

#### Requirements
- iOS 13.0+ / macOS 10.15+
- Xcode 11.2+
- Swift 5+

#### Via Swift Package Manager

In Xcode 11 or grater, in you project, select: `File > Swift Packages > Add Pacakage Dependency`.

In the search bar type **PartialSheet** and when you find the package, with the **next** button you can proceed with the installation.

If you can't find anything in the panel of the Swift Packages you probably haven't added yet your github account.
You can do that under the **Preferences** panel of your Xcode, in the **Accounts** section.

##  How to Use

To use the **Partial Sheet** just attach the new modifier:

```Swift
YourView
.partialSheet(
    presented: Binding<Bool>, 
    backgroundColor: Color = Color.white, 
    handlerBarColor: Color = Color.gray, 
    enableCover: Bool = true, 
    coverColor: Color = Color.black.opacity(0.4), 
    view: @escaping () -> SheetContent) -> some View where SheetContent : View
```

If you want a starting point copy in your ContentView file the following code:

```Swift
import SwiftUI
import PartialSheet

struct ContentView: View {

    @State private var modalPresented: Bool = false
    @State private var longer: Bool = false

    var body: some View {
        NavigationView {

            VStack {
                Text("""
				Hi, this is the Partial Sheet modifier.
				It allows you to dispaly a totally custom sheet with a relative height based on his content.
				In this way the sheet will cover the screen only for the space it will need
				""")
                Spacer()
                Button(action: {
                    self.modalPresented = true
                }, label: {
                    Text("Display the Partial Shehet")
                })
                    .padding()
                Spacer()
            }
            .padding()
            .navigationBarTitle("Partial Sheet")
        }
        .partialSheet(presented: $modalPresented) {
            VStack {
                Group {
                    Text("Settings Panel")
                        .font(.subheadline)
                    Toggle(isOn: self.$longer) {
                        Text("Advanced")
                    }
                    .padding()
                }
                .frame(height: 50)
                if self.longer {
                    VStack {
                        Text("More settings here...")
                    }
                    .frame(height: 200)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
```


