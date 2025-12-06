import neo4j, { Driver } from 'neo4j-driver';
import { getEnv } from '../config/env';
import { logger } from '../utils/logger';

let driver: Driver | null = null;
const env = getEnv();

if (env.GRAPH_DB_URI && env.GRAPH_DB_USER && env.GRAPH_DB_PASSWORD) {
  driver = neo4j.driver(
    env.GRAPH_DB_URI,
    neo4j.auth.basic(env.GRAPH_DB_USER, env.GRAPH_DB_PASSWORD),
  );
}

export const fetchRelatedGraphNodes = async (params: {
  entities: string[];
  limit?: number;
}) => {
  if (!driver) {
    logger.warn('Graph DB not configured; skipping GraphRAG augmentation');
    return [];
  }

  const session = driver.session();
  try {
    const result = await session.run(
      `
        MATCH (n)-[r]->(m)
        WHERE n.name IN $entities OR m.name IN $entities
        RETURN n, r, m
        LIMIT $limit
      `,
      {
        entities: params.entities,
        limit: params.limit ?? 10,
      },
    );

    return result.records.map((record) => ({
      from: record.get('n').properties,
      relation: record.get('r').type,
      to: record.get('m').properties,
    }));
  } finally {
    await session.close();
  }
};


