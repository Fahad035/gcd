#!/bin/bash
# ===========================================================
# Google Cloud Arcade Lab: Flutter Qwik Start (Firebase Hosting)
# Author: Fahad035
# Description: Automates setup and deployment of Flutter Web App to Firebase Hosting
# ===========================================================

set -e  # Exit immediately if a command fails

echo "🚀 Starting Flutter Qwik Start (Firebase Hosting) setup..."

# Get your current project ID
export PROJECT_ID=$(gcloud config get-value project)
echo "🧩 Using project: $PROJECT_ID"

# Enable required APIs
echo "🔧 Enabling required Google Cloud APIs..."
gcloud services enable \
  firebase.googleapis.com \
  firestore.googleapis.com \
  hosting.googleapis.com

# Install Flutter SDK if missing
if ! command -v flutter &> /dev/null; then
  echo "⬇️ Installing Flutter SDK..."
  sudo snap install flutter --classic
else
  echo "✅ Flutter already installed."
fi

# Clone a sample Flutter web app
echo "📦 Cloning Flutter web app..."
git clone https://github.com/flutter/website.git
cd website/examples/layout/lakes/

# Enable Flutter web support
echo "🛠️ Enabling Flutter web..."
flutter config --enable-web

# Build the web app
echo "🏗️ Building Flutter web app..."
flutter build web

# Install Firebase CLI if not installed
if ! command -v firebase &> /dev/null; then
  echo "⬇️ Installing Firebase CLI..."
  curl -sL https://firebase.tools | bash
else
  echo "✅ Firebase CLI already installed."
fi

# Initialize Firebase in the project
echo "🔥 Initializing Firebase Hosting..."
firebase login:ci || true
firebase use --add $PROJECT_ID
firebase init hosting --project $PROJECT_ID --public build/web --non-interactive

# Deploy to Firebase Hosting
echo "🚀 Deploying Flutter web app to Firebase Hosting..."
firebase deploy --only hosting --project $PROJECT_ID

# Show hosting URL
echo "🌐 Your Flutter app is live at:"
firebase hosting:sites:list --project $PROJECT_ID | grep "https"

echo "✅ Flutter Qwik Start (Firebase Hosting) completed successfully!"
