# Deployment Guide

This guide covers deploying OneMart SDUI to production environments, including mobile app stores and backend infrastructure.

## 📱 Mobile App Deployment

### Prerequisites
- Flutter SDK (3.0+)
- Xcode (for iOS)
- Android Studio (for Android)
- Apple Developer Account (for iOS App Store)
- Google Play Console Account (for Android)

### Environment Configuration

#### Production Environment Variables
```bash
# API Configuration
export USE_MOCK_DATA=false
export MEDUSA_API_URL=https://api.yourstore.com
export USE_KONG_GATEWAY=true
export KONG_GATEWAY_URL=https://gateway.yourstore.com

# Security
export ENABLE_SSL_PINNING=true
export ENABLE_CERTIFICATE_VALIDATION=true

# Analytics
export ENABLE_ANALYTICS=true
export ANALYTICS_TRACKING_ID=your_tracking_id

# Performance
export ENABLE_PERFORMANCE_MONITORING=true
export ENABLE_CRASH_REPORTING=true
```

### iOS Deployment

#### 1. Code Signing Setup
```bash
# Install certificates and provisioning profiles
# Through Xcode or manually via Apple Developer Portal
```

#### 2. Build Configuration
```bash
# Update version in pubspec.yaml
version: 1.0.0+1

# Build for release
flutter build ios --release \
  --dart-define=USE_MOCK_DATA=false \
  --dart-define=MEDUSA_API_URL=https://api.yourstore.com \
  --dart-define=USE_KONG_GATEWAY=true
```

#### 3. App Store Submission
```bash
# Archive and upload via Xcode
# Or use command line tools
xcrun altool --upload-app \
  --type ios \
  --file "build/ios/ipa/OneMart.ipa" \
  --username "your@email.com" \
  --password "app-specific-password"
```

#### 4. iOS Configuration Files

**ios/Runner/Info.plist**
```xml
<key>CFBundleDisplayName</key>
<string>OneMart</string>
<key>CFBundleIdentifier</key>
<string>com.yourcompany.onemart</string>
<key>CFBundleVersion</key>
<string>1</string>
<key>CFBundleShortVersionString</key>
<string>1.0.0</string>

<!-- Network permissions -->
<key>NSAppTransportSecurity</key>
<dict>
  <key>NSAllowsArbitraryLoads</key>
  <false/>
  <key>NSExceptionDomains</key>
  <dict>
    <key>api.yourstore.com</key>
    <dict>
      <key>NSExceptionAllowsInsecureHTTPLoads</key>
      <false/>
      <key>NSExceptionMinimumTLSVersion</key>
      <string>TLSv1.2</string>
    </dict>
  </dict>
</dict>
```

### Android Deployment

#### 1. Signing Configuration

**android/key.properties**
```properties
storePassword=your_store_password
keyPassword=your_key_password
keyAlias=your_key_alias
storeFile=../keystore.jks
```

**android/app/build.gradle**
```gradle
android {
    compileSdkVersion 34
    
    defaultConfig {
        applicationId "com.yourcompany.onemart"
        minSdkVersion 21
        targetSdkVersion 34
        versionCode 1
        versionName "1.0.0"
    }
    
    signingConfigs {
        release {
            keyAlias keystoreProperties['keyAlias']
            keyPassword keystoreProperties['keyPassword']
            storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
            storePassword keystoreProperties['storePassword']
        }
    }
    
    buildTypes {
        release {
            signingConfig signingConfigs.release
            minifyEnabled true
            proguardFiles getDefaultProguardFile('proguard-android.txt'), 'proguard-rules.pro'
        }
    }
}
```

#### 2. Build for Release
```bash
# Build APK
flutter build apk --release \
  --dart-define=USE_MOCK_DATA=false \
  --dart-define=MEDUSA_API_URL=https://api.yourstore.com

# Build App Bundle (recommended for Play Store)
flutter build appbundle --release \
  --dart-define=USE_MOCK_DATA=false \
  --dart-define=MEDUSA_API_URL=https://api.yourstore.com
```

