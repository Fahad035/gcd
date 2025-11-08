#!/bin/bash
# ===========================================================
# Google Cloud Arcade Lab: Cloud Run Functions Qwik Start
# Author: Fahad035
# Description: Automates deployment of a Qwik Starter app to Cloud Run
# ===========================================================

set -e

echo "🚀 Starting Cloud Run Functions Qwik Start setup..."

# Get current project ID
export PROJECT_ID=$(gcloud config get-value project)
echo "🧩 Using project: $PROJECT_ID"

# Enable required APIs
echo "🔧 Enabling required Google Cloud APIs..."
gcloud services enable \
  cloudfunctions.googleapis.com \
  cloudbuild.googleapis.com \
  run.googleapis.com

# Clone Qwik Starter app
echo "📦 Cloning Qwik Starter project..."
git clone https://github.com/BuilderIO/qwik-starter.git
cd qwik-starter

# Build Docker container
echo "🛠️ Building Docker container..."
gcloud builds submit --tag gcr.io/$PROJECT_ID/qwik-starter

# Deploy to Cloud Run
echo "☁️ Deploying to Cloud Run..."
gcloud run deploy qwik-starter \
  --image gcr.io/$PROJECT_ID/qwik-starter \
  --platform managed \
  --region us-central1 \
  --allow-unauthenticated

# Show deployed URL
echo "🌐 Your Qwik Starter app is live at:"
gcloud run services describe qwik-starter \
  --platform managed \
  --region us-central1 \
  --format 'value(status.url)'

echo "✅ Cloud Run Functions Qwik Start setup completed!"
