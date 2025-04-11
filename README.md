# Flutter Firebase Posts and Users App

This Flutter app fetches a collection of posts and users from Firebase Firestore and displays them in a list. The posts can be of three types: text, image, or video. The app ensures that videos only play when visible and are paused when they are no longer in view, adhering to performance and UX best practices.

## Approach

### MVVM Architecture and BLoC

The app follows the **MVVM (Model-View-ViewModel)** architecture pattern, which helps separate the business logic from the UI, making the app more maintainable, testable, and scalable.

- **Model**: Represents the data entities (User and Post).
- **View**: Displays the UI elements.
- **ViewModel**: Handles the logic of transforming data into something the view can display. This layer interacts with the Firebase service to fetch posts and users.

For state management, **BLoC** (Business Logic Component) is used, ensuring that the app remains reactive and the UI is updated efficiently whenever the data changes. BLoC helps manage the streams of data from Firebase and provides a clean way to interact with the backend and UI.

### Video Playback Optimization

To ensure smooth video playback:
- The video will only play when it becomes fully visible on the screen.
- If the video goes out of view, it is paused.
- Only one video will play at any given time to save resources and improve performance.
## Implemented Light and Dark mode with BloC
## For Bonus, added the Page Transition Animation (SlideTransition and FadeTransition) as well as TweenAnimationBuilder, which applies a slide-in effect where each list item (user tile) slides from the right to its normal position.

### Firebase Firestore and Cloud Storage

During development, I used **dummy data** to simulate the Firebase Firestore collections for posts and users. However, I was unable to access Firebase Cloud Storage due to what I believe are the Firestore and Storage rules not being set up correctly.

To allow access to Firebase Cloud Storage and Firestore, you must modify the Firebase rules as follows:

```json
// Firestore Rules
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read, write: if request.auth != null;
    }
    match /posts/{postId} {
      allow read, write: if request.auth != null;
    }
  }
}

// Storage Rules
service firebase.storage {
  match /b/{bucket}/o {
    match /{allPaths=**} {
      allow read, write: if request.auth != null;
    }
  }
}
