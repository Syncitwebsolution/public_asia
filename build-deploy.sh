#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}=== Times News Platform - Build & Deploy Script ===${NC}\n"

# Check if Node.js is installed
if ! command -v node &> /dev/null; then
    echo -e "${RED}Error: Node.js is not installed${NC}"
    exit 1
fi

echo -e "${GREEN}✓ Node.js version: $(node -v)${NC}"
echo -e "${GREEN}✓ npm version: $(npm -v)${NC}\n"

# Install backend dependencies
echo -e "${YELLOW}[1/4] Installing backend dependencies...${NC}"
cd backend
if npm install; then
    echo -e "${GREEN}✓ Backend dependencies installed${NC}"
else
    echo -e "${RED}✗ Failed to install backend dependencies${NC}"
    exit 1
fi
cd ..

# Install frontend dependencies
echo -e "${YELLOW}[2/4] Installing frontend dependencies...${NC}"
cd frontend
if npm install; then
    echo -e "${GREEN}✓ Frontend dependencies installed${NC}"
else
    echo -e "${RED}✗ Failed to install frontend dependencies${NC}"
    exit 1
fi
cd ..

# Build frontend
echo -e "${YELLOW}[3/4] Building frontend...${NC}"
cd frontend
if npm run build; then
    echo -e "${GREEN}✓ Frontend built successfully${NC}"
    # Copy built files to backend public folder
    mkdir -p ../backend/public
    cp -r dist/* ../backend/public/
    echo -e "${GREEN}✓ Frontend files copied to backend/public${NC}"
else
    echo -e "${RED}✗ Failed to build frontend${NC}"
    exit 1
fi
cd ..

# Check environment files
echo -e "${YELLOW}[4/4] Checking environment configuration...${NC}"
if [ -f "backend/.env" ]; then
    echo -e "${GREEN}✓ backend/.env exists${NC}"
else
    echo -e "${YELLOW}⚠ backend/.env not found. Using backend/.env.production as template.${NC}"
    cp backend/.env.production backend/.env.production.example
    echo -e "${YELLOW}  → Configure backend/.env before deployment${NC}"
fi

if [ -f "frontend/.env" ]; then
    echo -e "${GREEN}✓ frontend/.env exists${NC}"
else
    echo -e "${YELLOW}⚠ frontend/.env not found. Using frontend/.env.production as template.${NC}"
    cp frontend/.env.production frontend/.env.production.example
    echo -e "${YELLOW}  → Configure frontend/.env before deployment${NC}"
fi

echo -e "\n${GREEN}=== Build Complete ===${NC}"
echo -e "\n${YELLOW}Next steps:${NC}"
echo -e "1. Update backend/.env with your production credentials"
echo -e "2. Ensure MongoDB URI, JWT secrets, and Cloudinary keys are set"
echo -e "3. Start with: npm start (in backend directory)"
echo -e "4. Or use PM2: pm2 start ecosystem.config.js\n"
