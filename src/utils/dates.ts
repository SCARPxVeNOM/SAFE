export const formatDate = (date: Date | null): string | null => {
  if (!date) return null;
  const iso = date.toISOString();
  const [datePart] = iso.split('T');
  return datePart ?? null;
};

export const addMonthsSafe = (date: Date, months: number): Date => {
  const cloned = new Date(date.getTime());
  cloned.setMonth(cloned.getMonth() + months);
  return cloned;
};

export const computeReminderDates = (
  baseDate: Date,
  offsets: number[],
): Date[] => {
  return offsets
    .map((offset) => {
      const target = new Date(baseDate.getTime());
      target.setDate(target.getDate() - offset);
      return target;
    })
    .filter((target) => target > new Date());
};

