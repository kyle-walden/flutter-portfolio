# Firebase Functions Testing Patterns

Universal patterns for testing Firebase Cloud Functions across all projects.

---

## Pattern Index

1. [HTTP Callable Functions](#http-callable-functions)
2. [Firestore Triggers](#firestore-triggers)
3. [Scheduled Functions](#scheduled-functions)
4. [Authentication & Authorization](#authentication--authorization)
5. [External API Integration](#external-api-integration)
6. [Error Handling](#error-handling)
7. [Data Validation](#data-validation)
8. [Async Operations](#async-operations)

---

## HTTP Callable Functions

### Basic Pattern
```typescript
import { onCall } from 'firebase-functions/v2/https';

export const myCallableFunction = onCall(async (request) => {
  const { param1, param2 } = request.data;
  
  // Validation
  if (!param1) throw new Error('param1 is required');
  
  // Business logic
  const result = await doSomething(param1, param2);
  
  return { success: true, data: result };
});
```

### Test Pattern
```typescript
describe('myCallableFunction', () => {
  it('should validate required parameters', async () => {
    await expect(
      myCallableFunction({ data: {} })
    ).rejects.toThrow('param1 is required');
  });

  it('should process valid request', async () => {
    mockDependencies();
    
    const result = await myCallableFunction({
      data: { param1: 'value1', param2: 'value2' }
    });

    expect(result.success).toBe(true);
    expect(result.data).toBeDefined();
  });

  it('should handle processing errors', async () => {
    mockDependencies({ shouldFail: true });

    await expect(
      myCallableFunction({ data: { param1: 'value' } })
    ).rejects.toThrow('Processing failed');
  });
});
```

---

## Firestore Triggers

### onDocumentCreated Pattern
```typescript
import { onDocumentCreated } from 'firebase-functions/v2/firestore';

export const onPaymentCreated = onDocumentCreated(
  'payments/{paymentId}',
  async (event) => {
    const payment = event.data.data();
    const { memberId, amount } = payment;

    // Update related documents
    await updateMemberStatus(memberId);
    
    return { processed: true };
  }
);
```

### Test Pattern
```typescript
import * as test from 'firebase-functions-test';

const testEnv = test();

describe('onPaymentCreated', () => {
  afterAll(() => testEnv.cleanup());

  it('should update member when payment created', async () => {
    // Create mock snapshot
    const paymentData = {
      memberId: 'member-123',
      amount: 50,
      date: new Date(),
    };

    const snap = testEnv.firestore.makeDocumentSnapshot(
      paymentData,
      'payments/payment-123'
    );

    // Mock Firestore operations
    const mockUpdate = jest.fn();
    mockFirestore.collection().doc().update = mockUpdate;

    // Execute trigger
    const wrapped = testEnv.wrap(onPaymentCreated);
    await wrapped(snap);

    // Verify side effects
    expect(mockUpdate).toHaveBeenCalledWith(
      expect.objectContaining({ status: 'active' })
    );
  });
});
```

### onDocumentUpdated Pattern
```typescript
import { onDocumentUpdated } from 'firebase-functions/v2/firestore';

export const onMemberUpdated = onDocumentUpdated(
  'members/{memberId}',
  async (event) => {
    const before = event.data.before.data();
    const after = event.data.after.data();

    // Check what changed
    if (before.status !== after.status) {
      await handleStatusChange(event.params.memberId, after.status);
    }
  }
);
```

### Test Pattern
```typescript
it('should detect status change', async () => {
  const beforeData = { status: 'expired', name: 'Test' };
  const afterData = { status: 'active', name: 'Test' };

  const beforeSnap = testEnv.firestore.makeDocumentSnapshot(
    beforeData,
    'members/member-123'
  );
  const afterSnap = testEnv.firestore.makeDocumentSnapshot(
    afterData,
    'members/member-123'
  );

  const change = testEnv.makeChange(beforeSnap, afterSnap);
  
  const wrapped = testEnv.wrap(onMemberUpdated);
  await wrapped(change);

  expect(mockHandleStatusChange).toHaveBeenCalledWith(
    'member-123',
    'active'
  );
});
```

---

## Scheduled Functions

### Pattern
```typescript
import { onSchedule } from 'firebase-functions/v2/scheduler';

export const dailyCleanup = onSchedule('0 0 * * *', async (event) => {
  const yesterday = new Date();
  yesterday.setDate(yesterday.getDate() - 1);

  await cleanupOldData(yesterday);
  
  return { cleaned: true };
});
```

### Test Pattern
```typescript
describe('dailyCleanup', () => {
  it('should clean up old data', async () => {
    const mockCleanup = jest.fn();
    
    const wrapped = testEnv.wrap(dailyCleanup);
    await wrapped({});

    expect(mockCleanup).toHaveBeenCalled();
    
    // Verify date calculation
    const callDate = mockCleanup.mock.calls[0][0];
    expect(callDate).toBeInstanceOf(Date);
    expect(callDate).toBeBefore(new Date());
  });
});
```

---

## Authentication & Authorization

### Role-Based Access Pattern
```typescript
export const ownerOnlyFunction = onCall({ enforceAppCheck: true }, async (request) => {
  // Check authentication
  if (!request.auth) {
    throw new HttpsError('unauthenticated', 'User must be authenticated');
  }

  // Check role
  const role = request.auth.token.role;
  if (role !== 'owner') {
    throw new HttpsError('permission-denied', 'Only owners can perform this action');
  }

  // Proceed with operation
  return await doOwnerOperation();
});
```

### Test Pattern
```typescript
describe('ownerOnlyFunction', () => {
  it('should reject unauthenticated requests', async () => {
    const request = { data: {} };  // No auth

    await expect(ownerOnlyFunction(request))
      .rejects.toThrow('unauthenticated');
  });

  it('should reject non-owner roles', async () => {
    const request = {
      data: {},
      auth: {
        uid: 'test-uid',
        token: { role: 'staff' }
      }
    };

    await expect(ownerOnlyFunction(request))
      .rejects.toThrow('permission-denied');
  });

  it('should allow owner role', async () => {
    const request = {
      data: {},
      auth: {
        uid: 'test-uid',
        token: { role: 'owner', venueId: 'venue-123' }
      }
    };

    mockDoOwnerOperation();

    const result = await ownerOnlyFunction(request);
    expect(result.success).toBe(true);
  });
});
```

---

## External API Integration

### Pattern with Retry Logic
```typescript
import axios from 'axios';

async function callExternalAPI(data: any, retries = 3) {
  for (let i = 0; i < retries; i++) {
    try {
      const response = await axios.post('https://api.example.com/endpoint', data, {
        headers: { Authorization: `Bearer ${process.env.API_KEY}` },
        timeout: 5000,
      });
      
      return response.data;
    } catch (error) {
      if (i === retries - 1) throw error;
      await sleep(1000 * (i + 1));  // Exponential backoff
    }
  }
}
```

### Test Pattern
```typescript
import axios from 'axios';

jest.mock('axios');
const mockedAxios = axios as jest.Mocked<typeof axios>;

describe('callExternalAPI', () => {
  beforeEach(() => {
    mockedAxios.post.mockClear();
  });

  it('should call API with correct parameters', async () => {
    mockedAxios.post.mockResolvedValue({
      data: { success: true }
    });

    await callExternalAPI({ test: 'data' });

    expect(mockedAxios.post).toHaveBeenCalledWith(
      'https://api.example.com/endpoint',
      { test: 'data' },
      expect.objectContaining({
        headers: expect.objectContaining({
          Authorization: expect.stringContaining('Bearer')
        })
      })
    );
  });

  it('should retry on failure', async () => {
    mockedAxios.post
      .mockRejectedValueOnce(new Error('Network error'))
      .mockRejectedValueOnce(new Error('Network error'))
      .mockResolvedValueOnce({ data: { success: true } });

    const result = await callExternalAPI({ test: 'data' });

    expect(mockedAxios.post).toHaveBeenCalledTimes(3);
    expect(result.success).toBe(true);
  });

  it('should fail after max retries', async () => {
    mockedAxios.post.mockRejectedValue(new Error('Network error'));

    await expect(callExternalAPI({ test: 'data' }))
      .rejects.toThrow('Network error');

    expect(mockedAxios.post).toHaveBeenCalledTimes(3);
  });
});
```

---

## Error Handling

### Pattern
```typescript
export const robustFunction = onCall(async (request) => {
  try {
    // Validation
    if (!request.data.id) {
      throw new HttpsError('invalid-argument', 'ID is required');
    }

    // Business logic
    const result = await performOperation(request.data.id);

    return { success: true, data: result };

  } catch (error) {
    // Log error
    console.error('Error in robustFunction:', error);

    // Return user-friendly error
    if (error instanceof HttpsError) {
      throw error;
    }

    // Wrap unexpected errors
    throw new HttpsError('internal', 'An unexpected error occurred');
  }
});
```

### Test Pattern
```typescript
describe('robustFunction Error Handling', () => {
  it('should throw HttpsError for validation failures', async () => {
    await expect(
      robustFunction({ data: {} })
    ).rejects.toThrow(HttpsError);

    await expect(
      robustFunction({ data: {} })
    ).rejects.toMatchObject({
      code: 'invalid-argument',
      message: expect.stringContaining('required')
    });
  });

  it('should wrap unexpected errors', async () => {
    mockPerformOperation.mockRejectedValue(new Error('Database explosion'));

    await expect(
      robustFunction({ data: { id: 'test' } })
    ).rejects.toMatchObject({
      code: 'internal',
      message: 'An unexpected error occurred'
    });
  });
});
```

---

## Data Validation

### Pattern
```typescript
function validateMemberData(data: any) {
  const errors: string[] = [];

  if (!data.name || data.name.trim().length === 0) {
    errors.push('Name is required');
  }

  if (!data.email || !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(data.email)) {
    errors.push('Valid email is required');
  }

  if (data.phone && !/^\+?\d{10,15}$/.test(data.phone)) {
    errors.push('Phone must be 10-15 digits');
  }

  if (errors.length > 0) {
    throw new HttpsError('invalid-argument', errors.join('; '));
  }

  return true;
}
```

### Test Pattern
```typescript
describe('validateMemberData', () => {
  it('should accept valid data', () => {
    const validData = {
      name: 'John Doe',
      email: 'john@example.com',
      phone: '+1234567890'
    };

    expect(validateMemberData(validData)).toBe(true);
  });

  it('should reject missing name', () => {
    expect(() => validateMemberData({ email: 'test@test.com' }))
      .toThrow('Name is required');
  });

  it('should reject invalid email', () => {
    expect(() => validateMemberData({ name: 'Test', email: 'invalid' }))
      .toThrow('Valid email is required');
  });

  it('should reject invalid phone format', () => {
    expect(() => validateMemberData({
      name: 'Test',
      email: 'test@test.com',
      phone: '123'  // Too short
    })).toThrow('Phone must be 10-15 digits');
  });

  it('should allow optional phone', () => {
    const dataWithoutPhone = {
      name: 'Test',
      email: 'test@test.com'
    };

    expect(validateMemberData(dataWithoutPhone)).toBe(true);
  });
});
```

---

## Async Operations

### Pattern: Promise.all for Parallel Operations
```typescript
export const batchOperation = onCall(async (request) => {
  const { memberIds } = request.data;

  // Execute operations in parallel
  const results = await Promise.all(
    memberIds.map(id => processMember(id))
  );

  return { processed: results.length, results };
});
```

### Test Pattern
```typescript
it('should process members in parallel', async () => {
  const mockProcessMember = jest.fn()
    .mockResolvedValue({ success: true });

  const result = await batchOperation({
    data: { memberIds: ['id1', 'id2', 'id3'] }
  });

  expect(mockProcessMember).toHaveBeenCalledTimes(3);
  expect(result.processed).toBe(3);
});
```

### Pattern: Sequential Operations
```typescript
export const orderedOperation = onCall(async (request) => {
  const { steps } = request.data;

  for (const step of steps) {
    await executeStep(step);  // Wait for each step
  }

  return { completed: true };
});
```

### Test Pattern
```typescript
it('should execute steps sequentially', async () => {
  const executionOrder: number[] = [];
  
  mockExecuteStep.mockImplementation(async (step) => {
    executionOrder.push(step.order);
  });

  await orderedOperation({
    data: {
      steps: [
        { order: 1 },
        { order: 2 },
        { order: 3 }
      ]
    }
  });

  expect(executionOrder).toEqual([1, 2, 3]);
});
```

---

## Quick Reference

### Common Test Patterns
```typescript
// Validation
expect(() => fn()).toThrow('error message');

// Async success
const result = await fn();
expect(result.success).toBe(true);

// Async error
await expect(fn()).rejects.toThrow('error');

// Mock called with
expect(mockFn).toHaveBeenCalledWith(expectedArgs);

// Mock called times
expect(mockFn).toHaveBeenCalledTimes(3);

// Date assertions
expect(date1).toBeAfter(date2);
expect(date1).toBeBefore(date2);

// Object matching
expect(result).toMatchObject({ prop: 'value' });

// Array contains
expect(array).toContain(item);
```

---

**Next:** See [emulator_setup.md](./emulator_setup.md) for testing with Firebase Emulator
