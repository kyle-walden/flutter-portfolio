'use client'

import { useCallback, useState } from 'react'
import { useDropzone } from 'react-dropzone'
import { Button, Card } from '@tremor/react'

export function UploadZone() {
  const [jobId, setJobId] = useState<string | null>(null)
  const [status, setStatus] = useState<'idle' | 'uploading' | 'processing' | 'done'>('idle')

  const onDrop = useCallback(async (files: File[]) => {
    const file = files[0]
    setStatus('uploading')

    const formData = new FormData()
    formData.append('file', file)

    const res = await fetch('http://localhost:8000/api/v1/ingest/upload', {
      method: 'POST',
      body: formData,
    })
    const { job_id } = await res.json()
    setJobId(job_id)
    setStatus('processing')

    // Poll for completion
    const interval = setInterval(async () => {
      const statusRes = await fetch(`http://localhost:8000/api/v1/ingest/status/${job_id}`)
      const data = await statusRes.json()
      if (data.status === 'completed' || data.status === 'failed') {
        setStatus(data.status === 'completed' ? 'done' : 'idle')
        clearInterval(interval)
      }
    }, 2000)
  }, [])

  const { getRootProps, getInputProps, isDragActive } = useDropzone({
    onDrop,
    accept: { 'application/pdf': ['.pdf'], 'text/csv': ['.csv'] },
    maxFiles: 1,
  })

  return (
    <Card
      {...getRootProps()}
      className={`cursor-pointer border-2 border-dashed p-12 text-center
        ${isDragActive ? 'border-blue-500 bg-blue-50' : 'border-gray-300'}`}
    >
      <input {...getInputProps()} />
      {status === 'idle' && <p>Drop a PDF or CSV fuel card statement here</p>}
      {status === 'uploading' && <p>Uploading...</p>}
      {status === 'processing' && <p>AI is extracting transactions...</p>}
    </Card>
  )
}