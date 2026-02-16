# Firebase Cloud Functions Testing Patterns

Comprehensive testing patterns and best practices for Firebase Cloud Functions across all projects.

---

## 📚 Documentation Structure

### Core Guides
- **[README.md](./README.md)** - This file (overview and quick start)
- **[testing_patterns.md](./testing_patterns.md)** - Universal testing patterns
- **[emulator_setup.md](./emulator_setup.md)** - Complete emulator setup guide
- **[best_practices.md](./best_practices.md)** - Best practices and anti-patterns
- **[example_tests.md](./example_tests.md)** - Real-world test examples

### Quick Links
- [Architecture Patterns](../architecture_patterns.md)
- [Testing Strategies](../testing_strategies.md)
- [Firebase Setup Patterns](../firebase_setup_patterns/)

---

## 🚀 Quick Start

### 1. Install Prerequisites
```bash
# Install Java (required for Firestore emulator)
brew install openjdk@17  # macOS
# OR
sudo apt-get install openjdk-17-jdk  # Linux

# Install Firebase CLI
npm install -g firebase-tools

# Install test dependencies
npm install --save-dev \
  jest \
  ts-jest \
  @types/jest \
  firebase-functions-test \
  @types/node
```

### 2. Configure Jest
```javascript
// jest.config.js
module.exports = {
  preset: 'ts-jest',
  testEnvironment: 'node',
  roots: ['<rootDir>/tests'],
  testMatch: ['**/?(*.)+(spec|test).ts'],
  collectCoverageFrom: ['src/**/*.ts'],
  coverageDirectory: 'coverage',
  setupFilesAfterEnv: ['<rootDir>/tests/test-setup.ts'],
};
```

### 3. Add Test Scripts
```json
// package.json
{
  "scripts": {
    "test": "jest",
    "test:watch": "jest --watch",
    "test:coverage": "jest --coverage",
    "test:integration": "jest tests/integration",
    "test:emulator": "firebase emulators:exec --project test-project 'npm run test:integration'"
  }
}
```

### 4. Write Your First Test
```typescript
// tests/unit/myFunction.test.ts
import { myFunction } from '../../src/myFunction';

describe('myFunction', () => {
  it('should return success', async () => {
    const result = await myFunction({ data: { test: true } });
    expect(result.success).toBe(true);
  });
});
```

### 5. Run Tests
```bash
# Unit tests (fast)
npm test

# Integration tests (requires emulator)
firebase emulators:start  # Terminal 1
npm run test:integration  # Terminal 2

# Or combined
npm run test:emulator
```

---

## 🎯 Testing Approaches

### **Level 1: Unit Tests** ⚡ Fast
- Test functions in isolation
- Mock all external dependencies
- No emulator required
- **Use for:** Business logic, validation, transformations
- **Coverage goal:** 80%+

```typescript
// Example: Pure unit test
it('should validate email format', () => {
  expect(validateEmail('test@example.com')).toBe(true);
  expect(validateEmail('invalid')).toBe(false);
});
```

### **Level 2: Integration Tests** 🔄 Realistic
- Test with Firebase emulator
- Verify trigger behavior
- Test auth flows
- **Use for:** End-to-end function flows, triggers
- **Coverage goal:** Critical paths

```typescript
// Example: Integration test with emulator
it('should extend membership on payment', async () => {
  await firestore.collection('payments').add(paymentData);
  await waitFor(2000); // Wait for trigger
  const member = await firestore.collection('members').doc('id').get();
  expect(member.data().status).toBe('active');
});
```

### **Level 3: Manual Testing** 🛠️ Interactive
- Test via curl/Postman
- Inspect in Emulator UI
- Real-time debugging
- **Use for:** Prototyping, debugging, exploration

```bash
# Example: Manual curl test
curl -X POST http://localhost:5001/project/region/function \
  -d '{"data": {"test": true}}'
```

### **Level 4: E2E Production** 🌐 Final Verification
- Test deployed functions
- Use test documents (test- prefix)
- Monitor production logs
- **Use for:** Pre-release smoke tests

---

## 📋 Testing Checklist

### Before Writing Tests
- [ ] Understand function purpose and inputs/outputs
- [ ] Identify all dependencies (Firestore, Auth, APIs)
- [ ] Determine which testing level is appropriate
- [ ] Plan test data needs

### Writing Tests
- [ ] Test happy path first
- [ ] Test all error cases
- [ ] Test validation logic
- [ ] Test edge cases (null, empty, boundaries)
- [ ] Mock external dependencies
- [ ] Use descriptive test names

### After Writing Tests
- [ ] Verify all tests pass
- [ ] Check code coverage (aim for 80%+)
- [ ] Run integration tests with emulator
- [ ] Review test readability
- [ ] Update documentation

---

## 📊 Test Organization

### Recommended Structure
```
functions/
├── src/
│   ├── index.ts
│   ├── auth/
│   ├── members/
│   ├── payments/
│   └── utils/
├── tests/
│   ├── README.md
│   ├── jest.config.js
│   ├── test-setup.ts
│   ├── helpers/
│   │   ├── test-helpers.ts
│   │   ├── mock-factories.ts
│   │   └── firebase-test-utils.ts
│   ├── unit/
│   │   ├── auth/
│   │   │   └── createUser.test.ts
│   │   ├── members/
│   │   │   └── updateMember.test.ts
│   │   └── utils/
│   │       └── validation.test.ts
│   └── integration/
│       ├── auth-flow.test.ts
│       └── payment-flow.test.ts
└── package.json
```

