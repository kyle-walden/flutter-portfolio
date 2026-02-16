# Firebase Emulator Setup Guide

Quick reference for setting up Firebase Emulator Suite for Cloud Functions testing.

---

## Quick Setup

### 1. Install Java (Required)
```bash
# macOS
brew install openjdk@17

# Linux (Ubuntu/Debian)
sudo apt-get install openjdk-17-jdk

# Verify
java -version
```

### 2. Configure firebase.json
```json
{
  "emulators": {
    "functions": { "port": 5001 },
    "firestore": { "port": 8080 },
    "auth": { "port": 9099 },
    "storage": { "port": 9199 },
    "ui": { "enabled": true, "port": 4000 }
  }
}
```

### 3. Start Emulator
```bash
# All emulators
firebase emulators:start

# Specific emulators
firebase emulators:start --only functions,firestore

# With UI
firebase emulators:start  # UI at http://localhost:4000
```

---

## Common Commands

```bash
# Start emulator
firebase emulators:start

# Start specific emulators only
firebase emulators:start --only functions

# Start with import (seed data)
firebase emulators:start --import=./test-data

# Export data on exit
firebase emulators:start --export-on-exit=./test-data

# Run tests with emulator
firebase emulators:exec 'npm test'

# Kill emulator
pkill -f "firebase emulators"
```

---

## Testing Patterns

### HTTP Functions via curl
```bash
# Basic call
curl http://127.0.0.1:5001/<PROJECT>/us-central1/<FUNCTION> \
  -H "Content-Type: application/json" \
  -d '{"data": {...}}'

# Example
curl -X POST http://127.0.0.1:5001/mobmeb-kw/us-central1/generateMemberToken \
  -H "Content-Type: application/json" \
  -d '{"data":{"memberId":"test-123","venueId":"venue-456"}}'
```

### Integration Tests with Emulator
```typescript
// Point to emulator
process.env.FIRESTORE_EMULATOR_HOST = 'localhost:8080';
process.env.FIREBASE_AUTH_EMULATOR_HOST = 'localhost:9099';

// Initialize
admin.initializeApp({ projectId: 'test-project' });

// Use normally
const db = admin.firestore();
await db.collection('test').doc('id').set({ data: 'value' });
```

---

## Emulator Ports

| Service   | Port | URL                      |
|-----------|------|--------------------------|
| Functions | 5001 | http://localhost:5001    |
| Firestore | 8080 | http://localhost:8080    |
| Auth      | 9099 | http://localhost:9099    |
| Storage   | 9199 | http://localhost:9199    |
| UI        | 4000 | http://localhost:4000    |

---

## Seed Data

### Export Data
```bash
# Export current emulator data
firebase emulators:export ./test-data

# Start with exported data
firebase emulators:start --import=./test-data
```

### Programmatic Seeding
```typescript
// seed.ts
import * as admin from 'firebase-admin';

process.env.FIRESTORE_EMULATOR_HOST = 'localhost:8080';
admin.initializeApp({ projectId: 'test-project' });

async function seed() {
  const db = admin.firestore();
  
  await db.collection('members').doc('test-123').set({
    name: 'Test Member',
    status: 'active',
  });
  
  console.log('✅ Seeded');
}

seed();
```

Run: `npx ts-node seed.ts`

---

## Troubleshooting

### Java Not Found
```bash
# Install Java
brew install openjdk@17

# Add to PATH (macOS)
echo 'export PATH="/opt/homebrew/opt/openjdk@17/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
```

### Port Already in Use
```bash
# Find process using port
lsof -i :5001

# Kill process
kill -9 <PID>
```

### Triggers Not Firing
- Ensure Firestore emulator is running (not just functions)
- Check function is exported in `src/index.ts`
- View logs for errors

### Can't Access UI
- Check `firebase.json` has `"ui": { "enabled": true }`
- Try `http://127.0.0.1:4000` instead of `localhost`
- Check firewall settings

---

## Integration with Tests

### Jest Configuration
```javascript
// jest.config.js
module.exports = {
  testEnvironment: 'node',
  setupFilesAfterEnv: ['<rootDir>/tests/test-setup.ts'],
};
```

### Test Setup
```typescript
// tests/test-setup.ts
process.env.FIRESTORE_EMULATOR_HOST = 'localhost:8080';
process.env.FIREBASE_AUTH_EMULATOR_HOST = 'localhost:9099';
process.env.FIREBASE_STORAGE_EMULATOR_HOST = 'localhost:9199';
```

### Run Tests with Emulator
```bash
# Terminal 1: Start emulator
firebase emulators:start

# Terminal 2: Run tests
npm run test:integration

# Or combined (auto-start/stop)
firebase emulators:exec 'npm run test:integration'
```

---

## Best Practices

### ✅ DO
- Use emulator for all local development
- Export test data for reproducible tests
- Clear data between integration test runs
- Use UI for debugging
- Test triggers with emulator (not mocks)

### ❌ DON'T
- Test against production Firebase
- Commit emulator-data to Git (add to .gitignore)
- Skip integration tests
- Use emulator for load testing (not realistic)

---

## Example Test Script

```bash
#!/bin/bash
# test-functions.sh

EMULATOR_URL="http://127.0.0.1:5001/<PROJECT>/us-central1"

echo "Testing functions..."

# Test health check
curl -s "${EMULATOR_URL}/healthCheck"

# Test callable function
curl -s -X POST "${EMULATOR_URL}/myFunction" \
  -H "Content-Type: application/json" \
  -d '{"data":{"test":true}}' | jq '.'

echo "✅ Tests complete"
```

---

## Resources

- [Firebase Emulator Suite Docs](https://firebase.google.com/docs/emulator-suite)
- [Testing Functions](https://firebase.google.com/docs/functions/unit-testing)
- [Full Emulator Guide](../../mobmeb/backend/functions/tests/emulator-testing.md)

---

**Next:** See [testing_patterns.md](./testing_patterns.md) for specific test patterns
