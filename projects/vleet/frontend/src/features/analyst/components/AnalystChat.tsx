'use client'

import { useState } from 'react'
import { TextInput, Button, Card, Callout, Accordion, AccordionBody, AccordionHeader } from '@tremor/react'

interface Message {
  role: 'user' | 'assistant'
  content: string
  sql?: string
}

export function AnalystChat() {
  const [messages, setMessages] = useState<Message[]>([])
  const [input, setInput] = useState('')
  const [isLoading, setIsLoading] = useState(false)

  const ask = async () => {
    if (!input.trim()) return
    const question = input
    setInput('')
    setMessages(prev => [...prev, { role: 'user', content: question }])
    setIsLoading(true)

    const res = await fetch('http://localhost:8000/api/v1/analyst/ask', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ question }),
    })
    const data = await res.json()
    setMessages(prev => [...prev, {
      role: 'assistant',
      content: data.insight,
      sql: data.sql_used,
    }])
    setIsLoading(false)
  }

  return (
    <div className="flex flex-col h-full space-y-4">
      <div className="flex-1 space-y-3 overflow-y-auto">
        {messages.map((msg, i) => (
          <div key={i} className={msg.role === 'user' ? 'text-right' : ''}>
            <Card className={`inline-block max-w-2xl text-left ${msg.role === 'user' ? 'bg-blue-50' : ''}`}>
              <p>{msg.content}</p>
              {msg.sql && (
                <Accordion className="mt-2">
                  <AccordionHeader>Generated SQL</AccordionHeader>
                  <AccordionBody>
                    <pre className="text-xs bg-gray-100 p-2 rounded overflow-x-auto">{msg.sql}</pre>
                  </AccordionBody>
                </Accordion>
              )}
            </Card>
          </div>
        ))}
        {isLoading && <Card className="inline-block"><p className="text-gray-500">Thinking...</p></Card>}
      </div>
      <div className="flex gap-2">
        <TextInput
          placeholder='Try: "Which vehicle has the highest fuel consumption this month?"'
          value={input}
          onChange={(e) => setInput(e.target.value)}
          onKeyDown={(e) => e.key === 'Enter' && ask()}
          className="flex-1"
        />
        <Button onClick={ask} loading={isLoading}>Ask</Button>
      </div>
    </div>
  )
}