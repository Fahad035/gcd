#!/bin/bash
# ===========================================================
# Google Cloud Arcade Lab: Qwik Starter Firebase Hosting
# Author: Fahad035
# Description: Automates deployment of Qwik Starter app to Firebase Hosting
# ===========================================================

set -e  # Exit immediately if a command fails

echo "🚀 Starting Qwik Starter Firebase Hosting setup..."

# Get current project ID
export PROJECT_ID=$(gcloud config get-value project)
echo "🧩 Using project: $PROJECT_ID"

# Enable required APIs
echo "🔧 Enabling Firebase and Hosting APIs..."
gcloud services enable \
  firebase.googleapis.com \
  firestore.googleapis.com \
  hosting.googleapis.com

# Install Node.js if missing (required for Qwik)
if ! command -v node &> /dev/null; then
  echo "⬇️ Installing Node.js..."
  sudo apt-get update
  sudo apt-get install -y nodejs npm
else
  echo "✅ Node.js already installed."
fi

# Install Firebase CLI if missing
if ! command -v firebase &> /dev/null; then
  echo "⬇️ Installing Firebase CLI..."
  curl -sL https://firebase.tools | bash
else
  echo "✅ Firebase CLI already installed."
fi

# Clone Qwik Starter app
echo "📦 Cloning Qwik Starter project..."
git clone https://github.com/BuilderIO/qwik-starter.git
cd qwik-starter

# Install dependencies and build
echo "🏗️ Installing dependencies and building Qwik app..."
npm install
npm run build

# Initialize Firebase Hosting (non-interactive)
echo "🔥 Initializing Firebase Hosting..."
firebase use --add $PROJECT_ID
firebase init hosting --project $PROJECT_ID --public dist --non-interactive --force

# Deploy to Firebase Hosting
echo "🚀 Deploying Qwik Starter app to Firebase Hosting..."
firebase deploy --only hosting --project $PROJECT_ID

# Print live URL
echo "🌐 Your Qwik Starter app is live at:"
firebase hosting:sites:list --project $PROJECT_ID | grep "https"

echo "✅ Qwik Starter Firebase Hosting deployment completed!"