### Naming Conventions
- **Test files:** `functionName.test.ts`
- **Test suites:** `describe('functionName', () => {})`
- **Test cases:** `it('should do something specific', () => {})`
- **Mock factories:** `createMockMember()`, `createMockPayment()`

---

## 🏗️ Common Patterns

### Mock Firebase Admin
```typescript
import * as admin from 'firebase-admin';

jest.mock('firebase-admin');

beforeEach(() => {
  const mockFirestore = {
    collection: jest.fn().mockReturnThis(),
    doc: jest.fn().mockReturnThis(),
    get: jest.fn(),
    set: jest.fn(),
  };
  
  (admin.firestore as jest.Mock).mockReturnValue(mockFirestore);
});
```

### Test HTTP Callable Functions
```typescript
it('should validate input parameters', async () => {
  await expect(
    myCallableFunction({ data: {} })
  ).rejects.toThrow('Missing required parameter');
});
```

### Test Firestore Triggers
```typescript
import * as test from 'firebase-functions-test';

const testEnv = test();

it('should update related documents', async () => {
  const snap = testEnv.firestore.makeDocumentSnapshot(
    { status: 'active' },
    'members/test-id'
  );
  
  const wrapped = testEnv.wrap(onMemberUpdate);
  await wrapped(snap);
  
  // Verify side effects
});
```

### Test with Auth Context
```typescript
it('should only allow owner role', async () => {
  const context = {
    auth: { uid: 'test-uid', token: { role: 'staff' } }
  };
  
  await expect(
    ownerOnlyFunction({ data: {} }, context)
  ).rejects.toThrow('Unauthorized');
});
```

---

## 🎓 Learning Path

### Beginner
1. Read [testing_patterns.md](./testing_patterns.md)
2. Write simple unit tests for utility functions
3. Practice mocking Firebase Admin
4. Use test helpers and factories

### Intermediate
1. Read [emulator_setup.md](./emulator_setup.md)
2. Set up Firebase Emulator
3. Write integration tests for triggers
4. Test with authentication context
5. Achieve 80%+ code coverage

### Advanced
1. Read [best_practices.md](./best_practices.md)
2. Implement custom Jest matchers
3. Write performance tests
4. Set up CI/CD test automation
5. Create reusable testing framework

---

## 🔗 Resources

### Official Documentation
- [Firebase Functions Testing](https://firebase.google.com/docs/functions/unit-testing)
- [Jest Documentation](https://jestjs.io/)
- [Firebase Emulator Suite](https://firebase.google.com/docs/emulator-suite)

### Example Projects
- [mobmeb Functions Tests](../../mobmeb/backend/functions/tests/)
- [Pitboard Functions Tests](../../Pitboard/flutter_app/functions/tests/)

### Related Guides
- [Architecture Patterns](../architecture_patterns.md)
- [Testing Strategies](../testing_strategies.md)
- [Firebase Setup Patterns](../firebase_setup_patterns/)

---

## 🆘 Troubleshooting

### Tests Won't Run
```bash
# Clear Jest cache
jest --clearCache

# Reinstall dependencies
rm -rf node_modules package-lock.json
npm install
```

### Emulator Won't Start
```bash
# Check if Java is installed
java -version

# Check if ports are in use
lsof -i :5001
lsof -i :8080

# Kill processes on ports
kill -9 <PID>
```

### Timeout Errors
```typescript
// Increase timeout
jest.setTimeout(10000);

// Or per-test
it('slow test', async () => {
  // test code
}, 10000);
```

### Mock Not Working
```typescript
// Reset mocks before each test
beforeEach(() => {
  jest.clearAllMocks();
  jest.resetModules();
});
```

---

## 💡 Tips & Tricks

### Speed Up Tests
- Run unit tests in parallel: `jest --maxWorkers=4`
- Use `test.only()` to run single test
- Skip slow tests during development: `test.skip()`

### Better Test Output
- Use `--verbose` for detailed output
- Use `--silent` to suppress console.logs
- Generate HTML coverage report

### Debugging Tests
- Use `console.log()` liberally
- Run single test file: `jest path/to/test.test.ts`
- Use VS Code debugger with Jest

---

## 📝 Templates

### Basic Test Template
```typescript
import { myFunction } from '../../src/myFunction';

describe('myFunction', () => {
  beforeEach(() => {
    // Setup
  });

  afterEach(() => {
    // Cleanup
  });

  describe('Validation', () => {
    it('should reject invalid input', async () => {
      // Test
    });
  });

  describe('Success Cases', () => {
    it('should process valid input', async () => {
      // Test
    });
  });
});
```

### Integration Test Template
```typescript
import * as admin from 'firebase-admin';

process.env.FIRESTORE_EMULATOR_HOST = 'localhost:8080';

describe('Feature Integration', () => {
  let db: admin.firestore.Firestore;

  beforeAll(() => {
    admin.initializeApp({ projectId: 'test' });
    db = admin.firestore();
  });

  beforeEach(async () => {
    // Clear data
  });

  it('should work end-to-end', async () => {
    // Test
  });
});
```

---

**Next Steps:**
1. Read [testing_patterns.md](./testing_patterns.md) for detailed patterns
2. Set up emulator: [emulator_setup.md](./emulator_setup.md)
3. Review examples: [example_tests.md](./example_tests.md)
4. Apply to your project!
