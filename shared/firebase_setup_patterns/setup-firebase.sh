#!/bin/bash

# =============================================================================
# Firebase Setup Script for Flutter Projects
# =============================================================================
# This script automates Firebase setup from CLI tools installation through
# complete Flutter project configuration.
#
# Usage:
#   ./setup-firebase.sh [options]
#
# Options:
#   --project <name>        Specify Firebase project ID
#   --skip-packages         Skip adding Firebase packages to pubspec.yaml
#   --services <list>       Comma-separated list of services (auth,firestore,storage,analytics)
#   --platforms <list>      Comma-separated platforms (ios,android,web,macos)
#   --help                  Show this help message
#
# Example:
#   ./setup-firebase.sh --project my-app --services auth,firestore,analytics
#
# =============================================================================

set -e  # Exit on error

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Default values
FIREBASE_PROJECT=""
SKIP_PACKAGES=false
SERVICES="core,auth,firestore,storage,analytics"
PLATFORMS="ios,android,web,macos"

# =============================================================================
# Helper Functions
# =============================================================================

print_header() {
    echo ""
    echo -e "${CYAN}╔════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║${NC} $1"
    echo -e "${CYAN}╚════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

print_step() {
    echo -e "${MAGENTA}▶ $1${NC}"
}

command_exists() {
    command -v "$1" >/dev/null 2>&1
}

show_help() {
    cat << EOF
Firebase Setup Script for Flutter Projects

Usage: $0 [OPTIONS]

Options:
    --project <name>        Firebase project ID to use
    --skip-packages         Skip adding packages to pubspec.yaml
    --services <list>       Services to add (core,auth,firestore,storage,analytics,messaging,crashlytics)
    --platforms <list>      Platforms to configure (ios,android,web,macos)
    --help                  Show this help message

Examples:
    # Full interactive setup
    $0

    # Specify project and services
    $0 --project my-flutter-app --services auth,firestore,analytics

    # Configure only iOS and Android
    $0 --platforms ios,android

Services:
    core            - firebase_core (required)
    auth            - firebase_auth
    firestore       - cloud_firestore
    storage         - firebase_storage
    analytics       - firebase_analytics
    messaging       - firebase_messaging
    crashlytics     - firebase_crashlytics
    performance     - firebase_performance
    remote_config   - firebase_remote_config

Platforms:
    ios, android, web, macos, windows, linux

EOF
}

# =============================================================================
# Parse Command Line Arguments
# =============================================================================

while [[ $# -gt 0 ]]; do
    case $1 in
        --project)
            FIREBASE_PROJECT="$2"
            shift 2
            ;;
        --skip-packages)
            SKIP_PACKAGES=true
            shift
            ;;
        --services)
            SERVICES="$2"
            shift 2
            ;;
        --platforms)
            PLATFORMS="$2"
            shift 2
            ;;
        --help)
            show_help
            exit 0
            ;;
        *)
            print_error "Unknown option: $1"
            show_help
            exit 1
            ;;
    esac
done

# =============================================================================
# Pre-flight Checks
# =============================================================================

print_header "Firebase Setup for Flutter - Pre-flight Checks"

# Check if we're in a Flutter project
if [ ! -f "pubspec.yaml" ]; then
    print_error "Not a Flutter project! pubspec.yaml not found."
    print_info "Please run this script from your Flutter project root directory."
    exit 1
fi

print_success "Found pubspec.yaml - Flutter project detected"

# Check Flutter installation
if ! command_exists flutter; then
    print_error "Flutter not found! Please install Flutter first."
    print_info "Visit: https://flutter.dev/docs/get-started/install"
    exit 1
fi

FLUTTER_VERSION=$(flutter --version | head -n 1)
print_success "Flutter installed: $FLUTTER_VERSION"

# =============================================================================
# Step 1: Check/Install Node.js and npm
# =============================================================================

print_header "Step 1: Checking Node.js and npm"

if ! command_exists node; then
    print_warning "Node.js not found!"
    print_info "Firebase CLI requires Node.js."
    
    if [[ "$OSTYPE" == "darwin"* ]]; then
        print_info "Install with: brew install node"
        print_info "Or download from: https://nodejs.org"
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        print_info "Install with: sudo apt-get install nodejs npm"
        print_info "Or download from: https://nodejs.org"
    fi
    
    read -p "Continue without Node.js? (FlutterFire CLI will still work) [y/N]: " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
else
    NODE_VERSION=$(node --version)
    NPM_VERSION=$(npm --version)
    print_success "Node.js installed: $NODE_VERSION"
    print_success "npm installed: $NPM_VERSION"
fi

