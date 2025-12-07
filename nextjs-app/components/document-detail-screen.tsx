'use client'

import { useState, useEffect } from 'react'
import { useRouter } from 'next/navigation'
import { ArrowLeft, ShieldCheck, Calendar, DollarSign, Hash } from 'lucide-react'
import { apiClient } from '@/lib/api-client'
import type { Document } from '@/lib/types'
import { format } from 'date-fns'

export function DocumentDetailScreen({ docId }: { docId: string }) {
  const router = useRouter()
  const [document, setDocument] = useState<Document | null>(null)
  const [isLoading, setIsLoading] = useState(true)

  useEffect(() => {
    loadDocument()
  }, [docId])

  const loadDocument = async () => {
    try {
      setIsLoading(true)
      const response = await apiClient.get<{ document: Document }>(`/documents/${docId}`)
      setDocument(response.document)
    } catch (error) {
      console.error('Failed to load document:', error)
    } finally {
      setIsLoading(false)
    }
  }

  if (isLoading) {
    return (
      <div className="min-h-screen bg-slate-50 dark:bg-slate-950 flex items-center justify-center">
        <div className="text-slate-500">Loading...</div>
      </div>
    )
  }

  if (!document) {
    return (
      <div className="min-h-screen bg-slate-50 dark:bg-slate-950 flex items-center justify-center">
        <div className="text-center">
          <p className="text-slate-600 dark:text-slate-400">Document not found</p>
        </div>
      </div>
    )
  }

  const item = document.items[0]

  return (
    <div className="min-h-screen bg-slate-50 dark:bg-slate-950">
      <div className="container mx-auto px-4 py-6">
        <div className="max-w-3xl mx-auto">
          <button
            onClick={() => router.back()}
            className="mb-6 flex items-center gap-2 text-slate-600 dark:text-slate-400 hover:text-slate-900 dark:hover:text-white"
          >
            <ArrowLeft className="w-5 h-5" />
            Back
          </button>

          <div className="bg-white dark:bg-slate-900 border border-slate-200 dark:border-slate-800 rounded-3xl p-6 md:p-8 shadow-lg">
            <h1 className="text-2xl font-bold text-slate-900 dark:text-white mb-6">
              {document.title}
            </h1>

            <div className="space-y-6">
              {/* Product Info */}
              <div>
                <h2 className="text-lg font-semibold text-slate-900 dark:text-white mb-4">
                  Product Information
                </h2>
                <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                  <InfoItem
                    icon={ShieldCheck}
                    label="Product Name"
                    value={item.productName || 'N/A'}
                  />
                  <InfoItem icon={Hash} label="Model" value={item.model || 'N/A'} />
                  <InfoItem
                    icon={Hash}
                    label="Invoice No"
                    value={item.invoiceNo || 'N/A'}
                  />
                  <InfoItem
                    icon={Hash}
                    label="Serial Number"
                    value={item.serialNumber || 'N/A'}
                  />
                </div>
              </div>

              {/* Purchase Info */}
              <div>
                <h2 className="text-lg font-semibold text-slate-900 dark:text-white mb-4">
                  Purchase Information
                </h2>
                <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                  <InfoItem
                    icon={Calendar}
                    label="Purchase Date"
                    value={
                      item.purchaseDate
                        ? format(new Date(item.purchaseDate), 'MMMM d, yyyy')
                        : 'N/A'
                    }
                  />
                  <InfoItem
                    icon={DollarSign}
                    label="Purchase Price"
                    value={item.purchasePrice ? `₹${item.purchasePrice.toLocaleString()}` : 'N/A'}
                  />
                </div>
              </div>

              {/* Warranty Info */}
              <div>
                <h2 className="text-lg font-semibold text-slate-900 dark:text-white mb-4">
                  Warranty Information
                </h2>
                <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                  <InfoItem
                    icon={Calendar}
                    label="Warranty Start"
                    value={
                      item.warrantyStart
                        ? format(new Date(item.warrantyStart), 'MMMM d, yyyy')
                        : 'N/A'
                    }
                  />
                  <InfoItem
                    icon={Calendar}
                    label="Warranty End"
                    value={
                      item.warrantyEnd
                        ? format(new Date(item.warrantyEnd), 'MMMM d, yyyy')
                        : 'N/A'
                    }
                  />
                  <InfoItem
                    icon={ShieldCheck}
                    label="Warranty Period"
                    value={item.warrantyMonths ? `${item.warrantyMonths} months` : 'N/A'}
                  />
                  <InfoItem
                    icon={ShieldCheck}
                    label="Extended Warranty"
                    value={item.extendedWarrantyPurchased ? 'Yes' : 'No'}
                  />
                </div>
              </div>

              {/* Service Centers */}
              {item.serviceCenters.length > 0 && (
                <div>
                  <h2 className="text-lg font-semibold text-slate-900 dark:text-white mb-4">
                    Service Centers
                  </h2>
                  <ul className="space-y-2">
                    {item.serviceCenters.map((center, idx) => (
                      <li
                        key={idx}
                        className="text-slate-700 dark:text-slate-300 pl-4 border-l-2 border-indigo-500"
                      >
                        {center}
                      </li>
                    ))}
                  </ul>
                </div>
              )}

              {/* Notes */}
              {item.notes && (
                <div>
                  <h2 className="text-lg font-semibold text-slate-900 dark:text-white mb-4">
                    Notes
                  </h2>
                  <p className="text-slate-700 dark:text-slate-300">{item.notes}</p>
                </div>
              )}
            </div>
          </div>
        </div>
      </div>
    </div>
  )
}

function InfoItem({
  icon: Icon,
  label,
  value,
}: {
  icon: any
  label: string
  value: string
}) {
  return (
    <div className="flex items-start gap-3">
      <Icon className="w-5 h-5 text-indigo-500 mt-0.5 flex-shrink-0" />
      <div>
        <p className="text-xs font-medium text-slate-500 dark:text-slate-400 mb-1">{label}</p>
        <p className="text-sm font-semibold text-slate-900 dark:text-white">{value}</p>
      </div>
    </div>
  )
}

