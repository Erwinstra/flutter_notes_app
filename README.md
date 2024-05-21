# Flutter Notes App

This is a Flutter notes app designed to help users create, manage, and store their notes. The app integrates Firebase for user authentication, cloud storage, and analytics, and uses _`sqflite`_ for local offline storage. The _`path_provider`_ and _`path`_ packages are used for file system access.

## Features

- **User Authentication**: Uses _`firebase_auth`_ to authenticate users via email and password.
- **Cloud Storage**: Stores and retrieves notes from Firestore using _`cloud_firestore`_, enabling access from any device.
- **Offline Access**: Utilizes _`sqflite`_ for local storage, ensuring users can access their notes even without an internet connection.
- **File System Access**: Uses _`path_provider`_ and _`path`_ to manage file system paths for storing local data.

## Screenshots

## Learning Objectives

- Implementing user authentication using _`firebase_auth`_.
- Storing and retrieving data from Firestore using _`cloud_firestore`_.
- Managing offline data storage with _`sqflite`_.
- Accessing and managing file system paths using _`path_provider`_ and _`path`_.