# =============================================================================
# Step 2: Check/Install Firebase CLI
# =============================================================================

print_header "Step 2: Checking Firebase CLI"

if ! command_exists firebase; then
    print_warning "Firebase CLI not found!"
    
    if command_exists npm; then
        print_step "Installing Firebase CLI via npm..."
        npm install -g firebase-tools
        print_success "Firebase CLI installed"
    else
        print_warning "Cannot install Firebase CLI without npm"
        print_info "You can use FlutterFire CLI without Firebase CLI, but some features will be limited."
    fi
else
    FIREBASE_VERSION=$(firebase --version)
    print_success "Firebase CLI installed: $FIREBASE_VERSION"
fi

# =============================================================================
# Step 3: Check/Install FlutterFire CLI
# =============================================================================

print_header "Step 3: Checking FlutterFire CLI"

if ! command_exists flutterfire; then
    print_step "Installing FlutterFire CLI..."
    dart pub global activate flutterfire_cli
    
    # Add to PATH if not already there
    if [[ ":$PATH:" != *":$HOME/.pub-cache/bin:"* ]]; then
        export PATH="$PATH":"$HOME/.pub-cache/bin"
        print_info "Added Dart global bin to PATH (this session only)"
        print_warning "Add this to your ~/.zshrc or ~/.bashrc permanently:"
        echo -e "${YELLOW}export PATH=\"\$PATH\":\"\$HOME/.pub-cache/bin\"${NC}"
    fi
    
    print_success "FlutterFire CLI installed"
else
    FLUTTERFIRE_VERSION=$(flutterfire --version 2>&1 | head -n 1 || echo "installed")
    print_success "FlutterFire CLI installed: $FLUTTERFIRE_VERSION"
fi

# =============================================================================
# Step 4: Firebase Login
# =============================================================================

print_header "Step 4: Firebase Authentication"

if command_exists firebase; then
    # Check if already logged in
    if firebase projects:list >/dev/null 2>&1; then
        print_success "Already logged in to Firebase"
    else
        print_step "Logging in to Firebase..."
        firebase login
        
        if [ $? -eq 0 ]; then
            print_success "Successfully logged in to Firebase"
        else
            print_error "Firebase login failed"
            exit 1
        fi
    fi
else
    print_info "Skipping Firebase login (Firebase CLI not available)"
fi

# =============================================================================
# Step 5: Select/Create Firebase Project
# =============================================================================

print_header "Step 5: Firebase Project Setup"

if [ -z "$FIREBASE_PROJECT" ]; then
    if command_exists firebase; then
        print_step "Available Firebase projects:"
        firebase projects:list
        echo ""
    fi
    
    read -p "Enter Firebase project ID (or press Enter to create new): " FIREBASE_PROJECT
    
    if [ -z "$FIREBASE_PROJECT" ]; then
        print_info "Firebase project IDs are globally unique across ALL Firebase users."
        print_info "Recommendation: Use format '<yourname>-<appname>' or add random suffix"
        print_info "Examples: 'john-portfolio-2024', 'acme-app-x7k9', 'mycompany-website'"
        echo ""
        read -p "Enter new project ID (lowercase, hyphens only): " FIREBASE_PROJECT
        
        if [ -z "$FIREBASE_PROJECT" ]; then
            print_error "Project ID is required"
            exit 1
        fi
        
        if command_exists firebase; then
            print_step "Creating Firebase project: $FIREBASE_PROJECT"
            print_info "This may take a minute..."
            
            if firebase projects:create "$FIREBASE_PROJECT" 2>&1 | tee /tmp/firebase_create_output.txt; then
                print_success "Firebase project created successfully!"
            else
                # Check if it's a duplicate ID error
                if grep -q "already a project with ID" /tmp/firebase_create_output.txt; then
                    print_error "Project ID '$FIREBASE_PROJECT' is already taken (by someone else globally)"
                    print_warning "Firebase project IDs are unique across ALL users, not just your account"
                    echo ""
                    print_info "Try adding a unique suffix, for example:"
                    echo "   • ${FIREBASE_PROJECT}-$(date +%Y)"
                    echo "   • ${FIREBASE_PROJECT}-prod"
                    echo "   • ${FIREBASE_PROJECT}-$(whoami)"
                    echo "   • ${FIREBASE_PROJECT}-$(openssl rand -hex 3)"
                    echo ""
                    
                    # Offer to retry with a suffix
                    read -p "Would you like to retry with '${FIREBASE_PROJECT}-$(date +%Y)'? [Y/n]: " -n 1 -r
                    echo
                    if [[ $REPLY =~ ^[Yy]$ ]] || [[ -z $REPLY ]]; then
                        FIREBASE_PROJECT="${FIREBASE_PROJECT}-$(date +%Y)"
                        print_step "Trying: $FIREBASE_PROJECT"
                        
                        if firebase projects:create "$FIREBASE_PROJECT"; then
                            print_success "Firebase project created successfully!"
                        else
                            print_error "Still failed. Please create manually at: https://console.firebase.google.com"
                            echo ""
                            read -p "Enter the project ID after creating it manually: " FIREBASE_PROJECT
                            
                            if [ -z "$FIREBASE_PROJECT" ]; then
                                print_error "Project ID is required"
                                exit 1
                            fi
                        fi
                    else
                        print_info "Please create the project manually at: https://console.firebase.google.com"
                        echo ""
                        read -p "Enter the project ID after creating it manually: " FIREBASE_PROJECT
                        
                        if [ -z "$FIREBASE_PROJECT" ]; then
                            print_error "Project ID is required"
                            exit 1
                        fi
                    fi
                else
                    print_error "Failed to create project (unknown error)"
                    print_info "You can create it manually at: https://console.firebase.google.com"
                    echo ""
                    read -p "Enter the project ID after creating it manually: " FIREBASE_PROJECT
                    
                    if [ -z "$FIREBASE_PROJECT" ]; then
                        print_error "Project ID is required"
                        exit 1
                    fi
                fi
            fi
            
            # Clean up temp file
            rm -f /tmp/firebase_create_output.txt
        else
            print_info "Please create the project manually at: https://console.firebase.google.com"
            print_warning "Remember: Project IDs must be globally unique across all Firebase users"
            echo ""
            read -p "Enter the project ID after creating it: " FIREBASE_PROJECT
            
            if [ -z "$FIREBASE_PROJECT" ]; then
                print_error "Project ID is required"
                exit 1
            fi
        fi
    fi
