<b><h1>Automatic Image Cropper</h1></b>
This is a Flutter app that allows users to upload images and automatically crops them to a square shape. The app uses the Firebase Storage service to store the images and the uCrop library to perform the automatic cropping.

<h2><b>Getting Started</b></h2>
To get started with this app, you'll need to have Flutter and the Firebase CLI installed on your machine.

<h4><b>Clone this repository to your local machine:</h4></b>

git clone https://github.com/VishalVinayRam/ai_image_cropper
Navigate to the project directory:
Install the app dependencies:
flutter pub get
Create a new Firebase project and set up Firebase Storage. You can follow the instructions in the Firebase documentation to do this.

Add the Firebase configuration file to the app. You can download the google-services.json file from the Firebase console and place it in the android/app directory of the app.


<h4><b>Run the app:</h4></b>
flutter run
<h4><b>Using the App</h4></b>
Once the app is running, you can use it to upload images and automatically crop them to a square shape. To upload an image:

Tap the "Upload Image" button on the home screen.

Select an image from your device's gallery or take a new photo.

The app will automatically crop the image to a square shape and display it on the screen.

Tap the "Save" button to save the cropped image to Firebase Storage.