#### 3. Play Store Submission
```bash
# Upload via Play Console web interface
# Or use fastlane for automation
```

#### 4. Android Permissions

**android/app/src/main/AndroidManifest.xml**
```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    package="com.yourcompany.onemart">
    
    <!-- Network permissions -->
    <uses-permission android:name="android.permission.INTERNET" />
    <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
    
    <!-- Storage permissions for caching -->
    <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
    <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
    
    <application
        android:label="OneMart"
        android:icon="@mipmap/ic_launcher"
        android:usesCleartextTraffic="false"
        android:networkSecurityConfig="@xml/network_security_config">
        
        <activity
            android:name=".MainActivity"
            android:exported="true"
            android:launchMode="singleTop"
            android:theme="@style/LaunchTheme">
            
            <intent-filter android:autoVerify="true">
                <action android:name="android.intent.action.MAIN"/>
                <category android:name="android.intent.category.LAUNCHER"/>
            </intent-filter>
        </activity>
    </application>
</manifest>
```

**android/app/src/main/res/xml/network_security_config.xml**
```xml
<?xml version="1.0" encoding="utf-8"?>
<network-security-config>
    <domain-config cleartextTrafficPermitted="false">
        <domain includeSubdomains="true">api.yourstore.com</domain>
        <domain includeSubdomains="true">gateway.yourstore.com</domain>
    </domain-config>
</network-security-config>
```

## 🖥️ Backend Infrastructure

### Medusa Commerce Setup

#### 1. Server Requirements
- Node.js 16+
- PostgreSQL 12+
- Redis (for caching)
- Docker (recommended)

#### 2. Docker Deployment
```yaml
# docker-compose.yml
version: '3.8'
services:
  medusa-backend:
    image: medusajs/medusa:latest
    environment:
      - DATABASE_URL=postgres://user:password@postgres:5432/medusa
      - REDIS_URL=redis://redis:6379
      - JWT_SECRET=your_jwt_secret
      - COOKIE_SECRET=your_cookie_secret
    ports:
      - "9000:9000"
    depends_on:
      - postgres
      - redis
      
  postgres:
    image: postgres:13
    environment:
      - POSTGRES_USER=medusa_user
      - POSTGRES_PASSWORD=medusa_password
      - POSTGRES_DB=medusa
    volumes:
      - postgres_data:/var/lib/postgresql/data
      
  redis:
    image: redis:6-alpine
    
volumes:
  postgres_data:
```

#### 3. Environment Configuration
```bash
# .env
DATABASE_URL=postgres://user:password@localhost:5432/medusa
REDIS_URL=redis://localhost:6379
JWT_SECRET=your_super_secret_jwt_secret
COOKIE_SECRET=your_super_secret_cookie_secret

# CORS settings
STORE_CORS=http://localhost:3000,https://yourapp.com
ADMIN_CORS=http://localhost:7000,https://admin.yourapp.com
```

### Kong Gateway Setup

#### 1. Kong Configuration
```yaml
# kong.yml
_format_version: "3.0"

services:
  - name: medusa-service
    url: http://medusa-backend:9000
    
routes:
  - name: products-api
    service: medusa-service
    paths: ["/api/products"]
    
  - name: categories-api
    service: medusa-service
    paths: ["/api/categories"]
    
  - name: cart-api
    service: medusa-service
    paths: ["/api/cart"]

plugins:
  - name: rate-limiting
    config:
      minute: 100
      hour: 1000
      
  - name: cors
    config:
      origins: ["*"]
      methods: ["GET", "POST", "PUT", "DELETE"]
```

