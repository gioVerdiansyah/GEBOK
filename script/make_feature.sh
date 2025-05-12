#!/bin/bash

if [ -z "$1" ]; then
    echo "Usage: $0 <feature_name>"
    exit 1
fi

FEATURE_NAME=$1

BASE_DIR="D:/Users/Verdi/AppData/Local/Android/book_shelf/lib/src/features/$FEATURE_NAME"

mkdir -p $BASE_DIR/{data/{api,models,repositories},domain/{entities,repositories},presentations/{blocs,screens,widgets}}

echo "Feature '$FEATURE_NAME' has successfully make in '$BASE_DIR'"
