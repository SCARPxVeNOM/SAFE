import pino from 'pino';

const devTransport =
  process.env.NODE_ENV === 'production'
    ? null
    : {
        target: 'pino-pretty',
        options: {
          colorize: true,
          translateTime: 'SYS:standard',
        },
      };

export const logger = pino({
  name: 'safebill',
  level: process.env.LOG_LEVEL ?? 'info',
  ...(devTransport ? { transport: devTransport } : {}),
});

