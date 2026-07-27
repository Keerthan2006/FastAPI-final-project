#!/bin/bash
set -e

NAMESPACE="internship-app"
SECRET_NAME="app-secrets"
ENV_FILE="../backend/.env"

if [ ! -f "$ENV_FILE" ]; then
    ENV_FILE="./backend/.env"
fi

if [ ! -f "$ENV_FILE" ]; then
    echo "Error: backend/.env file not found."
    exit 1
fi

echo "Creating Kubernetes namespace '$NAMESPACE' if it does not exist..."
kubectl create namespace "$NAMESPACE" --dry-run=client -o yaml | kubectl apply -f -

echo "Creating Kubernetes Secret '$SECRET_NAME' from '$ENV_FILE'..."
TMP_ENV=$(mktemp)
grep -v '^POSTGRES_SERVER=' "$ENV_FILE" > "$TMP_ENV"
echo "POSTGRES_SERVER=db-service" >> "$TMP_ENV"

kubectl create secret generic "$SECRET_NAME" \
  --namespace="$NAMESPACE" \
  --from-env-file="$TMP_ENV" \
  --dry-run=client -o yaml | \
  kubectl apply -f -

rm -f "$TMP_ENV"
echo "Secret '$SECRET_NAME' successfully created/updated in namespace '$NAMESPACE'."
