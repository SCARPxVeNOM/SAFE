type Chunk = {
  id: string;
  text: string;
  index: number;
};

export const chunkText = (
  docId: string,
  text: string,
  options: { chunkSize?: number; overlap?: number } = {},
): Chunk[] => {
  const { chunkSize = 900, overlap = 80 } = options;
  const words = text.split(/\s+/);
  const chunks: Chunk[] = [];
  let index = 0;

  while (index < words.length) {
    const window = words.slice(index, index + chunkSize);
    const chunkText = window.join(' ');
    const chunkIndex = chunks.length;
    chunks.push({
      id: `${docId}_chunk_${chunkIndex}`,
      text: chunkText,
      index: chunkIndex,
    });
    if (window.length + index >= words.length) break;
    index += chunkSize - overlap;
  }

  return chunks;
};


