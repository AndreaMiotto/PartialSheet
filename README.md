# PartialSheet

A custom SwiftUI modifier to present a Partial Modal Sheet based on his content size.

<img src="https://user-images.githubusercontent.com/11211914/68591775-c5970800-0491-11ea-8cf9-61746d253902.gif" width="250">

## Features

### Availables
- \[x]  Slidable and dismissable with drag gesture
- \[x]  Variable height based on his content
- \[x]  Customizable colors
- \[x]  iOS compatibility
- \[x]  Landscape compatibility

### Upcoming
- \[ ] iPad compatibility
- \[ ] Mac compatibility

### Nice to have
- \[ ] ScrcrollView and List compatibility: as soon as Apple adds some API to handle better ScrollViews


## Installation

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


