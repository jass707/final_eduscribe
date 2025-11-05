# 🚀 Complete Render.com Deployment Guide for EduScribe

## 📋 Prerequisites
- ✅ GitHub account
- ✅ MongoDB Atlas account (already set up)
- ✅ Groq API key
- ✅ Repository: https://github.com/jass707/final_eduscribe

---

## 🎯 STEP-BY-STEP DEPLOYMENT

### **STEP 1: Sign Up on Render**

1. Go to **https://render.com**
2. Click **"Get Started for Free"**
3. Sign up with your **GitHub account**
4. Authorize Render to access your GitHub repositories

---

### **STEP 2: Deploy Backend**

#### **2.1: Create New Web Service**

1. Click **"New +"** button (top right)
2. Select **"Web Service"**
3. Click **"Connect a repository"**
4. Find and select: **`jass707/final_eduscribe`**
5. Click **"Connect"**

#### **2.2: Configure Service**

Fill in these settings:

**Basic Settings:**
- **Name:** `eduscribe-backend`
- **Region:** `Singapore` (or closest to you)
- **Branch:** `main`
- **Root Directory:** `backend`
- **Runtime:** `Python 3` (auto-detected)

**Build & Deploy:**
- **Build Command:** `pip install -r requirements-railway.txt`
- **Start Command:** `python optimized_main.py`

**Instance Type:**
- **Plan:** `Free` (512 MB RAM, 0.1 CPU)

#### **2.3: Add Environment Variables**

Click **"Advanced"** → **"Add Environment Variable"**

Add these **REQUIRED** variables:

```
MONGODB_URL=mongodb+srv://eduscribe_user:280731@eduscribe-cluster.xxxxx.mongodb.net/eduscribe

GROQ_API_KEY=gsk_your_actual_groq_api_key_here

JWT_SECRET_KEY=d3EUXwmKhBqDo9WgQ_wuH5fD8LCSaDYVfrYfyPA106Y

LLM_MODEL=llama-3.1-8b-instant

WHISPER_MODEL_SIZE=tiny

WHISPER_DEVICE=cpu

WHISPER_COMPUTE_TYPE=int8

EMBEDDING_MODEL=all-MiniLM-L6-v2

PYTHON_VERSION=3.11.0
```

**Optional variables (already have defaults):**
```
AUDIO_SAMPLE_RATE=16000
CHUNK_DURATION=20
FAISS_TOP_K=3
IMPORTANCE_THRESHOLD=0.0
HISTORY_CHUNKS=4
ALGORITHM=HS256
ACCESS_TOKEN_EXPIRE_MINUTES=30
```

#### **2.4: Deploy!**

1. Click **"Create Web Service"**
2. Render will start building your app
3. Watch the build logs in real-time

**Expected Build Time:** 5-8 minutes

**Build Process:**
```
✅ Cloning repository
✅ Installing Python 3.11
✅ Running: pip install -r requirements-railway.txt
✅ Installing FastAPI, Uvicorn, faster-whisper, etc.
✅ Build successful!
✅ Starting: python optimized_main.py
✅ Downloading Whisper tiny model (first time only)
✅ Downloading MiniLM model (first time only)
✅ Server running on https://eduscribe-backend.onrender.com
```

#### **2.5: Get Your Backend URL**

Once deployed, you'll see:
```
🔗 https://eduscribe-backend-xxxx.onrender.com
```

**Copy this URL!** You'll need it for the frontend.

---

### **STEP 3: Configure MongoDB Atlas**

**CRITICAL:** Whitelist Render's IP addresses

1. Go to **MongoDB Atlas Dashboard**
2. Click **"Network Access"** (left sidebar)
3. Click **"Add IP Address"**
4. Select **"Allow Access from Anywhere"** (0.0.0.0/0)
5. Click **"Confirm"**

> **Why?** Render uses dynamic IPs, so we need to allow all IPs.

---

### **STEP 4: Test Backend**

1. Open your backend URL in browser:
   ```
   https://eduscribe-backend-xxxx.onrender.com
   ```

