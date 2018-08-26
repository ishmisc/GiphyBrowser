# GiphyBrowser

This is a toy application which allows to browse Giphy https://giphy.com/ trending API endpoint.


This application contains only one dependency: Gifu https://github.com/kaishin/Gifu for GIF presentation. Dependencies are managed with Carthage.

In order to build the app you need:
 
 1. Run `cartage update`.
 2. Add `GiphyApiKey.swift` into `definitions` directory in the project. This file needs to contain only 1 line: `let GiphyAPIKey = "YOUR_GIPHY_API_KEY"` 
 3. Build and run.
