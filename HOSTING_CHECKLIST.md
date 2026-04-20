# Production Deployment Checklist for Hostinger

> A quick checklist to ensure your Times News Platform is production-ready for Hostinger hosting.

## ✅ Pre-Deployment Checklist

### 1. **Code Quality & Security**
- [ ] All hardcoded credentials removed (use environment variables)
- [ ] `NODE_ENV` set to `production`
- [ ] Sensitive files in `.gitignore` (`.env`, `node_modules`, logs)
- [ ] No console.log statements left in production code (optional but recommended)
- [ ] Dependencies updated: `npm audit` shows no critical vulnerabilities
- [ ] CORS_ORIGIN configured for your domain (not `*` in production)

### 2. **Database Setup**
- [ ] MongoDB Atlas cluster created
- [ ] Database user credentials generated
- [ ] IP whitelist includes Hostinger server IP
- [ ] Connection string format: `mongodb+srv://user:password@cluster.mongodb.net/dbname`
- [ ] Test connection from your local machine

### 3. **Cloudinary Setup**
- [ ] Cloudinary account created
- [ ] API Key and API Secret obtained
- [ ] Cloud Name configured
- [ ] Unsigned upload preset configured (if using frontend upload)

### 4. **JWT Secrets**
- [ ] Generate strong random secrets (minimum 32 characters)
  ```bash
  # Use this command to generate secrets:
  openssl rand -base64 32
  ```
- [ ] ACCESS_TOKEN_SECRET set
- [ ] REFRESH_TOKEN_SECRET set
- [ ] Store safely in `.env` (never in code)

### 5. **Frontend Build**
- [ ] Production build tested locally: `npm run build`
- [ ] No build errors or warnings
- [ ] Built files in `dist/` folder
- [ ] API URLs point to production domain
- [ ] Remove any dev-only features/comments

### 6. **Backend Configuration**
- [ ] All environment variables in `backend/.env`
- [ ] Email configuration (if needed)
- [ ] Rate limiting configured for production load
- [ ] Error logging configured
- [ ] CORS headers properly set

### 7. **Deployment Scripts**
- [ ] `ecosystem.config.js` configured for PM2
- [ ] `build-deploy.sh` or `build-deploy.bat` available
- [ ] Deployment documentation (DEPLOYMENT.md) reviewed

### 8. **Git Repository**
- [ ] `.gitignore` properly configured
- [ ] No `.env` files committed
- [ ] All changes committed
- [ ] Remote repository connected: `git remote -v`
- [ ] Ready to push: `git push origin main`

---

## 🚀 Quick Deployment Steps

### Step 1: Push to GitHub/Repository
```bash
git status          # Verify no .env files
git add .
git commit -m "Ready for production deployment on Hostinger"
git push origin main
```

### Step 2: On Hostinger (via SSH/Terminal)
```bash
# Navigate to deployment directory
cd ~/public_html

# Clone repository
git clone https://github.com/yourusername/aajkamuddaShiAnki.git
cd aajkamuddaShiAnki

# Run automated build script
chmod +x build-deploy.sh
./build-deploy.sh

# Create .env file with production values
nano backend/.env
# Add all production environment variables
```

### Step 3: Start Application
```bash
# Install PM2 globally
npm install -g pm2

# Start application
pm2 start ecosystem.config.js

# Save PM2 startup
pm2 startup
pm2 save
```

### Step 4: Configure Web Server
- Point your domain to `localhost:3000` via Nginx reverse proxy
- Or enable SSL/TLS through Hostinger cPanel
- Verify: `https://yourdomain.com` loads correctly

---

## 📊 Environment Variables Template

**backend/.env:**
```env
PORT=3000
NODE_ENV=production
MONGODB_URI=mongodb+srv://username:password@cluster.mongodb.net/news-db
CORS_ORIGIN=https://yourdomain.com

ACCESS_TOKEN_SECRET=your_32_char_random_string_here
ACCESS_TOKEN_EXPIRY=1d
REFRESH_TOKEN_SECRET=your_32_char_random_string_here
REFRESH_TOKEN_EXPIRY=10d

CLOUDINARY_CLOUD_NAME=your_name
CLOUDINARY_API_KEY=your_key
CLOUDINARY_API_SECRET=your_secret
```

**frontend/.env:**
```env
VITE_API_URL=https://yourdomain.com/api/v1
VITE_NEWS_API_KEY=your_api_key
```

---

## 🐛 Troubleshooting

| Issue | Solution |
|-------|----------|
| **Port 3000 in use** | `lsof -i :3000` then `kill -9 <PID>` |
| **MongoDB connection fails** | Verify IP whitelist in MongoDB Atlas |
| **Frontend not loading** | Check `backend/public/` has `dist` contents |
| **API requests fail** | Verify CORS_ORIGIN matches your domain |
| **500 errors** | Check logs: `pm2 logs news-api` |
| **SSL certificate issues** | Use Hostinger's AutoSSL or Let's Encrypt |

---

## 📞 Support Resources

- **DEPLOYMENT.md** - Comprehensive deployment guide
- **README.md** - Project overview and features
- **backend/README.md** - Backend API documentation
- **frontend/README.md** - Frontend setup guide
- **Hostinger Docs** - https://www.hostinger.com/help
- **PM2 Docs** - https://pm2.keymetrics.io/

---

## ✨ Post-Deployment Tips

1. **Monitor Application:**
   ```bash
   pm2 logs news-api
   pm2 monit
   ```

2. **Update Code:**
   ```bash
   git pull origin main
   npm install
   npm run build --prefix frontend
   cp -r frontend/dist/* backend/public/
   pm2 restart all
   ```

3. **Database Backups:**
   - Set up automated backups in MongoDB Atlas
   - Download backups periodically

4. **SSL/TLS:**
   - Ensure HTTPS is enabled
   - Redirect HTTP to HTTPS

5. **Performance:**
   - Monitor server resources
   - Optimize database queries
   - Use CDN for assets (Cloudinary already integrated)

---

**Last Updated:** April 2026

Good luck with your deployment! 🚀
