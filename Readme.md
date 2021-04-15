## EveryLifeCare

Sample application showing Local storage first data storage

### Design and considerations

1. The application is written with SwiftUI and Combine
2. Works on iOS 14+ devices
3. Architecture written using MVVM, along with additional classes for network and database classes, a builder object is used to build the view model from the other components
4. Local storage is provided via a SQLite database, access for the app is provided by the GRDB Library

### Data storage 

There were numerous other choices I could have made for the local storage option 

1. Core Data - I chose not to go with this just now due to time constraints, although Apple have made this very clean to use if you do not mind having fetch logic within you SwiftUI views, I do not feel like this is a clean approach to using Core Data with SwiftUI, to abstract this out of the views involves a fair amount of work
2. Realm - Very good local storage option, but prevents us from using plain structs for our data models and still requires @objc properties

Based on these I choose GRDB having previously used FMDB for SQLite, GRDB integrates very well and gives use direct access to use Combine out the box.

### Demo of the app in action

Within the root project structure I have included a folder (Diagram And videos showing functionality) that contains 2 videos and also a flow diagram showing the flow through the app

EveryLifeCareInitialStart.mov Shows the loading banner and also the error banner working on first start of the app, followed by allowing the app to download the data

EveryLifeCareSecondRunWithNoConnection.mov Shows the app where Tasks have been downloaded previously and the user then gets a network error

These were simulated using the Network Link Conditioner tool to simulate a network that has 100% packet loss

EveryLifeCare.pdf is a diagram showing the flow through the application