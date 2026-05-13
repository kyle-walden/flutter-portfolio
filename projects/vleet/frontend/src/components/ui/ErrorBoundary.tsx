'use client'

import { Component, type ReactNode } from 'react'
import { Callout } from '@tremor/react'

interface Props { children: ReactNode; fallback?: ReactNode }
interface State { hasError: boolean; message: string }

export class ErrorBoundary extends Component<Props, State> {
  state = { hasError: false, message: '' }

  static getDerivedStateFromError(error: Error) {
    return { hasError: true, message: error.message }
  }

  render() {
    if (this.state.hasError) {
      return this.props.fallback ?? (
        <Callout title="Something went wrong" color="red">
          {this.state.message}
        </Callout>
      )
    }
    return this.props.children
  }
}