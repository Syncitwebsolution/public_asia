@echo off
setlocal enabledelayedexpansion

echo.
echo === Times News Platform - Build Deploy Script (Windows) ===
echo.

REM Check if Node.js is installed
node -v >nul 2>&1
if errorlevel 1 (
    echo Error: Node.js is not installed
    exit /b 1
)

for /f "tokens=*" %%i in ('node -v') do set NODE_VERSION=%%i
for /f "tokens=*" %%i in ('npm -v') do set NPM_VERSION=%%i

echo [OK] Node.js version: %NODE_VERSION%
echo [OK] npm version: %NPM_VERSION%
echo.

REM Install backend dependencies
echo [1/4] Installing backend dependencies...
cd backend
call npm install
if errorlevel 1 (
    echo [ERROR] Failed to install backend dependencies
    exit /b 1
)
echo [OK] Backend dependencies installed
cd ..

REM Install frontend dependencies
echo [2/4] Installing frontend dependencies...
cd frontend
call npm install
if errorlevel 1 (
    echo [ERROR] Failed to install frontend dependencies
    exit /b 1
)
echo [OK] Frontend dependencies installed
cd ..

REM Build frontend
echo [3/4] Building frontend...
cd frontend
call npm run build
if errorlevel 1 (
    echo [ERROR] Failed to build frontend
    exit /b 1
)
echo [OK] Frontend built successfully

REM Copy built files to backend public folder
if not exist "..\backend\public" mkdir ..\backend\public
xcopy /E /I /Y dist ..\backend\public
echo [OK] Frontend files copied to backend/public
cd ..

REM Check environment files
echo [4/4] Checking environment configuration...
if exist "backend\.env" (
    echo [OK] backend\.env exists
) else (
    echo [WARNING] backend\.env not found. Using backend\.env.production as template.
    echo [INFO] Configure backend\.env before deployment
)

if exist "frontend\.env" (
    echo [OK] frontend\.env exists
) else (
    echo [WARNING] frontend\.env not found. Using frontend\.env.production as template.
    echo [INFO] Configure frontend\.env before deployment
)

echo.
echo === Build Complete ===
echo.
echo Next steps:
echo 1. Update backend\.env with your production credentials
echo 2. Ensure MongoDB URI, JWT secrets, and Cloudinary keys are set
echo 3. Start with: npm start (in backend directory)
echo 4. Or use PM2: pm2 start ecosystem.config.js
echo.

endlocal
