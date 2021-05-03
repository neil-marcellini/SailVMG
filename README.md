# SailVMG
## by Neil Marcellini
SailVMG is an IOS app for recording and displaying VMG while sailing and kiteboarding. SailVMG provides visual and auditory feedback options for presenting VMG in real time, allowing the racing sailor to try new techniques and get instant feedback about their affect on VMG. VMG is the component of your speed in the upwind direction.
<table>
  <tr>
    <td valign="top"><img src="https://i.imgur.com/0F8j3cT.jpg" alt="VMG" width="300"></td>
  </tr>
</table>


To use the app you simply set the wind direction using the in app compass, and start recording your session. By default the audio feedback is turned on, with pitch representing your VMG, and the rate of the pitch playback representing VMG acceleration. Upon returning to shore you can save the track, and see it on a map color coded by VMG. Tracks may be exported as a GPX file. Several stats are also displayed such as date and time, location, duration, and max VMG upwind and downwind.
<table>
  <tr>
    <td valign="top"><img src="https://trello-attachments.s3.amazonaws.com/5f7cd5a14fc57784d6765224/6075dae6ec10c7052439e7d1/e95fd208616d0b0db26db4877f76b73e/IMG_3804.PNG" alt="SailVMG Track List" width="300"></td>
    <td valign="top"><img src="https://trello-attachments.s3.amazonaws.com/5f7cd5a14fc57784d6765224/60873fc1ba127b70dded1100/c786ae7a431feccef90383536ae061ba/Screen_Shot_2021-04-26_at_3.33.27_PM.jpg" alt="TWD Setup" width="300"></td>
  </tr>
   <tr>
    <td valign="top"><img src="https://trello-attachments.s3.amazonaws.com/5f7cd5a14fc57784d6765224/60873fc1ba127b70dded1100/b5e6d189c735093bdf598684bd61fb8d/Screen_Shot_2021-04-26_at_3.35.17_PM.jpg" alt="Recording View" width="300"></td>
    <td valign="top"><img src="https://trello-attachments.s3.amazonaws.com/5f7cd5a14fc57784d6765224/60873fc1ba127b70dded1100/440580dde728cee4f211b8587c5f5134/Screen_Shot_2021-04-26_at_3.37.08_PM.jpg" alt="Playback View" width="300"></td>
  </tr>
</table>

## Current State of the Project
The app is currently in beta testing through TestFlight. If you would like to be a beta tester, please send me an email at neil.marcellini@gmail.com. I hope to publish to the app store soon.

There were many features that I did not have time to implement. I have listed them below with the most important items towards the top. See the [SailVMG Trello board](https://trello.com/invite/b/WmJoCi5W/8df98456dde69a08db6f35635b5fdbfd/sailvmg) for more info.

### To Do
- Delete trackpoints from Firestore when their associated tracks are deleted. This requires setting up a Firebase cloud function to do so.
- Fix a bug where tracks in the list are out of chronological order.
- Switch previews between light mode and dark mode when color scheme changes after a preview has been downloaded.
- Train a ML model to predict the current true wind direction given the last few minutes of a GPS track. Use the predictions to continuously update the TWD. Recently I discovered data from the [34th](https://www.sailyachtresearch.org/resources/34th-americas-cup-liveline/) and [35th](https://sites.google.com/a/acracemgt.com/noticeboard/home/race-data/race-data-csv-files) America's Cup. I extracted the relevant data and uploaded it [here](https://drive.google.com/drive/folders/1sZnhKALoz09RbuvdNJIM0S66InyvjTX_?usp=sharing).
- Add all trackpoint attributes as gpx extensions. Currently VMG and some other trackpoint data is not included in the GPX file. 

## Development Setup
To get setup for development you will need Xcode and git. Next, download the project with the following command.
```
git clone https://github.com/neil-marcellini/SailVMG.git
```
This project uses Cocoapods as well as Swift packages. Before running the project, open up the root "SailVMG" folder in terminal. Run the `pod install` command to install the required Cocoapods. Next, double click the `SailVMG.xcworkspace` file to open the project in Xcode. Select your desired simulator or device and click the play button in the upper lefthand corner to launch the app.
