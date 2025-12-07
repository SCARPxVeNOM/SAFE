'use client'

import { useState } from 'react'
import { useRouter } from 'next/navigation'
import { Chrome, Lock, User } from 'lucide-react'
import { ThemeToggle } from './theme-toggle'
import { useAuthStore } from '@/lib/store/auth-store'
import { apiClient } from '@/lib/api-client'
import type { UserType } from '@/lib/types'

export function LandingScreen() {
  const router = useRouter()
  const { setAuth } = useAuthStore()
  const [userType, setUserType] = useState<UserType>('consumer')
  const [isLoading, setIsLoading] = useState(false)

  const handleGoogleSignIn = async () => {
    setIsLoading(true)
    try {
      // In a real app, you'd use NextAuth for this
      // For now, we'll simulate the flow
      const response = await apiClient.post<{
        ok: boolean
        token: string
        user: { userId: string; email: string; name?: string; picture?: string }
      }>('/auth/google', {
        // This would normally be handled by NextAuth
      })

      if (response.ok) {
        setAuth(
          {
            userId: response.user.userId,
            email: response.user.email,
            name: response.user.name,
            picture: response.user.picture,
          },
          response.token
        )

        if (userType === 'consumer') {
          router.push('/locker')
        } else {
          router.push('/merchant-dashboard')
        }
      }
    } catch (error) {
      console.error('Sign in failed:', error)
      alert('Sign in failed. Please try again.')
    } finally {
      setIsLoading(false)
    }
  }

  const handleLogin = () => {
    if (userType === 'consumer') {
      router.push('/locker')
    } else {
      router.push('/merchant-dashboard')
    }
  }

  return (
    <div className="min-h-screen bg-gradient-to-br from-slate-50 via-white to-indigo-50/20 dark:from-slate-950 dark:via-slate-900 dark:to-indigo-950/20">
      {/* Animated Blur Orb */}
      <div className="absolute -top-40 -right-40 w-[500px] h-[500px] bg-indigo-500/10 dark:bg-indigo-500/15 rounded-full blur-3xl animate-pulse" />

      <div className="relative z-10 container mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <div className="flex justify-end mb-8">
          <ThemeToggle />
        </div>

        <div className="max-w-md mx-auto">
          {/* Logo */}
          <div className="flex justify-center mb-8">
            <div className="w-16 h-16 md:w-20 md:h-20 bg-gradient-to-br from-indigo-600 to-indigo-500 dark:from-indigo-500 dark:to-indigo-600 rounded-3xl flex items-center justify-center shadow-xl">
              <svg
                className="w-10 h-10 md:w-12 md:h-12 text-white"
                fill="none"
                stroke="currentColor"
                viewBox="0 0 24 24"
              >
                <path
                  strokeLinecap="round"
                  strokeLinejoin="round"
                  strokeWidth={2}
                  d="M9 12l2 2 4-4m5.618-4.016A11.955 11.955 0 0112 2.944a11.955 11.955 0 01-8.618 3.04A12.02 12.02 0 003 9c0 5.591 3.824 10.29 9 11.622 5.176-1.332 9-6.03 9-11.622 0-1.042-.133-2.052-.382-3.016z"
                />
              </svg>
            </div>
          </div>

          {/* Title */}
          <h1 className="text-3xl md:text-4xl font-bold text-center mb-2 text-slate-900 dark:text-white">
            Welcome to SafeBill
          </h1>
          <p className="text-center text-slate-500 dark:text-slate-400 mb-8">
            Manage your warranties and claims securely.
          </p>

          {/* Form Card */}
          <div className="bg-white dark:bg-slate-900/80 backdrop-blur-sm rounded-3xl border border-slate-200 dark:border-slate-800 p-6 md:p-8 shadow-xl">
            {/* User Type Toggle */}
            <div className="bg-slate-100 dark:bg-slate-950 p-1 rounded-2xl mb-6 flex">
              <button
                onClick={() => setUserType('consumer')}
                className={`flex-1 py-3 rounded-xl font-semibold transition-all ${
                  userType === 'consumer'
                    ? 'bg-white dark:bg-slate-800 text-slate-900 dark:text-white shadow-sm'
                    : 'text-slate-600 dark:text-slate-400'
                }`}
              >
                Consumer
              </button>
              <button
                onClick={() => setUserType('merchant')}
                className={`flex-1 py-3 rounded-xl font-semibold transition-all ${
                  userType === 'merchant'
                    ? 'bg-white dark:bg-slate-800 text-slate-900 dark:text-white shadow-sm'
                    : 'text-slate-600 dark:text-slate-400'
                }`}
              >
                Merchant
              </button>
            </div>

            {/* Form Fields */}
            <div className="space-y-4 mb-6">
              <div>
                <label className="block text-sm font-medium text-slate-700 dark:text-slate-300 mb-2">
                  {userType === 'consumer' ? 'Consumer ID' : 'Merchant ID'}
                </label>
                <div className="relative">
                  <User className="absolute left-3 top-1/2 -translate-y-1/2 w-5 h-5 text-slate-400 dark:text-slate-500" />
                  <input
                    type="text"
                    placeholder={`Enter your ${userType === 'consumer' ? 'consumer' : 'merchant'} ID`}
                    className="w-full pl-10 pr-4 py-4 bg-slate-50 dark:bg-slate-950 border border-slate-200 dark:border-slate-800 rounded-xl text-slate-900 dark:text-white placeholder-slate-400 dark:placeholder-slate-600 focus:outline-none focus:ring-2 focus:ring-indigo-500"
                  />
                </div>
              </div>

              <div>
                <label className="block text-sm font-medium text-slate-700 dark:text-slate-300 mb-2">
                  Password
                </label>
                <div className="relative">
                  <Lock className="absolute left-3 top-1/2 -translate-y-1/2 w-5 h-5 text-slate-400 dark:text-slate-500" />
                  <input
                    type="password"
                    placeholder="Enter your password"
                    className="w-full pl-10 pr-4 py-4 bg-slate-50 dark:bg-slate-950 border border-slate-200 dark:border-slate-800 rounded-xl text-slate-900 dark:text-white placeholder-slate-400 dark:placeholder-slate-600 focus:outline-none focus:ring-2 focus:ring-indigo-500"
                  />
                </div>
              </div>
            </div>

            {/* Login Button */}
            <button
              onClick={handleLogin}
              className="w-full bg-gradient-to-r from-indigo-500 to-indigo-600 text-white py-4 rounded-2xl font-semibold mb-5 hover:from-indigo-600 hover:to-indigo-700 transition-all shadow-lg shadow-indigo-500/30"
            >
              Login
            </button>

            {/* Divider */}
            <div className="flex items-center gap-4 mb-5">
              <div className="flex-1 h-px bg-slate-200 dark:bg-slate-700" />
              <span className="text-xs font-semibold text-slate-400 dark:text-slate-500">OR</span>
              <div className="flex-1 h-px bg-slate-200 dark:bg-slate-700" />
            </div>

            {/* Google Sign In */}
            <button
              onClick={handleGoogleSignIn}
              disabled={isLoading}
              className="w-full bg-white dark:bg-slate-800 border border-slate-200 dark:border-slate-700 text-slate-700 dark:text-white py-4 rounded-2xl font-semibold flex items-center justify-center gap-3 hover:bg-slate-50 dark:hover:bg-slate-700 transition-colors disabled:opacity-50"
            >
              <Chrome className="w-5 h-5" />
              {isLoading ? 'Signing in...' : 'Continue with Google'}
            </button>
          </div>

          {/* Sign Up Link */}
          <div className="text-center mt-6">
            <span className="text-slate-600 dark:text-slate-400">Don&apos;t have an account? </span>
            <button className="text-indigo-500 font-semibold hover:text-indigo-600">
              Sign up
            </button>
          </div>
        </div>
      </div>
    </div>
  )
}