fi

print_success "Using Firebase project: $FIREBASE_PROJECT"

# =============================================================================
# Step 6: Configure Flutter App with FlutterFire
# =============================================================================

print_header "Step 6: Configuring Flutter App"

print_step "Running FlutterFire configure for platforms: $PLATFORMS"
print_info "This will create firebase_options.dart and platform-specific config files"

# Build FlutterFire command
FLUTTERFIRE_CMD="flutterfire configure --project=$FIREBASE_PROJECT"

# Add platforms if specified
if [ ! -z "$PLATFORMS" ]; then
    FLUTTERFIRE_CMD="$FLUTTERFIRE_CMD --platforms=$PLATFORMS"
fi

# Add yes flag for non-interactive mode
FLUTTERFIRE_CMD="$FLUTTERFIRE_CMD --yes"

print_info "Running: $FLUTTERFIRE_CMD"
eval $FLUTTERFIRE_CMD

if [ $? -eq 0 ]; then
    print_success "FlutterFire configuration completed"
    
    # Verify firebase_options.dart was created
    if [ -f "lib/firebase_options.dart" ]; then
        print_success "Created lib/firebase_options.dart"
    else
        print_warning "lib/firebase_options.dart not found"
    fi
    
    # Check platform-specific files
    if [[ $PLATFORMS == *"ios"* ]] && [ -f "ios/Runner/GoogleService-Info.plist" ]; then
        print_success "Created ios/Runner/GoogleService-Info.plist"
    fi
    
    if [[ $PLATFORMS == *"android"* ]] && [ -f "android/app/google-services.json" ]; then
        print_success "Created android/app/google-services.json"
    fi
    
    if [[ $PLATFORMS == *"macos"* ]] && [ -f "macos/Runner/GoogleService-Info.plist" ]; then
        print_success "Created macos/Runner/GoogleService-Info.plist"
    fi
else
    print_error "FlutterFire configuration failed"
    exit 1
fi

# =============================================================================
# Step 7: Add Firebase Packages to pubspec.yaml
# =============================================================================

if [ "$SKIP_PACKAGES" = false ]; then
    print_header "Step 7: Adding Firebase Packages"
    
    # Backup pubspec.yaml
    cp pubspec.yaml pubspec.yaml.backup
    print_info "Backed up pubspec.yaml to pubspec.yaml.backup"
    
    # Create temporary file with packages to add
    cat > firebase_packages.yaml << 'EOF'

  # Firebase packages (added by setup-firebase.sh)
