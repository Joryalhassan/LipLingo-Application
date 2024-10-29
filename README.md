# LipLingo

## Overview
**LipLingo** is an Android application designed to translate lip movements into text, supporting users with hearing or voice impairments in better communication. This application allows users to record, upload, and interpret lip movements into text and offers interactive lessons and challenges to learn lip reading. Developed as a graduation project, LipLingo combines deep learning with user-friendly mobile functionality to provide an accessible solution for lip reading and text interpretation.

---

## Project Collaborators
- **Jory Alhassan**
- **Nada AlQabbani**
- **Alanood Abanumy**
- **Adwa Alangari**
- **Danh Alkhalaf**

---

## Tech Stack
- **Front-end:** Flutter
- **Back-end:** Python (Lip Movement Interpretation Model)
- **Database:** Google Firestore

---

## Features and Requirements

### User Management
- **FR1:** User registration with first name, last name, username, email, and password.
- **FR2:** Login using either username or email and password.
- **FR3:** Edit profile details (first name, last name, and email).
- **FR4:** Reset password via email.
- **FR16:** Logout functionality.
- **FR17:** Delete user account.

### Video Recording and Upload
- **FR5:** Upload videos directly from the device's album.
- **FR6:** Record a 1-minute video focusing on the user's face:
  - **FR6.1:** Start recording.
  - **FR6.2:** Stop recording.

### Lip Movement Interpretation
- **FR7:** Interpret lip movements into text using a trained model.
- **FR8:** View and edit the interpreted text:
  - **FR8.1:** Option to manually edit interpreted text if needed.
- **FR9:** Save interpreted text for future reference.
- **FR10:** View a list of saved interpretations.
- **FR11:** Delete specific saved texts.
- **FR12:** Search for specific saved interpretations.
- **FR18:** Clear all saved interpretations.

### Lip Reading Lessons
- **FR13:** Access lip reading lessons:
  - **FR13.1:** View a specific lesson.
  - **FR13.2:** Watch a video lesson for better comprehension.
  - **FR13.3:** Mark a lesson as completed.

### Challenges and Progress
- **FR14:** Participate in engaging lip reading challenges:
  - **FR14.1:** Select the desired challenge level.
  - **FR14.2:** View the challenge video.
  - **FR14.3:** Choose the correct word from three options.
  - **FR14.4:** Select the answer that best matches the video.
  - **FR14.5:** Complete a level after three successful challenges.
  - **FR14.6:** Unlock new levels upon completion.
- **FR15:** Track progress in both lessons and challenges.

---
**Future Enhancements**

- Integrate real-time lip movement recognition.
- Expand the learning module with additional challenges.
- Include multilingual support for diverse user bases.
- Implement analytics to personalize the lip reading experience.

---

## Installation and Setup
To set up and run LipLingo locally, follow these steps:

1. **Clone the repository:**
   ```bash
   git clone https://github.com/yourusername/LipLingo.git
   cd LipLingo
2. **Set up the back-end Python environment:**
Install required packages:
   ```bash
   pip install -r requirements.txt
Configure the lip movement interpretation model.

3. **Set up the Flutter front-end:**
Navigate to the Flutter project directory and install dependencies:
   ```bash
   flutter pub get
   
4. **Configure Firestore:**
Ensure you have a Firestore database set up and configure authentication for Flutter to interact with it.

5. **Run the Application:**
Start the Flutter application on an emulator or a connected device:
  ```bash
   flutter run




