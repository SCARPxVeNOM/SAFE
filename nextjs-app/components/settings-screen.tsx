'use client'

import { useState } from 'react'
import { ArrowLeft, Database, Trash2, ChevronRight } from 'lucide-react'
import { useRouter } from 'next/navigation'
import { ThemeToggle } from './theme-toggle'
import { useThemeStore } from '@/lib/store/theme-store'

export function SettingsScreen() {
  const router = useRouter()
  const { theme, setTheme, resolvedTheme } = useThemeStore()
  const [localOnly, setLocalOnly] = useState(false)
  const [offlineOcr, setOfflineOcr] = useState(true)
  const [graphAugmentation, setGraphAugmentation] = useState(true)

  return (
    <div className="min-h-screen bg-slate-50 dark:bg-slate-950">
      <div className="container mx-auto px-4 py-6">
        <div className="max-w-2xl mx-auto">
          <div className="flex items-center gap-4 mb-6">
            <button
              onClick={() => router.back()}
              className="p-2 hover:bg-slate-100 dark:hover:bg-slate-800 rounded-lg"
            >
              <ArrowLeft className="w-5 h-5 text-slate-600 dark:text-slate-400" />
            </button>
            <h1 className="text-2xl font-bold text-slate-900 dark:text-white">Settings</h1>
          </div>

          <div className="space-y-1">
            {/* Theme */}
            <div className="p-4 bg-white dark:bg-slate-900 border border-slate-200 dark:border-slate-800 rounded-2xl flex items-center justify-between">
              <div>
                <p className="font-medium text-slate-900 dark:text-white">Theme</p>
                <p className="text-sm text-slate-500 dark:text-slate-400 capitalize">{resolvedTheme}</p>
              </div>
              <select
                value={theme}
                onChange={(e) => setTheme(e.target.value as 'light' | 'dark' | 'system')}
                className="px-3 py-2 bg-slate-50 dark:bg-slate-950 border border-slate-200 dark:border-slate-800 rounded-lg text-slate-900 dark:text-white text-sm focus:outline-none focus:ring-2 focus:ring-indigo-500"
              >
                <option value="light">Light</option>
                <option value="dark">Dark</option>
                <option value="system">System</option>
              </select>
            </div>

            <div className="h-px bg-slate-200 dark:bg-slate-800" />

            {/* Local-only mode */}
            <div className="p-4 bg-white dark:bg-slate-900 border border-slate-200 dark:border-slate-800 rounded-2xl flex items-center justify-between">
              <div className="flex-1">
                <p className="font-medium text-slate-900 dark:text-white">Local-only vault mode</p>
                <p className="text-sm text-slate-500 dark:text-slate-400">
                  Stay fully offline; data never leaves this device until you re-enable cloud mode.
                </p>
              </div>
              <label className="relative inline-flex items-center cursor-pointer">
                <input
                  type="checkbox"
                  checked={localOnly}
                  onChange={(e) => setLocalOnly(e.target.checked)}
                  className="sr-only peer"
                />
                <div className="w-11 h-6 bg-slate-200 peer-focus:outline-none peer-focus:ring-2 peer-focus:ring-indigo-500 rounded-full peer peer-checked:after:translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white after:border-gray-300 after:border after:rounded-full after:h-5 after:w-5 after:transition-all peer-checked:bg-indigo-500" />
              </label>
            </div>

            {/* Offline OCR */}
            <div className="p-4 bg-white dark:bg-slate-900 border border-slate-200 dark:border-slate-800 rounded-2xl flex items-center justify-between">
              <div className="flex-1">
                <p className="font-medium text-slate-900 dark:text-white">Offline OCR first</p>
                <p className="text-sm text-slate-500 dark:text-slate-400">
                  Use on-device ML Kit processing before sending to the backend fallback.
                </p>
              </div>
              <label className="relative inline-flex items-center cursor-pointer">
                <input
                  type="checkbox"
                  checked={offlineOcr}
                  onChange={(e) => setOfflineOcr(e.target.checked)}
                  className="sr-only peer"
                />
                <div className="w-11 h-6 bg-slate-200 peer-focus:outline-none peer-focus:ring-2 peer-focus:ring-indigo-500 rounded-full peer peer-checked:after:translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white after:border-gray-300 after:border after:rounded-full after:h-5 after:w-5 after:transition-all peer-checked:bg-indigo-500" />
              </label>
            </div>

            {/* GraphRAG */}
            <div className="p-4 bg-white dark:bg-slate-900 border border-slate-200 dark:border-slate-800 rounded-2xl flex items-center justify-between">
              <div className="flex-1">
                <p className="font-medium text-slate-900 dark:text-white">GraphRAG augmentation</p>
                <p className="text-sm text-slate-500 dark:text-slate-400">
                  Allow the assistant to traverse the knowledge graph for broader answers.
                </p>
              </div>
              <label className="relative inline-flex items-center cursor-pointer">
                <input
                  type="checkbox"
                  checked={graphAugmentation}
                  onChange={(e) => setGraphAugmentation(e.target.checked)}
                  className="sr-only peer"
                />
                <div className="w-11 h-6 bg-slate-200 peer-focus:outline-none peer-focus:ring-2 peer-focus:ring-indigo-500 rounded-full peer peer-checked:after:translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white after:border-gray-300 after:border after:rounded-full after:h-5 after:w-5 after:transition-all peer-checked:bg-indigo-500" />
              </label>
            </div>

            <div className="h-px bg-slate-200 dark:bg-slate-800" />

            {/* Export data */}
            <button className="w-full p-4 bg-white dark:bg-slate-900 border border-slate-200 dark:border-slate-800 rounded-2xl flex items-center justify-between hover:bg-slate-50 dark:hover:bg-slate-800 transition-colors">
              <div className="flex items-center gap-3">
                <Database className="w-5 h-5 text-slate-600 dark:text-slate-400" />
                <div className="text-left">
                  <p className="font-medium text-slate-900 dark:text-white">Export data</p>
                  <p className="text-sm text-slate-500 dark:text-slate-400">
                    Generate an encrypted export of all documents.
                  </p>
                </div>
              </div>
              <ChevronRight className="w-5 h-5 text-slate-400" />
            </button>

            {/* Delete account */}
            <button className="w-full p-4 bg-white dark:bg-slate-900 border border-slate-200 dark:border-slate-800 rounded-2xl flex items-center justify-between hover:bg-slate-50 dark:hover:bg-slate-800 transition-colors">
              <div className="flex items-center gap-3">
                <Trash2 className="w-5 h-5 text-slate-600 dark:text-slate-400" />
                <div className="text-left">
                  <p className="font-medium text-slate-900 dark:text-white">Delete account</p>
                  <p className="text-sm text-slate-500 dark:text-slate-400">
                    Trigger GDPR/CPA-compliant deletion workflow.
                  </p>
                </div>
              </div>
              <ChevronRight className="w-5 h-5 text-slate-400" />
            </button>
          </div>
        </div>
      </div>
    </div>
  )
}