EOF
    
    # Add packages based on services
    IFS=',' read -ra SERVICE_ARRAY <<< "$SERVICES"
    for service in "${SERVICE_ARRAY[@]}"; do
        case $service in
            core)
                echo "  firebase_core: ^2.24.0" >> firebase_packages.yaml
                print_step "Adding firebase_core"
                ;;
            auth)
                echo "  firebase_auth: ^4.16.0" >> firebase_packages.yaml
                print_step "Adding firebase_auth"
                ;;
            firestore)
                echo "  cloud_firestore: ^4.14.0" >> firebase_packages.yaml
                print_step "Adding cloud_firestore"
                ;;
            storage)
                echo "  firebase_storage: ^11.6.0" >> firebase_packages.yaml
                print_step "Adding firebase_storage"
                ;;
            analytics)
                echo "  firebase_analytics: ^10.8.0" >> firebase_packages.yaml
                print_step "Adding firebase_analytics"
                ;;
            messaging)
                echo "  firebase_messaging: ^14.7.0" >> firebase_packages.yaml
                print_step "Adding firebase_messaging"
                ;;
            crashlytics)
                echo "  firebase_crashlytics: ^3.4.0" >> firebase_packages.yaml
                print_step "Adding firebase_crashlytics"
                ;;
            performance)
                echo "  firebase_performance: ^0.9.3+0" >> firebase_packages.yaml
                print_step "Adding firebase_performance"
                ;;
            remote_config)
                echo "  firebase_remote_config: ^4.3.0" >> firebase_packages.yaml
                print_step "Adding firebase_remote_config"
                ;;
        esac
    done
    
    # Insert packages before dev_dependencies
    awk '
        /^dev_dependencies:/ {
            while ((getline line < "firebase_packages.yaml") > 0) {
                print line
            }
            close("firebase_packages.yaml")
        }
        { print }
    ' pubspec.yaml > pubspec.yaml.tmp
    
    mv pubspec.yaml.tmp pubspec.yaml
    rm firebase_packages.yaml
    
    print_success "Added Firebase packages to pubspec.yaml"
    
    # Run flutter pub get
    print_step "Running flutter pub get..."
    flutter pub get
    
    if [ $? -eq 0 ]; then
        print_success "Dependencies installed"
    else
        print_error "flutter pub get failed"
        print_info "Restoring backup..."
        mv pubspec.yaml.backup pubspec.yaml
        exit 1
    fi
    
    rm pubspec.yaml.backup
else
    print_info "Skipping package installation (--skip-packages flag)"
fi

# =============================================================================
# Step 8: Update main.dart with Firebase Initialization
# =============================================================================

print_header "Step 8: Updating main.dart"

if [ -f "lib/main.dart" ]; then
    # Check if Firebase is already initialized
    if grep -q "Firebase.initializeApp" lib/main.dart; then
        print_info "Firebase already initialized in main.dart"
    else
        print_step "Adding Firebase initialization to main.dart"
        
        # Backup main.dart
        cp lib/main.dart lib/main.dart.backup
        
        # Check if imports exist
        if ! grep -q "import 'package:firebase_core/firebase_core.dart';" lib/main.dart; then
            # Add imports at the top (after existing imports)
            awk '/^import/ { imports = imports $0 "\n"; next }
                 !printed && !/^import/ && !/^$/ && !/^\/\// { 
                     print imports
                     print "import '\''package:firebase_core/firebase_core.dart'\'';"
                     print "import '\''firebase_options.dart'\'';"
                     print ""
                     printed = 1
                 }
                 { print }' lib/main.dart > lib/main.dart.tmp
            mv lib/main.dart.tmp lib/main.dart
            print_success "Added Firebase imports"
        fi
        
        # Update main() function to be async and initialize Firebase
        if grep -q "void main()" lib/main.dart; then
            sed -i.bak 's/void main() {/void main() async {\n  WidgetsFlutterBinding.ensureInitialized();\n  await Firebase.initializeApp(\n    options: DefaultFirebaseOptions.currentPlatform,\n  );/' lib/main.dart
            rm lib/main.dart.bak
            print_success "Updated main() function"
        elif grep -q "void main() async" lib/main.dart; then
            # Already async, just add initialization
            sed -i.bak '/void main() async {/a\
  WidgetsFlutterBinding.ensureInitialized();\
  await Firebase.initializeApp(\
    options: DefaultFirebaseOptions.currentPlatform,\
  );
' lib/main.dart
            rm lib/main.dart.bak 2>/dev/null || true
            print_success "Added Firebase initialization to async main()"
        fi
        
        print_success "Updated main.dart with Firebase initialization"
        rm lib/main.dart.backup
    fi
else
    print_warning "lib/main.dart not found - skipping automatic update"
    print_info "You'll need to manually add Firebase initialization"
fi

# =============================================================================
# Step 9: Platform-Specific Configuration
# =============================================================================

print_header "Step 9: Platform-Specific Configuration"

