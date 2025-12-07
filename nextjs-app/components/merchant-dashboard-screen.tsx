'use client'

import { useRouter } from 'next/navigation'
import { FileSpreadsheet, Upload, Plus, LogOut, CheckCircle, Clock, User } from 'lucide-react'
import { ThemeToggle } from './theme-toggle'
import { useThemeStore } from '@/lib/store/theme-store'

export function MerchantDashboardScreen() {
  const router = useRouter()
  const { resolvedTheme } = useThemeStore()
  const isDark = resolvedTheme === 'dark'

  return (
    <div className="min-h-screen bg-gradient-to-br from-indigo-500/10 via-slate-50 to-slate-50 dark:from-indigo-500/10 dark:via-slate-950 dark:to-slate-950">
      <div className="absolute -top-24 -left-24 w-96 h-96 bg-indigo-500/10 dark:bg-indigo-500/10 rounded-full blur-3xl" />

      <div className="relative z-10 container mx-auto max-w-6xl px-4 sm:px-6 lg:px-8 py-6">
        {/* Header */}
        <div className="flex items-center justify-between mb-8">
          <div className="flex items-center gap-3">
            <div className="w-10 h-10 bg-gradient-to-br from-indigo-600 to-slate-800 dark:from-indigo-600 dark:to-slate-800 rounded-full border-2 border-white flex items-center justify-center text-white font-bold text-sm shadow-lg">
              M
            </div>
            <div>
              <p className="text-xs font-medium text-slate-500 dark:text-slate-400">
                Merchant Dashboard
              </p>
              <p className="text-lg font-semibold text-slate-900 dark:text-white">
                TechStore Inc.
              </p>
            </div>
          </div>
          <div className="flex items-center gap-3">
            <ThemeToggle />
            <button
              onClick={() => router.push('/landing')}
              className="p-2.5 bg-white dark:bg-slate-800 border border-slate-200 dark:border-slate-700 rounded-2xl hover:bg-slate-50 dark:hover:bg-slate-700 transition-colors"
            >
              <LogOut className="w-5 h-5 text-slate-600 dark:text-slate-300" />
            </button>
          </div>
        </div>

        {/* Action Card */}
        <div className="bg-white dark:bg-slate-900 border border-slate-200 dark:border-slate-800 rounded-3xl p-6 mb-8 shadow-lg">
          <div className="flex items-center gap-3 mb-6">
            <div className="p-2.5 bg-indigo-500/10 rounded-xl">
              <FileSpreadsheet className="w-6 h-6 text-indigo-500" />
            </div>
            <h2 className="text-lg font-semibold text-slate-900 dark:text-white">
              Assign Bill to Consumer
            </h2>
          </div>

          <div className="space-y-4">
            <div>
              <label className="block text-sm font-medium text-slate-700 dark:text-slate-300 mb-2">
                Consumer ID
              </label>
              <div className="relative">
                <User className="absolute left-3 top-1/2 -translate-y-1/2 w-5 h-5 text-slate-400 dark:text-slate-500" />
                <input
                  type="text"
                  placeholder="Enter Consumer ID"
                  className="w-full pl-10 pr-4 py-4 bg-slate-50 dark:bg-slate-950 border border-slate-200 dark:border-slate-800 rounded-xl text-slate-900 dark:text-white placeholder-slate-400 dark:placeholder-slate-600 focus:outline-none focus:ring-2 focus:ring-indigo-500"
                />
              </div>
            </div>

            <div className="grid grid-cols-2 gap-4">
              <button className="flex items-center justify-center gap-2 py-4 bg-white dark:bg-slate-800 border border-slate-200 dark:border-slate-700 rounded-2xl text-slate-700 dark:text-white font-semibold hover:bg-slate-50 dark:hover:bg-slate-700 transition-colors">
                <Upload className="w-5 h-5" />
                Upload Bill
              </button>
              <button className="flex items-center justify-center gap-2 py-4 bg-gradient-to-r from-indigo-500 to-indigo-600 text-white rounded-2xl font-semibold hover:from-indigo-600 hover:to-indigo-700 transition-all shadow-lg shadow-indigo-500/30">
                <Plus className="w-5 h-5" />
                Generate Bill
              </button>
            </div>
          </div>
        </div>

        {/* Recent Activity */}
        <div>
          <h3 className="text-lg font-semibold text-slate-900 dark:text-white mb-4">
            Recent Activity
          </h3>
          <div className="space-y-3">
            {[
              { title: 'MacBook Pro M3', consumer: 'Rahul Sharma', time: 'Just now', uploaded: true },
              { title: 'Sony Bravia 55"', consumer: 'Priya Singh', time: '2h ago', uploaded: true },
              { title: 'Dyson Airwrap', consumer: 'Amit Patel', time: '5h ago', uploaded: false },
            ].map((activity, idx) => (
              <div
                key={idx}
                className="p-4 bg-white dark:bg-slate-900 border border-slate-200 dark:border-slate-800 rounded-2xl flex items-center gap-4"
              >
                <div
                  className={`p-2.5 rounded-xl ${
                    activity.uploaded
                      ? 'bg-emerald-500/10'
                      : 'bg-amber-500/10'
                  }`}
                >
                  {activity.uploaded ? (
                    <CheckCircle className="w-5 h-5 text-emerald-500" />
                  ) : (
                    <Clock className="w-5 h-5 text-amber-500" />
                  )}
                </div>
                <div className="flex-1">
                  <p className="text-sm font-semibold text-slate-900 dark:text-white">
                    {activity.title}
                  </p>
                  <p className="text-xs text-slate-500 dark:text-slate-400">
                    Consumer: {activity.consumer}
                  </p>
                </div>
                <span className="text-xs text-slate-500 dark:text-slate-400">{activity.time}</span>
              </div>
            ))}
          </div>
        </div>
      </div>
    </div>
  )
}

