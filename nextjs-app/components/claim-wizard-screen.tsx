'use client'

import { useState, useEffect } from 'react'
import { ArrowLeft, Sparkles } from 'lucide-react'
import { useRouter } from 'next/navigation'
import { apiClient } from '@/lib/api-client'
import type { Document } from '@/lib/types'
import { format } from 'date-fns'

export function ClaimWizardScreen() {
  const router = useRouter()
  const [documents, setDocuments] = useState<Document[]>([])
  const [selectedDoc, setSelectedDoc] = useState<Document | null>(null)
  const [issue, setIssue] = useState('')
  const [draft, setDraft] = useState<string | null>(null)
  const [isLoading, setIsLoading] = useState(true)

  useEffect(() => {
    loadDocuments()
  }, [])

  useEffect(() => {
    if (documents.length > 0 && !selectedDoc) {
      setSelectedDoc(documents[0])
    }
  }, [documents, selectedDoc])

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

  const generateDraft = () => {
    if (!selectedDoc) return

    const item = selectedDoc.items[0]
    const issueText = issue.trim() || 'Device stopped working unexpectedly'

    const letter = `
To,
${selectedDoc.sellerName || 'Seller'},

Subject: Warranty claim for ${item.productName || 'the product'} (Invoice ${item.invoiceNo || selectedDoc.docId})

I purchased the product on ${item.purchaseDate ? format(new Date(item.purchaseDate), 'MMMM d, yyyy') : 'unknown date'} and the warranty is valid through ${item.warrantyEnd ? format(new Date(item.warrantyEnd), 'MMMM d, yyyy') : 'unknown date'}.

Issue summary:
- ${issueText}

Request:
- Arrange inspection/service at the earliest.
- Provide written acknowledgement as per Consumer Protection Act 2019.

Attached: invoice, warranty card, images/videos evidencing the defect.

Regards,
SafeBill user
    `.trim()

    setDraft(letter)
  }

  if (isLoading) {
    return (
      <div className="min-h-screen bg-slate-50 dark:bg-slate-950 flex items-center justify-center">
        <div className="text-slate-500">Loading...</div>
      </div>
    )
  }

  if (documents.length === 0) {
    return (
      <div className="min-h-screen bg-slate-50 dark:bg-slate-950 flex items-center justify-center">
        <div className="text-center">
          <p className="text-slate-600 dark:text-slate-400">Add a document first.</p>
        </div>
      </div>
    )
  }

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
            <h1 className="text-2xl font-bold text-slate-900 dark:text-white">Claim Wizard</h1>
          </div>

          <div className="space-y-6">
            <div>
              <label className="block text-sm font-medium text-slate-700 dark:text-slate-300 mb-2">
                Document
              </label>
              <select
                value={selectedDoc?.docId || ''}
                onChange={(e) => {
                  const doc = documents.find((d) => d.docId === e.target.value)
                  setSelectedDoc(doc || null)
                  setDraft(null)
                }}
                className="w-full px-4 py-3 bg-white dark:bg-slate-900 border border-slate-200 dark:border-slate-800 rounded-xl text-slate-900 dark:text-white focus:outline-none focus:ring-2 focus:ring-indigo-500"
              >
                {documents.map((doc) => (
                  <option key={doc.docId} value={doc.docId}>
                    {doc.title}
                  </option>
                ))}
              </select>
            </div>

            <div>
              <label className="block text-sm font-medium text-slate-700 dark:text-slate-300 mb-2">
                Issue description
              </label>
              <textarea
                value={issue}
                onChange={(e) => setIssue(e.target.value)}
                placeholder="Describe the defect or support experience"
                rows={4}
                className="w-full px-4 py-3 bg-white dark:bg-slate-900 border border-slate-200 dark:border-slate-800 rounded-xl text-slate-900 dark:text-white placeholder-slate-400 dark:placeholder-slate-600 focus:outline-none focus:ring-2 focus:ring-indigo-500 resize-none"
              />
            </div>

            <button
              onClick={generateDraft}
              className="w-full flex items-center justify-center gap-2 py-4 px-6 bg-gradient-to-r from-indigo-500 to-indigo-600 text-white rounded-2xl font-semibold hover:from-indigo-600 hover:to-indigo-700 transition-all"
            >
              <Sparkles className="w-5 h-5" />
              Generate claim letter
            </button>

            {draft && (
              <div>
                <h3 className="text-lg font-semibold text-slate-900 dark:text-white mb-3">
                  Draft email
                </h3>
                <div className="p-4 bg-white dark:bg-slate-900 border border-slate-200 dark:border-slate-800 rounded-xl">
                  <pre className="text-sm text-slate-700 dark:text-slate-300 whitespace-pre-wrap font-sans">
                    {draft}
                  </pre>
                </div>
              </div>
            )}
          </div>
        </div>
      </div>
    </div>
  )
}

