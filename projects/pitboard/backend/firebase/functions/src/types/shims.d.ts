// Minimal shims to quiet the TypeScript language server in the portfolio workspace.
// These are temporary and intended to be replaced by proper @types packages via `npm ci`.

declare module 'express' {
  import type * as expressTypes from 'express-serve-static-core';
  const anyExport: any;
  export = anyExport;
}

declare module 'firebase-admin' {
  const anyExport: any;
  export = anyExport;
}

declare module 'firebase-functions' {
  const anyExport: any;
  export = anyExport;
}

declare module 'supertest' {
  const anyExport: any;
  export = anyExport;
}

// Minimal global declarations
declare var console: any;

export {};
