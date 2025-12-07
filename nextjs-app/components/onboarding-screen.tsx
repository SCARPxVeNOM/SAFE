'use client'

import { useRouter } from 'next/navigation'
import { useState } from 'react'
import { ArrowRight, Check, ScanLine, Sparkles } from 'lucide-react'
import { ThemeToggle } from './theme-toggle'
import { useThemeStore } from '@/lib/store/theme-store'

export function OnboardingScreen() {
  const router = useRouter()
  const { resolvedTheme } = useThemeStore()
  const isDark = resolvedTheme === 'dark'
  const [completed, setCompleted] = useState(false)

  const handleComplete = () => {
    setCompleted(true)
    router.push('/landing')
  }

  return (
    <div className="min-h-screen bg-gradient-to-b from-indigo-900/40 via-slate-900 to-slate-900 dark:from-indigo-900/40 dark:via-slate-900 dark:to-slate-900">
      <div className="relative min-h-screen">
        {/* Animated Aura */}
        <div className="absolute top-10 left-1/2 -translate-x-1/2 w-[300px] h-[300px] bg-indigo-500/20 rounded-full blur-[80px] animate-pulse" />

        <div className="relative z-10 container mx-auto px-8 py-6">
          <div className="flex justify-end mb-4">
            <ThemeToggle />
          </div>

          <div className="max-w-2xl mx-auto">
            {/* Hero Card */}
            <div className="flex justify-center mb-12">
              <div className="relative">
                {/* Tilted Cards */}
                <div className="absolute inset-0 w-[280px] h-[280px] border border-white/5 rounded-3xl bg-white/5 rotate-[3deg]" />
                <div className="absolute inset-0 w-[280px] h-[280px] border border-white/5 rounded-3xl bg-white/5 -rotate-[3deg]" />
                
                {/* Main Card */}
                <div className="relative w-[280px] h-[280px] bg-gradient-to-br from-slate-800 to-slate-950 rounded-3xl border border-white/10 shadow-2xl p-8 flex flex-col items-center justify-center">
                  <div className="absolute inset-0 opacity-10">
                    <div className="grid grid-cols-6 gap-1 h-full">
                      {Array.from({ length: 36 }).map((_, i) => (
                        <div key={i} className="border border-white" />
                      ))}
                    </div>
                  </div>
                  <ScanLine className="w-20 h-20 text-indigo-500/90 mb-4" />
                  <div className="w-40 h-1.5 bg-slate-700/50 rounded-full mb-3">
                    <div className="w-24 h-full bg-indigo-500 rounded-full animate-pulse" />
                  </div>
                  <p className="text-xs text-indigo-500/70 font-mono">Processing Invoice...</p>
                  <div className="absolute top-4 right-4 px-2 py-1 bg-emerald-500/20 border border-emerald-500/30 rounded text-[10px] text-emerald-500">
                    Date Found
                  </div>
                  <div className="absolute bottom-6 left-6 px-2 py-1 bg-blue-500/20 border border-blue-500/30 rounded text-[10px] text-blue-500">
                    OpenAI Analysis
                  </div>
                </div>
              </div>
            </div>

            {/* Badge */}
            <div className="flex justify-center mb-6">
              <div className="inline-flex items-center gap-1.5 px-3 py-1.5 bg-indigo-500/10 border border-indigo-500/20 rounded-full">
                <Sparkles className="w-3 h-3 text-indigo-500/80" />
                <span className="text-[10px] font-semibold text-indigo-500/80 tracking-wider">
                  AI-POWERED PROTECTION
                </span>
              </div>
            </div>

            {/* Title */}
            <h1 className="text-4xl md:text-5xl font-semibold text-white mb-6 text-center">
              Never lose a{' '}
              <span className="bg-gradient-to-r from-indigo-400 to-blue-300 bg-clip-text text-transparent">
                warranty claim
              </span>{' '}
              again.
            </h1>

            {/* Description */}
            <p className="text-slate-400 text-center mb-8 leading-relaxed">
              SafeBill organizes your messy bills. Our AI extracts warranty terms, reminds you of expiry, and helps fight denied claims.
            </p>

            {/* Checklist */}
            <div className="space-y-3 mb-8">
              {[
                'Auto-scan bills & warranties',
                'Get alerted before expiry',
                'Legal guidance for rejected claims',
              ].map((item, idx) => (
                <div key={idx} className="flex items-center gap-3">
                  <div className="p-1 bg-emerald-500/20 border border-emerald-500/20 rounded-full">
                    <Check className="w-3 h-3 text-emerald-500" />
                  </div>
                  <span className="text-slate-300">{item}</span>
                </div>
              ))}
            </div>

            {/* CTA Button */}
            <button
              onClick={handleComplete}
              className="w-full bg-white text-slate-950 py-4 rounded-2xl font-semibold flex items-center justify-center gap-2 hover:bg-slate-100 transition-colors shadow-lg"
            >
              Start Scanning Free
              <ArrowRight className="w-4 h-4" />
            </button>
          </div>
        </div>
      </div>
    </div>
  )
}

