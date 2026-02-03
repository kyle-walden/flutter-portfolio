# Flutter Scaffold Shell Aliases
# Add these to your ~/.zshrc or ~/.bashrc for easy access

# Get the directory where this script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Quick scaffold command
alias flutter-scaffold="bash $SCRIPT_DIR/scaffold-flutter-project.sh"

# Firebase setup command
alias firebase-setup="bash $SCRIPT_DIR/firebase_setup_patterns/setup-firebase.sh"

# Example usage:
#   flutter-scaffold my_awesome_app
#   firebase-setup

# Add a new feature to current Flutter project
flutter-add-feature() {
    if [ $# -eq 0 ]; then
        echo "Usage: flutter-add-feature <feature_name>"
        echo "Example: flutter-add-feature booking"
        return 1
    fi
    
    FEATURE=$1
    
    if [ ! -d "lib/features" ]; then
        echo "Error: Not in a Flutter project root (lib/features not found)"
        return 1
    fi
    
    echo "Creating feature: $FEATURE"
    mkdir -p "lib/features/$FEATURE"/{view,state,repo,models,widgets,tests}
    
    cat > "lib/features/$FEATURE/repo/${FEATURE}_repository.dart" << EOF
import '../../../core/services/local_storage_service.dart';

/// Repository for $FEATURE feature.
class ${FEATURE^}Repository {
  final LocalStorageService _storage;

  ${FEATURE^}Repository(this._storage);

  // Add data access methods here
}
EOF

    cat > "lib/features/$FEATURE/state/${FEATURE}_provider.dart" << EOF
import 'package:flutter/foundation.dart';
import '../repo/${FEATURE}_repository.dart';

/// Provider for $FEATURE feature.
class ${FEATURE^}Provider extends ChangeNotifier {
  final ${FEATURE^}Repository _repo;
  bool isLoading = false;

  ${FEATURE^}Provider(this._repo);

  // Add state management methods here
}
EOF

    cat > "lib/features/$FEATURE/view/${FEATURE}_screen.dart" << EOF
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/${FEATURE}_provider.dart';

/// Screen for $FEATURE feature.
class ${FEATURE^}Screen extends StatelessWidget {
  const ${FEATURE^}Screen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<${FEATURE^}Provider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('${FEATURE^}')),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : const Center(child: Text('${FEATURE^} Screen')),
    );
  }
}
EOF

    echo "✓ Feature '$FEATURE' created!"
    echo ""
    echo "Files created:"
    echo "  - lib/features/$FEATURE/repo/${FEATURE}_repository.dart"
    echo "  - lib/features/$FEATURE/state/${FEATURE}_provider.dart"
    echo "  - lib/features/$FEATURE/view/${FEATURE}_screen.dart"
    echo ""
    echo "Next steps:"
    echo "  1. Add provider to main.dart MultiProvider"
    echo "  2. Implement repository methods"
    echo "  3. Add state management logic to provider"
    echo "  4. Build UI in screen"
}

# Check architecture compliance
flutter-check-compliance() {
    echo "🔍 Checking architecture compliance..."
    echo ""
    
    # Check for violations in views
    echo "Checking for direct Firebase calls in views..."
    FIREBASE_VIOLATIONS=$(grep -r "FirebaseFirestore.instance\|FirebaseAuth.instance" lib/features/*/view/ 2>/dev/null | wc -l)
    if [ $FIREBASE_VIOLATIONS -eq 0 ]; then
        echo "✓ No direct Firebase calls in views"
    else
        echo "✗ Found $FIREBASE_VIOLATIONS Firebase violations in views"
        grep -r "FirebaseFirestore.instance\|FirebaseAuth.instance" lib/features/*/view/ 2>/dev/null
    fi
    
    echo ""
    echo "Checking for direct HTTP calls in views..."
    HTTP_VIOLATIONS=$(grep -r "http\.\(get\|post\|put\|delete\)" lib/features/*/view/ 2>/dev/null | wc -l)
    if [ $HTTP_VIOLATIONS -eq 0 ]; then
        echo "✓ No direct HTTP calls in views"
    else
        echo "✗ Found $HTTP_VIOLATIONS HTTP violations in views"
        grep -r "http\.\(get\|post\|put\|delete\)" lib/features/*/view/ 2>/dev/null
    fi
    
    echo ""
    echo "Checking for large files (potential god objects)..."
    find lib -name "*.dart" -exec wc -l {} + | sort -rn | head -10 | while read lines file; do
        if [ $lines -gt 300 ]; then
            echo "⚠ $file ($lines lines) - consider splitting"
        fi
    done
    
    echo ""
    echo "Running flutter analyze..."
    flutter analyze
}

# Quick test current project
alias flutter-test-quick='flutter test --coverage && flutter analyze'

# Format all Dart files
alias flutter-format-all='dart format lib/ test/'

# Clean and get dependencies
alias flutter-clean-get='flutter clean && flutter pub get'

# Show architecture structure
flutter-show-structure() {
    if [ -d "lib" ]; then
        echo "📁 Project Structure:"
        tree -L 3 -I 'build|.dart_tool' lib/ 2>/dev/null || find lib/ -type d | head -30
    else
        echo "Not in a Flutter project directory"
    fi
}

echo "Flutter scaffold aliases loaded!"
echo "Available commands:"
echo "  flutter-scaffold <name>       - Create new Flutter project"
echo "  firebase-setup [options]      - Setup Firebase in current project"
echo "  flutter-add-feature <name>    - Add feature to current project"
echo "  flutter-check-compliance      - Validate architecture"
echo "  flutter-test-quick            - Run tests + analyze"
echo "  flutter-format-all            - Format all Dart code"
echo "  flutter-clean-get             - Clean and reinstall deps"
echo "  flutter-show-structure        - Show project structure"
