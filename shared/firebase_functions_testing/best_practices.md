# Firebase Cloud Functions Testing Best Practices & Anti-Patterns

Learn what to do (and what NOT to do) when testing Cloud Functions.

---

## ✅ Best Practices

### 1. Test Organization

#### ✅ DO: Organize by Feature
```
tests/
├── unit/
│   ├── auth/
│   ├── members/
│   └── payments/
└── integration/
    ├── auth-flow.test.ts
    └── payment-flow.test.ts
```

#### ❌ DON'T: Mix all tests together
```
tests/
├── test1.test.ts
├── test2.test.ts
├── test3.test.ts  # Hard to find and maintain
```

---

### 2. Test Naming

#### ✅ DO: Use descriptive names
```typescript
describe('generateMemberToken', () => {
  it('should reject expired members', async () => {});
  it('should generate valid JWT for active members', async () => {});
  it('should include member data in token payload', async () => {});
});
```

#### ❌ DON'T: Use vague names
```typescript
describe('token', () => {
  it('test1', async () => {});  // What does  this test?
  it('works', async () => {});  // Works how?
});
```

---

### 3. Test Independence

#### ✅ DO: Each test should be independent
```typescript
describe('Member operations', () => {
  beforeEach(() => {
    // Fresh setup for EACH test
    mockFirestore = createCleanMock();
  });

  it('should create member', () => {
    // This test doesn't depend on previous tests
  });

  it('should update member', () => {
    // Clean slate here too
  });
});
```

#### ❌ DON'T: Create test dependencies
```typescript
describe('Member operations', () => {
  let memberId;

  it('should create member', () => {
    memberId = createMember();  // Next test depends on this
  });

  it('should update member', () => {
    updateMember(memberId);  // BREAKS if first test fails
  });
});
```

---

### 4. Mock External Dependencies

#### ✅ DO: Mock all external services
```typescript
import * as admin from 'firebase-admin';
import axios from 'axios';

jest.mock('firebase-admin');
jest.mock('axios');

it('should call Paystack API', async () => {
  (axios.post as jest.Mock).mockResolvedValue({ data: { success: true } });
  
  await processPayment({ amount: 50 });
  
  expect(axios.post).toHaveBeenCalledWith(
    expect.stringContaining('paystack'),
    expect.any(Object)
  );
});
```

#### ❌ DON'T: Make real API calls in unit tests
```typescript
it('should call Paystack API', async () => {
  // This will fail if network is down or API changes
  const result = await axios.post('https://api.paystack.co/...');
  expect(result.data.success).toBe(true);
});
```

---

### 5. Test Data Management

#### ✅ DO: Use factories for consistent data
```typescript
// mock-factories.ts
export const createMockMember = (overrides = {}) => ({
  id: 'test-member-123',
  name: 'Test Member',
  status: 'active',
  ...overrides,
});

// In tests
it('should work with active member', () => {
  const member = createMockMember({ status: 'active' });
  // ...
});

it('should reject expired member', () => {
  const member = createMockMember({ status: 'expired' });
  // ...
});
```

#### ❌ DON'T: Duplicate test data everywhere
```typescript
it('test 1', () => {
  const member = {
    id: 'test-123',
    name: 'Test',
    status: 'active',
    email: 'test@test.com',
    // ... 20 more properties
  };
});

it('test 2', () => {
  const member = {
    id: 'test-123',  // Copy-paste leads to inconsistency
    name: 'Test',
    status: 'active',
    // ... duplicated everywhere
  };
});
```

---

### 6. Assertion Quality

#### ✅ DO: Make specific assertions
```typescript
it('should generate valid token', async () => {
  const result = await generateToken();
  
  expect(result).toHaveProperty('token');
  expect(result).toHaveProperty('expiresAt');
  expect(result.token).toMatch(/^eyJ/);  // JWT format
  expect(result.expiresAt).toBeGreaterThan(Date.now());
});
```

#### ❌ DON'T: Make vague assertions
```typescript
it('should generate token', async () => {
  const result = await generateToken();
  expect(result).toBeTruthy();  // Too vague!
});
```

---

### 7. Error Testing

