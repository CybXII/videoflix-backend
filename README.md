Hi there 👋
This is a Developer Akademie Group Work For the Videoflix App Portfolio Example 🍿🍿🍿

🎬 Videoflix 🍿
Welcome to Videoflix, a Netflix-inspired video streaming platform! This project is developed by Lukas, Alex, and Benjamin as part of our intensive full-stack developer training. We're using Angular 18 for the frontend and Django & Django Rest Framework for the backend, with a PostgreSQL database. The platform enables users to register, explore a video library, and stream videos with various quality options.

🚀 Project Overview
Videoflix aims to recreate the core features of popular streaming services with a focus on clean code, responsive design, and scalable architecture. Our goal is to deliver an intuitive and efficient user experience for managing and watching video content.

🔧 Tech Stack
Frontend: Angular 18
Backend: Django & Django Rest Framework
Database: PostgreSQL
Caching Layer: Redis
Background Task Runner: Django RQ or Celery
📋 Checklist - Definition of Done (DoD)
Ensure Clean Code principles are followed
Functions are no longer than 14 lines
Each function performs one clear task
All function and variable names follow the snake_case convention
No unused variables or functions
All commented-out code has been removed
📑 Documentation
Documentation is present
A clear and concise README.md file exists
🛠️ Django-Specific Requirements
Views that return HTTP responses are in views.py
Helper functions are located in functions.py or utils.py
Unit tests are written, and there is at least 70% test coverage (use Django Nose)
Code is PEP-8 compliant
🖥️ Technical Requirements
Backend and frontend are separated, communicating via a REST API
PostgreSQL is used as the database
Redis is set up as the caching layer
Host the backend on a V-Server
Ensure at least 80% test coverage for the backend
The user interface is responsive across all screen sizes
📜 Functional Requirements
1. User Registration
Users can register with an email and password
A confirmation email is sent after registration
Accounts must be activated before login
General error messages are displayed for invalid input
2. User Login & Logout
Registered users can log in with their email and password
Error messages are kept general to maintain security
Users can reset their password via a "Forgot Password" option
Users can log out securely
3. Video Dashboard
A dashboard displays a hero section with a featured video teaser
Videos are grouped by genre
Each video is displayed with a thumbnail and title
4. Video Playback
Video quality is automatically adjusted based on device and connection
Users can manually choose resolutions (120p, 360p, 720p, 1080p)
Basic controls: play, pause, forward, rewind, and full-screen
5. Progress Tracking
Playback progress is automatically saved
Users are prompted to continue where they left off for partially watched videos
6. Legal Information
There are easily accessible links to the privacy policy and imprint in the footer
⚡ Other Features
Background tasks are handled with Django RQ or Celery
We use Redis as a caching layer for faster performance
💻 Developer Instructions
Follow the steps below to set up the project:

Clone the repository: git clone https://github.com/videoflix/videoflix-app.git
Navigate to the backend directory: cd backend
Create a virtual environment and install dependencies: pip install -r requirements.txt
Run database migrations: python manage.py migrate
Start the backend server: python manage.py runserver
Navigate to the frontend directory: cd ../frontend
Install frontend dependencies: npm install
Start the Angular frontend: ng serve
🧪 Testing
We have implemented unit tests for the backend, with at least 70% coverage.
To run tests, execute: python manage.py test
🎉 Fun Facts
The VideoFlix crew loves 🍕 pizza and 🍔 burgers! We always brainstorm the best ideas over a good meal!

🧙 VideoFlix-Crew Developed by Lukas, Alex and Benjamin ;)
