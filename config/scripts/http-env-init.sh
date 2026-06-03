#!/usr/bin/env bash
# Initialize HTTP API environment structure

set -e

PROJECT_NAME="${1:-api}"
PROJECT_DIR="${2:-.}"

echo "🚀 Initializing HTTP environment: $PROJECT_NAME"

# Create directory structure
mkdir -p "$PROJECT_DIR"
cd "$PROJECT_DIR"

# Create base environment file
cat > http-client.env.json << 'EOF'
{
  "dev": {
    "base_url": "https://api.dev.example.com",
    "api_version": "v1"
  },
  "staging": {
    "base_url": "https://api.staging.example.com",
    "api_version": "v1"
  },
  "prod": {
    "base_url": "https://api.example.com",
    "api_version": "v1"
  },
  "local": {
    "base_url": "http://localhost:8080",
    "api_version": "v1"
  }
}
EOF

# Create private environment file (will be gitignored)
cat > http-client.private.env.json << 'EOF'
{
  "dev": {
    "token": "YOUR_DEV_TOKEN",
    "user_id": ""
  },
  "staging": {
    "token": "YOUR_STAGING_TOKEN",
    "user_id": ""
  },
  "prod": {
    "token": "YOUR_PROD_TOKEN",
    "user_id": ""
  },
  "local": {
    "token": "LOCAL_TEST_TOKEN",
    "user_id": "12345"
  }
}
EOF

# Create example requests file
cat > requests.http << 'EOF'
### Health Check
GET {{base_url}}/health HTTP/1.1

###

### Authenticated Request Example
GET {{base_url}}/{{api_version}}/users/{{user_id}} HTTP/1.1
Authorization: Bearer {{token}}
Accept: application/json

###
EOF

# Create .gitignore
cat > .gitignore << 'EOF'
# Private environment variables
http-client.private.env.json
*.private.env.json

# Response files
*.response.json
*.response.txt
.response/
EOF

echo "✅ Created files:"
echo "   - http-client.env.json"
echo "   - http-client.private.env.json"
echo "   - requests.http"
echo "   - .gitignore"
echo ""
echo "📝 Next steps:"
echo "   1. Edit http-client.private.env.json with your tokens"
echo "   2. Open requests.http in nvim"
echo "   3. Press <leader>re to select environment"
echo "   4. Press <leader>rr to send request"
echo ""
echo "💡 Add to sesh.toml:"
echo "   [[session]]"
echo "   name = \"$PROJECT_NAME-dev\""
echo "   path = \"$PROJECT_DIR\""
echo "   startup_command = \"nvim requests.http\""
