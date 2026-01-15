export function requireString(x: any): x is string {
  return typeof x === 'string' && x.length > 0;
}
