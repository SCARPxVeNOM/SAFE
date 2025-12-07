'use client'

import { useState, useEffect } from 'react'
import { useRouter } from 'next/navigation'
import {
  ScanLine,
  ShieldCheck,
  Wallet,
  Smartphone,
  Tv,
  Car,
  Watch,
  LayoutGrid,
  FolderLock,
  MessageSquare,
  User,
  LogOut,
  Bell,
  Laptop,
} from 'lucide-react'
import { ThemeToggle } from './theme-toggle'
import { useThemeStore } from '@/lib/store/theme-store'
import { apiClient } from '@/lib/api-client'
import type { Document } from '@/lib/types'
import { format } from 'date-fns'

export function LockerScreen() {
  const router = useRouter()
  const { resolvedTheme } = useThemeStore()
  const isDark = resolvedTheme === 'dark'
  const [documents, setDocuments] = useState<Document[]>([])
  const [isLoading, setIsLoading] = useState(true)

  useEffect(() => {
    loadDocuments()
  }, [])

  const loadDocuments = async () => {
    try {
      setIsLoading(true)
      const response = await apiClient.get<{ documents: Document[] }>('/documents')
      setDocuments(response.documents || [])
    } catch (error) {
      console.error('Failed to load documents:', error)
    } finally {
      setIsLoading(false)
    }
  }

  const categories = [
    { icon: Smartphone, label: 'Gadgets' },
    { icon: Tv, label: 'Appliances' },
    { icon: Car, label: 'Vehicle' },
    { icon: Watch, label: 'Others' },
  ]

  const expiringSoon = documents
    .filter((doc) => {
      const item = doc.items[0]
      if (!item.warrantyEnd) return false
      const endDate = new Date(item.warrantyEnd)
      const now = new Date()
      const daysLeft = Math.ceil((endDate.getTime() - now.getTime()) / (1000 * 60 * 60 * 24))
      return daysLeft > 0 && daysLeft <= 30
    })
    .slice(0, 3)

  const activeCount = documents.filter((doc) => {
    const item = doc.items[0]
    if (!item.warrantyEnd) return false
    return new Date(item.warrantyEnd) > new Date()
  }).length

  const totalValue = documents.reduce((sum, doc) => {
    const price = doc.items[0]?.purchasePrice || 0
    return sum + price
  }, 0)

  return (
    <div className="min-h-screen bg-gradient-to-br from-indigo-500/10 via-slate-50 to-slate-50 dark:from-indigo-500/10 dark:via-slate-950 dark:to-slate-950">
      {/* Blur Orb */}
      <div className="absolute -top-24 -left-24 w-96 h-96 bg-indigo-500/10 dark:bg-indigo-500/10 rounded-full blur-3xl" />

      <div className="relative z-10 container mx-auto max-w-6xl px-4 sm:px-6 lg:px-8">
        {/* Header */}
        <div className="flex items-center justify-between py-6">
          <div className="flex items-center gap-3">
            <div className="w-10 h-10 bg-gradient-to-br from-indigo-600 to-slate-800 dark:from-indigo-600 dark:to-slate-800 rounded-full border-2 border-white flex items-center justify-center text-white font-bold text-sm shadow-lg">
              SB
            </div>
            <div>
              <p className="text-xs font-medium text-slate-500 dark:text-slate-400">
                Welcome back
              </p>
              <p className="text-lg font-semibold text-slate-900 dark:text-white">
                Rahul Sharma
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
            <button className="relative p-2.5 bg-white dark:bg-slate-800 border border-slate-200 dark:border-slate-700 rounded-2xl hover:bg-slate-50 dark:hover:bg-slate-700 transition-colors">
              <Bell className="w-5 h-5 text-slate-600 dark:text-slate-300" />
              <span className="absolute top-1 right-1 w-2 h-2 bg-rose-500 rounded-full border-2 border-white dark:border-slate-800" />
            </button>
          </div>
        </div>

        {/* Scan Action Card */}
        <button
          onClick={() => router.push('/scan')}
          className="w-full mb-6 p-5 bg-slate-950 dark:bg-slate-950 rounded-3xl border border-slate-800 dark:border-slate-800 shadow-xl hover:shadow-2xl transition-all relative overflow-hidden"
        >
          <div className="absolute -top-5 -right-5 w-32 h-32 bg-indigo-500/20 rounded-full blur-2xl" />
          <div className="relative flex items-center justify-between">
            <div>
              <h3 className="text-lg font-semibold text-white mb-1">Scan Invoice</h3>
              <p className="text-sm text-slate-400">AI auto-extracts warranty details</p>
            </div>
            <div className="w-10 h-10 bg-white/10 rounded-xl border border-white/10 flex items-center justify-center">
              <ScanLine className="w-5 h-5 text-white" />
            </div>
          </div>
        </button>

        {/* Quick Stats */}
        <div className="grid grid-cols-2 gap-3 mb-6">
          <StatCard
            isDark={isDark}
            icon={ShieldCheck}
            iconColor="emerald-500"
            label="Active"
            value={activeCount.toString()}
            subValue="Active Warranties"
          />
          <StatCard
            isDark={isDark}
            icon={Wallet}
            iconColor="indigo-500"
            value={`₹${(totalValue / 1000).toFixed(1)}K`}
            subValue="Asset Value"
          />
        </div>

        {/* Categories */}
        <div className="mb-6">
          <div className="flex items-center justify-between mb-4 px-1">
            <h3 className="text-sm font-semibold text-slate-900 dark:text-white">
              Digital Locker
            </h3>
            <button className="text-xs font-medium text-indigo-500 dark:text-indigo-400 hover:text-indigo-600">
              View all
            </button>
          </div>
          <div className="flex gap-3 overflow-x-auto pb-2">
            {categories.map((cat, idx) => (
              <button
                key={idx}
                className="flex-shrink-0 flex flex-col items-center gap-2"
              >
                <div className="w-16 h-16 bg-white dark:bg-slate-800 border border-slate-200 dark:border-slate-700 rounded-2xl flex items-center justify-center shadow-sm">
                  <cat.icon className="w-6 h-6 text-slate-600 dark:text-slate-300" />
                </div>
                <span className="text-xs font-medium text-slate-600 dark:text-slate-400">
                  {cat.label}
                </span>
              </button>
            ))}
          </div>
        </div>

        {/* Expiring Soon */}
        <div className="mb-24">
          <h3 className="text-sm font-semibold text-slate-900 dark:text-white mb-3 px-1">
            Expiring Soon
          </h3>
          {isLoading ? (
            <div className="text-center py-8 text-slate-500">Loading...</div>
          ) : expiringSoon.length === 0 ? (
            <div className="text-center py-8 text-slate-500">No documents expiring soon</div>
          ) : (
            <div className="space-y-3">
              {expiringSoon.map((doc) => {
                const item = doc.items[0]
                const endDate = item.warrantyEnd ? new Date(item.warrantyEnd) : null
                const now = new Date()
                const daysLeft = endDate
                  ? Math.ceil((endDate.getTime() - now.getTime()) / (1000 * 60 * 60 * 24))
                  : 0

                const startDate = item.warrantyStart ? new Date(item.warrantyStart) : null
                const totalDays = startDate && endDate
                  ? Math.ceil((endDate.getTime() - startDate.getTime()) / (1000 * 60 * 60 * 24))
                  : 1
                const elapsed = startDate
                  ? Math.ceil((now.getTime() - startDate.getTime()) / (1000 * 60 * 60 * 24))
                  : 0
                const progress = Math.min(Math.max(elapsed / totalDays, 0), 1)

                return (
                  <button
                    key={doc.docId}
                    onClick={() => router.push(`/document/${doc.docId}`)}
                    className="w-full p-3 bg-white dark:bg-slate-800 border border-slate-200 dark:border-slate-700 rounded-2xl flex items-center gap-3 hover:shadow-md transition-shadow"
                  >
                    <div className="w-12 h-12 bg-slate-100 dark:bg-slate-700 rounded-xl flex items-center justify-center">
                      <Laptop className="w-6 h-6 text-slate-600 dark:text-slate-300" />
                    </div>
                    <div className="flex-1 text-left">
                      <div className="flex items-center justify-between mb-2">
                        <p className="text-sm font-semibold text-slate-900 dark:text-white truncate">
                          {item.productName || doc.title}
                        </p>
                        <span className="px-2 py-0.5 bg-rose-500/10 text-rose-500 text-[10px] font-semibold rounded-xl">
                          {daysLeft} Days left
                        </span>
                      </div>
                      <div className="h-1.5 bg-slate-100 dark:bg-slate-700 rounded-full overflow-hidden">
                        <div
                          className="h-full bg-rose-500 rounded-full"
                          style={{ width: `${progress * 100}%` }}
                        />
                      </div>
                    </div>
                  </button>
                )
              })}
            </div>
          )}
        </div>

        {/* Bottom Navigation */}
        <div className="fixed bottom-6 left-1/2 -translate-x-1/2 w-full max-w-md px-6">
          <div className="bg-white/90 dark:bg-slate-900/90 backdrop-blur-sm border border-slate-200 dark:border-slate-800 rounded-3xl px-4 py-3 flex items-center justify-between shadow-xl">
            <NavItem icon={LayoutGrid} label="Home" isActive />
            <NavItem icon={FolderLock} label="Locker" />
            <button
              onClick={() => router.push('/scan')}
              className="p-3.5 bg-indigo-500 dark:bg-slate-900 rounded-full shadow-lg"
            >
              <ScanLine className="w-6 h-6 text-white" />
            </button>
            <NavItem
              icon={MessageSquare}
              label="Ask AI"
              onClick={() => router.push('/chat')}
            />
            <NavItem
              icon={User}
              label="Profile"
              onClick={() => router.push('/settings')}
            />
          </div>
        </div>
      </div>
    </div>
  )
}

