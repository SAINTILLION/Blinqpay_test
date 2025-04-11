# Flutter Firebase Posts and Users App

This Flutter app fetches a collection of posts and users from Firebase Firestore and displays them in a list. The posts can be of three types: text, image, or video. The app ensures that videos only play when visible and are paused when they are no longer in view, adhering to performance and UX best practices.

## Approach

### MVVM Architecture and BLoC

The app follows the **MVVM (Model-View-ViewModel)** architecture pattern, which helps separate the business logic from the UI, making the app more maintainable, testable, and scalable.

- **Model**: Represents the data entities (User and Post).
- **View**: Displays the UI elements.
- **ViewModel**: Handles the logic of transforming data into something the view can display. This layer interacts with the Firebase service to fetch posts and users.

For state management, **BLoC** (Business Logic Component) is used, ensuring that the app remains reactive and the UI is updated efficiently whenever the data changes. BLoC helps manage the streams of data from Firebase and provides a clean way to interact with the backend and UI.

## User Interface

The app uses a **clean and minimalistic design**, focusing on the **readability and usability** of the posts and users. The layout is **responsive** and works seamlessly in both **light and dark modes**. Care was taken to ensure the design adapts to different screen sizes to provide a consistent user experience across devices.

## Add Post Screen

To facilitate adding posts, I created a simple **Add Post** screen where users can choose between adding **text**, **image**, or **video** posts. This screen allows users to enter content, upload media (if applicable), and save the post to **Firebase Firestore**.

Post handling logic:
- ✅ If a post contains **only text**:
  - `no_media: true`
  - `video: false`
- 🖼️ If the post contains an **image**:
  - `no_media: false`
  - `video: false`
  - The image is uploaded to **Firebase Storage**, and its URL is stored in Firestore.
- 📹 If the post contains a **video**:
  - `no_media: false`
  - `video: true`
  - The video is uploaded to **Firebase Storage**, and its URL is stored in Firestore.

This screen is used to **populate the `posts` collection** in Firestore dynamically.

## Add User Screen

I also created an **Add User** screen to allow new users to be added to the database. This screen allows users to input basic details such as:
- Full name
- Email
- photo (optional)

User handling:
- The details are saved to the **`users` collection** in Firestore.
- If an avatar is selected, it is uploaded to **Firebase Storage**, and its URL is stored in the user document.

This screen helps populate the **users collection** with dynamic input.

## Testing

- ✅ The **business logic is unit tested**, ensuring that data fetching and processing from Firebase works as expected.
- ✅ The **UI is fully functional and performance-optimized**, especially the **video playback feature**, which ensures:
  - Only one video plays at a time.
  - Videos automatically play when fully visible and pause when out of view.


### Video Playback Optimization

To ensure smooth video playback:
- The video will only play when it becomes fully visible on the screen.
- If the video goes out of view, it is paused.
- Only one video will play at any given time to save resources and improve performance.
### Implemented Light and Dark mode with BloC
### For Bonus, added the Page Transition Animation (SlideTransition and FadeTransition) as well as TweenAnimationBuilder, which applies a slide-in effect where each list item (user tile) slides from the right to its normal position.

### Firebase Firestore and Cloud Storage

During development, I used **dummy data** to simulate the Firebase Firestore collections for posts and users. However, I was unable to access Firebase Cloud Storage due to what I believe are the Firestore and Storage rules not being set up correctly.

To allow access to Firebase Cloud Storage and Firestore, you must modify the Firebase rules as follows:

```json
// Firestore Rules
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read, write: true;
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
      allow read, write: if true;
    }
  }
}

Note: This only for testing purpose.
After which populate the user post and user collection through the Add User Screen and Add Post Screen.
