'use client'

import { useState, useEffect } from 'react'
import { ArrowLeft, AlarmOff, Timer, Bell } from 'lucide-react'
import { useRouter } from 'next/navigation'
import { apiClient } from '@/lib/api-client'
import type { Reminder } from '@/lib/types'
import { format } from 'date-fns'

export function RemindersScreen() {
  const router = useRouter()
  const [reminders, setReminders] = useState<Reminder[]>([])
  const [isLoading, setIsLoading] = useState(true)

  useEffect(() => {
    loadReminders()
  }, [])

  const loadReminders = async () => {
    try {
      setIsLoading(true)
      const response = await apiClient.get<{ reminders: Reminder[] }>('/reminders', {
        params: { userId: 'user123' }, // Get from auth
      })
      setReminders(response.reminders || [])
    } catch (error) {
      console.error('Failed to load reminders:', error)
    } finally {
      setIsLoading(false)
    }
  }

  return (
    <div className="min-h-screen bg-slate-50 dark:bg-slate-950">
      <div className="container mx-auto px-4 py-6">
        <div className="max-w-4xl mx-auto">
          <div className="flex items-center gap-4 mb-6">
            <button
              onClick={() => router.back()}
              className="p-2 hover:bg-slate-100 dark:hover:bg-slate-800 rounded-lg"
            >
              <ArrowLeft className="w-5 h-5 text-slate-600 dark:text-slate-400" />
            </button>
            <h1 className="text-2xl font-bold text-slate-900 dark:text-white">Reminders</h1>
          </div>

          {isLoading ? (
            <div className="text-center py-12 text-slate-500">Loading...</div>
          ) : reminders.length === 0 ? (
            <div className="text-center py-12">
              <AlarmOff className="w-16 h-16 text-indigo-500 mx-auto mb-4 opacity-50" />
              <h2 className="text-xl font-semibold text-slate-900 dark:text-white mb-2">
                No reminders yet
              </h2>
              <p className="text-slate-500 dark:text-slate-400 max-w-md mx-auto">
                Schedule reminders from a document to receive push + local alerts before warranties expire.
              </p>
            </div>
          ) : (
            <div className="space-y-2">
              {reminders.map((reminder) => (
                <div
                  key={reminder.reminderId}
                  className="p-4 bg-white dark:bg-slate-900 border border-slate-200 dark:border-slate-800 rounded-2xl flex items-center gap-4"
                >
                  {reminder.triggerType === 'expiry' ? (
                    <Timer className="w-5 h-5 text-indigo-500" />
                  ) : (
                    <Bell className="w-5 h-5 text-indigo-500" />
                  )}
                  <div className="flex-1">
                    <p className="font-semibold text-slate-900 dark:text-white">
                      {reminder.title}
                    </p>
                    <p className="text-sm text-slate-500 dark:text-slate-400">
                      {format(new Date(reminder.triggerAt), 'MMM d, yyyy h:mm a')}
                    </p>
                  </div>
                  <span className="px-3 py-1 bg-slate-100 dark:bg-slate-800 text-slate-600 dark:text-slate-400 text-xs font-medium rounded-full">
                    {reminder.status}
                  </span>
                </div>
              ))}
            </div>
          )}
        </div>
      </div>
    </div>
  )
}

