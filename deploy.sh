#!/bin/bash
hugo --cleanDestinationDir

source .secret/env.sh
firebase deploy --token "$FIREBASE_TOKEN"