#### ✅ DO: Test all error scenarios
```typescript
describe('Error handling', () => {
  it('should reject missing parameters', async () => {
    await expect(fn({ data: {} }))
      .rejects.toThrow('Missing required parameter');
  });

  it('should reject invalid format', async () => {
    await expect(fn({ data: { email: 'invalid' } }))
      .rejects.toThrow('Invalid email format');
  });

  it('should handle Firestore errors gracefully', async () => {
    mockFirestore.get.mockRejectedValue(new Error('Deadline exceeded'));
    
    await expect(fn({ data: { id: 'test' } }))
      .rejects.toThrow('Database error');
  });
});
```

#### ❌ DON'T: Only test happy paths
```typescript
describe('Function tests', () => {
  it('should work', async () => {
    // Only testing when everything goes right
    const result = await fn({ data: { valid: true } });
    expect(result.success).toBe(true);
  });
  // ❌ No error tests!
});
```

---

### 8. Async Testing

#### ✅ DO: Use async/await correctly
```typescript
it('should handle promises', async () => {
  const result = await asyncFunction();
  expect(result).toBe('success');
});

it('should reject on error', async () => {
  await expect(asyncFunction()).rejects.toThrow('Error');
});
```

#### ❌ DON'T: Forget async/await
```typescript
it('should handle promises', () => {
  // ❌ This test will pass even if function fails!
  asyncFunction().then(result => {
    expect(result).toBe('success');
  });
});

it('should reject', () => {
  // ❌ Not waiting for promise to reject
  expect(asyncFunction()).rejects.toThrow();
});
```

---

### 9. Mock Cleanup

#### ✅ DO: Reset mocks between tests
```typescript
describe('Tests', () => {
  beforeEach(() => {
    jest.clearAllMocks();  // Clear call counts
    jest.resetModules();   // Reset module cache
  });

  it('test 1', () => {
    // Clean slate
  });

  it('test 2', () => {
    // No contamination from test 1
  });
});
```

#### ❌ DON'T: Let mocks pollute tests
```typescript
describe('Tests', () => {
  // ❌ No cleanup!

  it('test 1', () => {
    mockFn.mockReturnValue('value1');
    // ...
  });

  it('test 2', () => {
    // ❌ mockFn still has return value from test 1
    expect(mockFn).toHaveBeenCalledTimes(0);  // FAILS!
  });
});
```

---

### 10. Coverage Goals

#### ✅ DO: Aim for meaningful coverage
```typescript
// Aim for:
// - 80%+ overall coverage
// - 100% coverage for critical paths (auth, payments)
// - All error branches covered
// - All edge cases tested

// jest.config.js
coverageThreshold: {
  global: {
    branches: 80,
    functions: 80,
    lines: 80,
    statements: 80,
  },
  './src/critical/': {
    branches: 100,
    functions: 100,
    lines: 100,
    statements: 100,
  },
},
```

#### ❌ DON'T: Chase 100% coverage blindly
```typescript
// ❌ Testing getters/setters just for coverage
it('should set value', () => {
  obj.setValue(5);
  expect(obj.getValue()).toBe(5);
});

// ❌ Testing framework code
it('should export function', () => {
  expect(typeof myFunction).toBe('function');
});
```

---

## 🚫 Anti-Patterns

### 1. Testing Implementation Details
```typescript
// ❌ BAD: Testing how function works internally
it('should call helper function 3 times', () => {
  const helperSpy = jest.spyOn(helpers, 'helper');
  myFunction();
  expect(helperSpy).toHaveBeenCalledTimes(3);
});

// ✅ GOOD: Testing what function produces
it('should return correct result', () => {
  const result = myFunction();
  expect(result).toBe(expectedValue);
});
```

### 2. Testing Against Production
```typescript
// ❌ NEVER do this!
it('should fetch real data', async () => {
  const db = admin.firestore();  // Real Firestore!
  const doc = await db.collection('realUsers').doc('realId').get();
  expect(doc.exists).toBe(true);
});

// ✅ Use emulator or mocks
process.env.FIRESTORE_EMULATOR_HOST = 'localhost:8080';
```