# iOS Configuration
if [[ $PLATFORMS == *"ios"* ]]; then
    print_step "Checking iOS configuration..."
    
    # Check minimum iOS version in Podfile
    if [ -f "ios/Podfile" ]; then
        if grep -q "platform :ios, '12.0'" ios/Podfile || grep -q "platform :ios, '1[2-9]" ios/Podfile; then
            print_success "iOS minimum version is 12.0 or higher (Firebase compatible)"
        else
            print_warning "iOS minimum version should be 12.0 or higher"
            print_info "Update ios/Podfile: platform :ios, '12.0'"
        fi
    fi
    
    # Install pods
    if [ -d "ios" ] && [ -f "ios/Podfile" ]; then
        print_step "Installing iOS pods..."
        cd ios
        pod install --repo-update
        cd ..
        print_success "iOS pods installed"
    fi
fi

# Android Configuration
if [[ $PLATFORMS == *"android"* ]]; then
    print_step "Checking Android configuration..."
    
    # Check minimum SDK version
    if [ -f "android/app/build.gradle" ]; then
        if grep -q "minSdkVersion 21" android/app/build.gradle || grep -q "minSdkVersion [2-9][1-9]" android/app/build.gradle; then
            print_success "Android minimum SDK is 21 or higher (Firebase compatible)"
        else
            print_warning "Android minimum SDK should be 21 or higher"
            print_info "Update android/app/build.gradle: minSdkVersion 21"
        fi
    fi
    
    # Check for Google Services plugin
    if [ -f "android/build.gradle" ]; then
        if grep -q "com.google.gms:google-services" android/build.gradle; then
            print_success "Google Services plugin found in android/build.gradle"
        else
            print_warning "Google Services plugin not found"
            print_info "Add to android/build.gradle:"
            echo -e "${YELLOW}buildscript {\n    dependencies {\n        classpath 'com.google.gms:google-services:4.4.0'\n    }\n}${NC}"
        fi
    fi
    
    if [ -f "android/app/build.gradle" ]; then
        if grep -q "com.google.gms.google-services" android/app/build.gradle; then
            print_success "Google Services plugin applied in android/app/build.gradle"
        else
            print_warning "Google Services plugin not applied"
            print_info "Add to android/app/build.gradle:"
            echo -e "${YELLOW}apply plugin: 'com.google.gms.google-services'${NC}"
        fi
    fi
fi

# macOS Configuration
if [[ $PLATFORMS == *"macos"* ]]; then
    print_step "Checking macOS configuration..."
    
    if [ -d "macos" ] && [ -f "macos/Podfile" ]; then
        print_step "Installing macOS pods..."
        cd macos
        pod install --repo-update
        cd ..
        print_success "macOS pods installed"
    fi
fi

# =============================================================================
# Step 10: Summary and Next Steps
# =============================================================================

print_header "🎉 Firebase Setup Complete!"

echo ""
echo -e "${GREEN}✅ Setup Summary:${NC}"
echo "   • Firebase project: $FIREBASE_PROJECT"
echo "   • Platforms configured: $PLATFORMS"
echo "   • Services added: $SERVICES"
echo ""

echo -e "${CYAN}📋 Generated Files:${NC}"
[ -f "lib/firebase_options.dart" ] && echo "   ✓ lib/firebase_options.dart"
[ -f "ios/Runner/GoogleService-Info.plist" ] && echo "   ✓ ios/Runner/GoogleService-Info.plist"
[ -f "android/app/google-services.json" ] && echo "   ✓ android/app/google-services.json"
[ -f "macos/Runner/GoogleService-Info.plist" ] && echo "   ✓ macos/Runner/GoogleService-Info.plist"
echo ""

echo -e "${BLUE}🚀 Next Steps:${NC}"
echo "   1. Enable Firebase services in console:"
echo "      https://console.firebase.google.com/project/$FIREBASE_PROJECT"
echo ""
echo "   2. For Authentication:"
echo "      • Enable sign-in methods (Email/Password, Google, etc.)"
echo ""
echo "   3. For Firestore:"
echo "      • Create database and set security rules"
echo ""
echo "   4. For Storage:"
echo "      • Create storage bucket and set security rules"
echo ""
echo "   5. Test your setup:"
echo "      flutter run"
echo ""

echo -e "${YELLOW}📚 Documentation:${NC}"
echo "   • Firebase Console: https://console.firebase.google.com"
echo "   • FlutterFire Docs: https://firebase.flutter.dev"
echo "   • Setup Guide: flutter-portfolio/shared/firebase_setup_patterns/README.md"
echo ""

print_success "Firebase is ready to use! 🔥"

