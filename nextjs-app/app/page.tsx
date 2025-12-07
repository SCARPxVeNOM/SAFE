import { redirect } from 'next/navigation'
import { OnboardingScreen } from '@/components/onboarding-screen'

export default function Home() {
  // Check if user has completed onboarding
  // For now, always show onboarding
  return <OnboardingScreen />
}

