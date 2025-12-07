'use client'

import { useState } from 'react'
import { useRouter } from 'next/navigation'
import { Camera, ArrowLeft } from 'lucide-react'
import { apiClient } from '@/lib/api-client'

export function ScanScreen() {
  const router = useRouter()
  const [isLoading, setIsLoading] = useState(false)
  const [file, setFile] = useState<File | null>(null)

  const handleFileChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    if (e.target.files && e.target.files[0]) {
      setFile(e.target.files[0])
    }
  }

  const handleScan = async () => {
    if (!file) {
      alert('Please select a file first')
      return
    }

    setIsLoading(true)
    try {
      const formData = new FormData()
      formData.append('file', file)
      formData.append('userId', 'user123') // Get from auth

      const response = await apiClient.postFormData<{ document: { docId: string } }>('/ingest', formData)

      if (response.document) {
        router.push(`/document/${response.document.docId}`)
      }
    } catch (error) {
      console.error('Scan failed:', error)
      alert('Failed to process invoice. Please try again.')
    } finally {
      setIsLoading(false)
    }
  }

  return (
    <div className="min-h-screen bg-slate-50 dark:bg-slate-950">
      <div className="container mx-auto px-4 py-6">
        <button
          onClick={() => router.back()}
          className="mb-6 flex items-center gap-2 text-slate-600 dark:text-slate-400 hover:text-slate-900 dark:hover:text-white"
        >
          <ArrowLeft className="w-5 h-5" />
          Back
        </button>

        <div className="max-w-2xl mx-auto">
          <h1 className="text-2xl font-bold text-slate-900 dark:text-white mb-6">
            Scan Invoice
          </h1>

          <div className="bg-white dark:bg-slate-900 border-2 border-indigo-500 rounded-3xl p-12 mb-6 min-h-[400px] flex items-center justify-center">
            {file ? (
              <div className="text-center">
                <p className="text-slate-600 dark:text-slate-400 mb-4">
                  Selected: {file.name}
                </p>
                <button
                  onClick={() => setFile(null)}
                  className="text-sm text-indigo-500 hover:text-indigo-600"
                >
                  Change file
                </button>
              </div>
            ) : (
              <div className="text-center">
                <Camera className="w-16 h-16 text-slate-400 dark:text-slate-600 mx-auto mb-4" />
                <p className="text-slate-600 dark:text-slate-400 mb-4">
                  Use your device camera to capture an invoice.
                </p>
                <p className="text-sm text-slate-500 dark:text-slate-500">
                  SafeBill will auto-crop, extract text, and fill the metadata for review.
                </p>
              </div>
            )}
          </div>

          <div className="space-y-4">
            <label className="block">
              <input
                type="file"
                accept="image/*,.pdf"
                onChange={handleFileChange}
                className="hidden"
              />
              <div className="w-full py-4 px-6 bg-indigo-500 text-white rounded-2xl font-semibold text-center cursor-pointer hover:bg-indigo-600 transition-colors">
                {file ? 'Change File' : 'Select File'}
              </div>
            </label>

            <button
              onClick={handleScan}
              disabled={!file || isLoading}
              className="w-full py-4 px-6 bg-gradient-to-r from-indigo-500 to-indigo-600 text-white rounded-2xl font-semibold disabled:opacity-50 disabled:cursor-not-allowed hover:from-indigo-600 hover:to-indigo-700 transition-all"
            >
              {isLoading ? 'Scanning...' : 'Start Scan'}
            </button>
          </div>

          <p className="text-sm text-slate-500 dark:text-slate-400 mt-4 text-center">
            Tip: You can switch to PDF upload or offline OCR from Settings → Capture preferences.
          </p>
        </div>
      </div>
    </div>
  )
}