### 3. Overly Complex Tests
```typescript
// ❌ BAD: Too much setup, hard to understand
it('should do many things', async () => {
  const user = createUser();
  const member = createMember(user);
  const payment = createPayment(member);
  const wallet = createWallet(member);
  const token = generateToken(member, wallet);
  const checkIn = processCheckIn(token, payment);
  
  expect(checkIn.success).toBe(true);  // What are we testing?
});

// ✅ GOOD: One thing per test
it('should process check-in with valid token', async () => {
  const token = createValidToken();
  const result = processCheckIn(token);
  expect(result.success).toBe(true);
});
```

### 4. Brittle Tests (Too Specific)
```typescript
// ❌ BAD: Breaks if error message changes
it('should reject invalid email', () => {
  expect(() => validateEmail('invalid'))
    .toThrow('Error at line 42: invalid email format detected in validator v2.3');
});

// ✅ GOOD: Tests intent, not exact message
it('should reject invalid email', () => {
  expect(() => validateEmail('invalid'))
    .toThrow(/invalid email/i);
});
```

### 5. Shared State Between Tests
```typescript
// ❌ BAD: Tests affect each other
let sharedMember;

it('creates member', () => {
  sharedMember = createMember();
});

it('updates member', () => {
  updateMember(sharedMember);  // Breaks if first test fails
});

// ✅ GOOD: Independent tests
it('creates and updates member', () => {
  const member = createMember();
  const updated = updateMember(member);
  expect(updated.status).toBe('updated');
});
```

---

## 🏆 Advanced Best Practices

### 1. Custom Jest Matchers
```typescript
// test-setup.ts
expect.extend({
  toBeValidJWT(received: string) {
    const isValid = /^eyJ[A-Za-z0-9-_]+\.eyJ[A-Za-z0-9-_]+\.[A-Za-z0-9-_]+$/.test(received);
    return {
      pass: isValid,
      message: () => `Expected ${received} to be a valid JWT`,
    };
  },
});

// In tests
expect(token).toBeValidJWT();
```

### 2. Test Helpers for Common Operations
```typescript
// test-helpers.ts
export async function createTestMember(overrides = {}) {
  const member = createMockMember(overrides);
  await mockFirestore._mockData['members/test-id'] = member;
  return member;
}

export async function expectMemberStatus(memberId: string, status: string) {
  const member = await getMember(memberId);
  expect(member.status).toBe(status);
}

// In tests (more readable!)
await createTestMember({ status: 'active' });
await expectMemberStatus('test-id', 'active');
```

### 3. Snapshot Testing (Use Sparingly)
```typescript
// ✅ GOOD: For complex JSON structures
it('should generate correct pass data', () => {
  const passData = generatePassData(member);
  expect(passData).toMatchSnapshot();
});

// ❌ BAD: For simple values
it('should return name', () => {
  expect(getName()).toMatchSnapshot();  // Overkill!
});
```

---

## 📊 Code Review Checklist

When reviewing tests, check for:

### Test Quality
- [ ] Tests have descriptive names
- [ ] Each test is independent
- [ ] Mocks are properly set up and cleaned up
- [ ] Assertions are specific and meaningful
- [ ] All error cases are tested
- [ ] Test data uses factories

### Test Coverage
- [ ] Happy path is tested
- [ ] Error cases are tested
- [ ] Edge cases are tested (null, empty, boundaries)
- [ ] Coverage report shows 80%+ overall
- [ ] Critical paths have 100% coverage

### Code Quality
- [ ] No test duplication
- [ ] No hardcoded values
- [ ] No testing against production
- [ ] No flaky tests (timing-dependent)
- [ ] Tests run fast (< 5s for unit tests)

---

## 🎯 Quick Reference

### DO ✅
- Use emulator for integration tests
- Mock external dependencies in unit tests
- Test error cases thoroughly
- Use factories for test data
- Reset mocks between tests
- Write independent tests
- Make specific assertions
- Aim for 80%+ coverage

### DON'T ❌
- Test against production
- Let tests depend on each other
- Make real API calls in unit tests
- Duplicate test data
- Skip error testing
- Test implementation details
- Write flaky tests
- Chase 100% coverage blindly

---

## 📚 Further Reading

- [Testing Patterns](./testing_patterns.md)
- [Emulator Setup](./emulator_setup.md)
- [Example Tests](./example_tests.md)
- [Jest Best Practices](https://jestjs.io/docs/best-practices)
- [Testing Trophy](https://kentcdodds.com/blog/the-testing-trophy-and-testing-classifications)