#### 2. Kong Docker Setup
```yaml
# kong-docker-compose.yml
version: '3.8'
services:
  kong-database:
    image: postgres:13
    environment:
      POSTGRES_USER: kong
      POSTGRES_PASSWORD: kong
      POSTGRES_DB: kong
      
  kong:
    image: kong:latest
    environment:
      KONG_DATABASE: postgres
      KONG_PG_HOST: kong-database
      KONG_PG_USER: kong
      KONG_PG_PASSWORD: kong
      KONG_PROXY_ACCESS_LOG: /dev/stdout
      KONG_ADMIN_ACCESS_LOG: /dev/stdout
      KONG_PROXY_ERROR_LOG: /dev/stderr
      KONG_ADMIN_ERROR_LOG: /dev/stderr
      KONG_ADMIN_LISTEN: 0.0.0.0:8001
    ports:
      - "8000:8000"
      - "8001:8001"
    depends_on:
      - kong-database
```

## 🔧 CI/CD Pipeline

### GitHub Actions Workflow

**.github/workflows/deploy.yml**
```yaml
name: Deploy OneMart

on:
  push:
    branches: [main]
    tags: ['v*']

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.16.0'
      - run: flutter pub get
      - run: flutter test
      - run: flutter analyze
      
  build-android:
    needs: test
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
      - uses: actions/setup-java@v3
        with:
          distribution: 'zulu'
          java-version: '11'
      - run: flutter pub get
      - run: flutter build appbundle --release
      - uses: actions/upload-artifact@v3
        with:
          name: android-release
          path: build/app/outputs/bundle/release/
          
  build-ios:
    needs: test
    runs-on: macos-latest
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
      - run: flutter pub get
      - run: flutter build ios --release --no-codesign
      - uses: actions/upload-artifact@v3
        with:
          name: ios-release
          path: build/ios/iphoneos/
```

### Fastlane Configuration

**fastlane/Fastfile**
```ruby
default_platform(:ios)

platform :ios do
  desc "Deploy to App Store"
  lane :deploy do
    build_app(scheme: "Runner")
    upload_to_app_store(
      skip_metadata: true,
      skip_screenshots: true
    )
  end
end

platform :android do
  desc "Deploy to Play Store"
  lane :deploy do
    gradle(task: "bundleRelease")
    upload_to_play_store(
      track: 'production',
      aab: '../build/app/outputs/bundle/release/app-release.aab'
    )
  end
end
```

## 📊 Monitoring and Analytics

### Application Performance Monitoring
```dart
// Firebase Performance
import 'package:firebase_performance/firebase_performance.dart';

final trace = FirebasePerformance.instance.newTrace('api_call');
trace.start();
// ... API call
trace.stop();
```

### Crash Reporting
```dart
// Firebase Crashlytics
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
```

### Analytics
```dart
// Firebase Analytics
import 'package:firebase_analytics/firebase_analytics.dart';

FirebaseAnalytics.instance.logEvent(
  name: 'product_view',
  parameters: {
    'product_id': productId,
    'category': category,
  },
);
```

## 🔐 Security Checklist

### Pre-Deployment Security
- [ ] API keys stored securely
- [ ] SSL/TLS certificates configured
- [ ] Network security policies implemented
- [ ] Code obfuscation enabled
- [ ] Debug information removed
- [ ] Sensitive data encrypted
- [ ] Authentication tokens secured

### Runtime Security
- [ ] Certificate pinning enabled
- [ ] Request signing implemented
- [ ] Rate limiting configured
- [ ] Input validation in place
- [ ] Error messages sanitized

## 🚀 Go-Live Checklist

### Pre-Launch
- [ ] All tests passing
- [ ] Performance benchmarks met
- [ ] Security audit completed
- [ ] Load testing performed
- [ ] Backup procedures tested
- [ ] Monitoring systems active
- [ ] Support documentation ready

### Launch Day
- [ ] Deploy backend infrastructure
- [ ] Configure DNS and SSL
- [ ] Submit mobile apps to stores
- [ ] Monitor system health
- [ ] Prepare rollback plan
- [ ] Customer support ready

### Post-Launch
- [ ] Monitor app store reviews
- [ ] Track performance metrics
- [ ] Monitor error rates
- [ ] Collect user feedback
- [ ] Plan next iteration

This deployment guide ensures a smooth transition from development to production for OneMart SDUI.