2. You should see a JSON response or "Not Found" (both mean it's working!)

3. Test the API docs:
   ```
   https://eduscribe-backend-xxxx.onrender.com/docs
   ```
   
   You should see the **FastAPI Swagger UI** ✅

---

### **STEP 5: Deploy Frontend on Vercel**

#### **5.1: Sign Up on Vercel**

1. Go to **https://vercel.com**
2. Click **"Sign Up"**
3. Sign up with **GitHub**

#### **5.2: Import Project**

1. Click **"Add New..."** → **"Project"**
2. Find **`jass707/final_eduscribe`**
3. Click **"Import"**

#### **5.3: Configure Project**

**Framework Preset:** `Vite`

**Root Directory:** `frontend`

**Build Settings:**
- **Build Command:** `npm run build`
- **Output Directory:** `dist`
- **Install Command:** `npm install`

#### **5.4: Add Environment Variables**

Click **"Environment Variables"** and add:

```
VITE_API_URL=https://eduscribe-backend-xxxx.onrender.com

VITE_WS_URL=wss://eduscribe-backend-xxxx.onrender.com
```

> **Replace** `xxxx` with your actual Render backend URL!

#### **5.5: Deploy!**

1. Click **"Deploy"**
2. Wait 2-3 minutes
3. Your frontend will be live at:
   ```
   https://final-eduscribe.vercel.app
   ```

---

### **STEP 6: Update Backend CORS**

Now that you have your frontend URL, update backend CORS:

1. Go to Render dashboard
2. Click your **eduscribe-backend** service
3. Click **"Environment"**
4. Add new variable:
   ```
   FRONTEND_URL=https://final-eduscribe.vercel.app
   ```
5. Click **"Save Changes"**
6. Service will auto-redeploy

---

## ✅ **DEPLOYMENT COMPLETE!**

### **Your Live URLs:**

**Frontend:** `https://final-eduscribe.vercel.app`
**Backend:** `https://eduscribe-backend-xxxx.onrender.com`
**API Docs:** `https://eduscribe-backend-xxxx.onrender.com/docs`

---

## 🔍 **Troubleshooting**

### **Issue 1: Backend Build Fails**

**Check:**
- All environment variables are set correctly
- MongoDB URL is correct
- Groq API key is valid

**Solution:**
- Check build logs in Render dashboard
- Look for missing dependencies or environment variables

### **Issue 2: "MongoDB connection failed"**

**Solution:**
- Whitelist 0.0.0.0/0 in MongoDB Atlas Network Access
- Check MONGODB_URL format:
  ```
  mongodb+srv://username:password@cluster.mongodb.net/database
  ```

### **Issue 3: Frontend can't connect to backend**

**Solution:**
- Check VITE_API_URL in Vercel environment variables
- Make sure it matches your Render backend URL
- Check browser console for CORS errors
- Verify FRONTEND_URL is set in backend

### **Issue 4: "Cold Start" - First request is slow**

**This is normal!** Render free tier sleeps after 15 minutes of inactivity.

**First request after sleep:**
- Takes 60-90 seconds (server wakes up + downloads models)
- Subsequent requests are fast!

**Solution:**
- Upgrade to paid plan ($7/month) for always-on service
- Or accept the cold start delay

### **Issue 5: Models not downloading**

**Check build logs for:**
```
Downloading Whisper model...
Downloading MiniLM model...
```

**If missing:**
- Check disk space (should be under 512 MB)
- Check internet connectivity in build logs

---

## 📊 **Expected Performance**

### **Build Times:**
- **Backend:** 5-8 minutes (first time), 3-5 minutes (subsequent)
- **Frontend:** 2-3 minutes

### **Cold Start (Free Tier):**
- **First request after sleep:** 60-90 seconds
- **Subsequent requests:** < 1 second

### **Model Download (First Deploy Only):**
- **Whisper tiny:** ~60 seconds
- **MiniLM:** ~30 seconds
- **Total:** ~90 seconds (one-time only!)

### **Runtime Performance:**
- **Transcription:** Real-time (as you speak)
- **Note generation:** 2-5 seconds
- **Final notes:** 5-10 seconds

---

## 💰 **Cost Breakdown**

### **Free Tier:**
- ✅ **Render:** Free (512 MB RAM, sleeps after 15 min)
- ✅ **Vercel:** Free (100 GB bandwidth/month)
- ✅ **MongoDB Atlas:** Free (512 MB storage)
- ✅ **Groq API:** Free (limited requests)

**Total Cost:** $0/month! 🎉

### **Paid Tier (Recommended for Production):**
- **Render:** $7/month (always-on, 512 MB RAM)
- **Vercel:** Free (sufficient for most use cases)
- **MongoDB Atlas:** Free (sufficient for testing)
- **Groq API:** Pay-as-you-go

**Total Cost:** $7/month

---

## 🎯 **Next Steps After Deployment**

1. ✅ Test all features (recording, transcription, notes)
2. ✅ Upload test documents
3. ✅ Create test subjects and lectures
4. ✅ Share with friends for feedback
5. ✅ Monitor usage in Render/Vercel dashboards

---

## 📞 **Support**

**Render Issues:** https://render.com/docs
**Vercel Issues:** https://vercel.com/docs
**MongoDB Issues:** https://www.mongodb.com/docs/atlas/

---

**Good luck with your deployment! 🚀**