function StatCard({
  isDark,
  icon: Icon,
  iconColor,
  label,
  value,
  subValue,
}: {
  isDark: boolean
  icon: any
  iconColor: string
  label?: string
  value: string
  subValue: string
}) {
  return (
    <div className="p-4 bg-white dark:bg-slate-800 border border-slate-200 dark:border-slate-700 rounded-2xl">
      <div className="flex items-center justify-between mb-3">
        <Icon className={`w-5 h-5 text-${iconColor}`} />
        {label && (
          <span className={`px-2 py-0.5 bg-${iconColor}/10 text-${iconColor} text-[10px] font-semibold rounded-xl`}>
            {label}
          </span>
        )}
      </div>
      <p className="text-2xl font-semibold text-slate-900 dark:text-white mb-1">{value}</p>
      <p className="text-xs font-medium text-slate-500 dark:text-slate-400">{subValue}</p>
    </div>
  )
}

function NavItem({
  icon: Icon,
  label,
  isActive = false,
  onClick,
}: {
  icon: any
  label: string
  isActive?: boolean
  onClick?: () => void
}) {
  return (
    <button
      onClick={onClick}
      className="flex flex-col items-center gap-1"
    >
      <Icon
        className={`w-5 h-5 ${
          isActive
            ? 'text-slate-900 dark:text-white'
            : 'text-slate-500 dark:text-slate-400'
        }`}
      />
      <span
        className={`text-[10px] font-medium ${
          isActive
            ? 'text-slate-900 dark:text-white'
            : 'text-slate-500 dark:text-slate-400'
        }`}
      >
        {label}
      </span>
    </button>
  )
}

