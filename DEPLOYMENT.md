# Hostinger Deployment Guide

This guide walks you through deploying the Times News Platform to Hostinger.

## ✅ Pre-Deployment Checklist

- [ ] Node.js v18+ available on your Hostinger account
- [ ] MongoDB Atlas cluster created and accessible
- [ ] Cloudinary account with API credentials
- [ ] Frontend `.env.production` file configured
- [ ] Backend `.env.production` file configured
- [ ] Git repository pushed with all changes

---

## 📋 System Requirements

- **Node.js:** v18 or higher
- **npm/yarn:** Package manager
- **Database:** MongoDB Atlas (cloud-based recommended for Hostinger)
- **Storage:** Cloudinary (for media files)

---

## 🚀 Deployment Steps

### 1. **Connect via SSH to Hostinger**

```bash
ssh username@your-hostinger-ip
# Or use Hostinger's File Manager / Terminal in cPanel
```

### 2. **Clone the Repository**

Navigate to your public_html or desired directory:

```bash
cd ~/public_html  # or your deployment directory
git clone https://github.com/yourusername/aajkamuddaShiAnki.git
cd aajkamuddaShiAnki
```

### 3. **Install Dependencies**

```bash
# Install backend dependencies
cd backend
npm install

# Install frontend dependencies
cd ../frontend
npm install
cd ..
```

### 4. **Build the Frontend**

```bash
cd frontend
npm run build
cd ..
```

This creates a `dist` folder with optimized production files.

### 5. **Configure Environment Variables**

Create `.env` file in the backend directory:

```bash
nano backend/.env
```

Add the following variables (replace with your actual values):

```env
PORT=3000
NODE_ENV=production
MONGODB_URI=mongodb+srv://username:password@cluster.mongodb.net

CORS_ORIGIN=https://yourdomain.com

ACCESS_TOKEN_SECRET=your_long_random_access_token_secret_min_32_chars
ACCESS_TOKEN_EXPIRY=1d
REFRESH_TOKEN_SECRET=your_long_random_refresh_token_secret_min_32_chars
REFRESH_TOKEN_EXPIRY=10d

CLOUDINARY_CLOUD_NAME=your_cloudinary_cloud_name
CLOUDINARY_API_KEY=your_cloudinary_api_key
CLOUDINARY_API_SECRET=your_cloudinary_api_secret
```

### 6. **Serve Frontend from Backend**

Create or update [backend/src/app.js](backend/src/app.js) to serve the built frontend:

The app is already configured to serve static files from the `public` directory. After building the frontend:

```bash
# Copy the built frontend to backend's public folder
cp -r frontend/dist/* backend/public/
```

### 7. **Set Up Process Manager (PM2 Recommended)**

Install PM2 globally:

```bash
npm install -g pm2
```

Create [ecosystem.config.js](ecosystem.config.js) in the root directory:

```javascript
module.exports = {
  apps: [
    {
      name: "news-api",
      script: "./backend/src/server.js",
      instances: "max",
      exec_mode: "cluster",
      max_memory_restart: "1G",
      error_file: "./logs/error.log",
      out_file: "./logs/out.log",
      log_file: "./logs/combined.log",
      time_format: "YYYY-MM-DD HH:mm:ss Z",
      env: {
        NODE_ENV: "production",
      },
    },
  ],
};
```

### 8. **Start the Application**

```bash
# Using PM2
pm2 start ecosystem.config.js

# Save PM2 startup configuration
pm2 startup
pm2 save

# Check status
pm2 status
pm2 logs
```

### 9. **Configure Web Server (Nginx)**

If using Hostinger with cPanel, configure a reverse proxy. Create/update Nginx config:

```nginx
server {
    listen 80;
    server_name yourdomain.com www.yourdomain.com;

    location / {
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_cache_bypass $http_upgrade;
    }
}
```

### 10. **Enable SSL/TLS**

Use Let's Encrypt (free SSL). In Hostinger cPanel:
- Go to AutoSSL and enable it
- Or use Certbot: `certbot certonly --webroot -w /path/to/public_html -d yourdomain.com`

### 11. **Set Up Monitoring & Logs**

```bash
# View real-time logs
pm2 logs news-api

# View error logs
tail -f logs/error.log

# Monitor CPU and memory
pm2 monit
```

---

## 🛠️ Post-Deployment

### Update Code

When you push updates to Git:

```bash
cd ~/public_html/aajkamuddaShiAnki
git pull origin main

# If frontend changed, rebuild
cd frontend && npm run build && cd ..
cp -r frontend/dist/* backend/public/

# Restart the app
pm2 restart all
```

### Database Backups

MongoDB Atlas automatically handles backups. Configure in Atlas console:
- Enable automatic backups
- Set retention policy

### Monitor Application Health

```bash
# Check if app is running
pm2 status

# If app crashed, restart
pm2 restart news-api

# View resource usage
pm2 monit
```

---

## 🐛 Troubleshooting

### Port Already in Use

```bash
# Find and kill process using port 3000
lsof -i :3000
kill -9 <PID>
```

### MongoDB Connection Failed

- Verify MongoDB URI is correct
- Whitelist Hostinger IP in MongoDB Atlas: `Network Access > IP Whitelist`
- Ensure database user credentials are correct

### Frontend Assets Not Loading

```bash
# Ensure frontend is built and copied
npm run build --prefix frontend
cp -r frontend/dist/* backend/public/

# Check public folder exists
ls -la backend/public/
```

### PM2 Not Starting

```bash
# Install PM2 globally
npm install -g pm2

# Start with ecosystem config
pm2 start ecosystem.config.js

# Check PM2 logs
pm2 logs
```

---

## 📊 Performance Tips

1. **Enable Compression:** Already configured with Helmet.js
2. **Database Indexing:** Compound indexes are optimized in models
3. **Rate Limiting:** Configured in [backend/src/app.js](backend/src/app.js)
4. **Caching:** Implement Redis for session caching (optional)
5. **CDN:** Use Cloudinary CDN for media files

---

## 🔒 Security Checklist

- [ ] Set `NODE_ENV=production`
- [ ] Use strong, unique JWT secrets (min 32 characters)
- [ ] Enable CORS only for your domain
- [ ] Use HTTPS/SSL
- [ ] Keep dependencies updated: `npm outdated` and `npm update`
- [ ] Set up environment variables securely (not in code)
- [ ] Enable MongoDB IP whitelisting
- [ ] Use Helmet.js for security headers ✓
- [ ] Implement rate limiting ✓

---

## 📞 Support

For Hostinger-specific issues, contact Hostinger Support.
For application issues, refer to README.md files in backend/ and frontend/ directories.
