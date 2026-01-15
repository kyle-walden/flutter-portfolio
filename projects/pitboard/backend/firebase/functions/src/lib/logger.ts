export function logInfo(msg: string, meta?: any) {
  console.log(JSON.stringify({ level: 'info', msg, meta }));
}
