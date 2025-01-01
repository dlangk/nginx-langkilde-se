#!/bin/sh

# Paths to Let's Encrypt and fallback certificates
CERT_DIR="/etc/letsencrypt/live/langkilde.se"
SELF_SIGNED_DIR="/etc/letsencrypt/self-signed"
FULLCHAIN="${CERT_DIR}/fullchain.pem"
PRIVKEY="${CERT_DIR}/privkey.pem"
FALLBACK_FULLCHAIN="${SELF_SIGNED_DIR}/fullchain.pem"
FALLBACK_PRIVKEY="${SELF_SIGNED_DIR}/privkey.pem"

# Generate a self-signed certificate if needed
if [ ! -f "$FULLCHAIN" ] || [ ! -f "$PRIVKEY" ]; then
  echo "Generating a self-signed certificate as a fallback..."
  mkdir -p "$SELF_SIGNED_DIR"
  openssl req -x509 -nodes -days 1 -newkey rsa:2048 \
    -keyout "$FALLBACK_PRIVKEY" \
    -out "$FALLBACK_FULLCHAIN" \
    -subj "/CN=localhost"
fi

# Wait for Certbot to generate certificates, or fallback
while [ ! -f "$FULLCHAIN" ] || [ ! -f "$PRIVKEY" ]; do
  echo "Waiting for Certbot to generate certificates..."
  sleep 5
done

echo "Starting Nginx..."
exec nginx -g "daemon off;"