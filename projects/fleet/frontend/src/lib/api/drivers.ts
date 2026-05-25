const API_BASE = process.env.NEXT_PUBLIC_API_URL ?? 'http://localhost:8000/api/v1'

export interface Driver {
  id: string
  first_name: string
  last_name: string
  license_number: string
  license_expiry: string
  phone: string | null
  email: string | null
  status: 'active' | 'inactive' | 'suspended'
  assigned_vehicle_id: string | null
  created_at: string
}

export interface CreateDriverInput {
  first_name: string
  last_name: string
  license_number: string
  license_expiry: string
  phone?: string
  email?: string
  status?: Driver['status']
  assigned_vehicle_id?: string | null
}

export const driverApi = {
  getAll: async (): Promise<Driver[]> => {
    const res = await fetch(`${API_BASE}/drivers`)
    if (!res.ok) throw new Error('Failed to fetch drivers')
    return res.json()
  },
  getById: async (id: string): Promise<Driver> => {
    const res = await fetch(`${API_BASE}/drivers/${id}`)
    if (!res.ok) throw new Error('Driver not found')
    return res.json()
  },
  create: async (data: CreateDriverInput): Promise<Driver> => {
    const res = await fetch(`${API_BASE}/drivers`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(data),
    })
    if (!res.ok) throw new Error('Failed to create driver')
    return res.json()
  },
  update: async (id: string, data: Partial<CreateDriverInput>): Promise<Driver> => {
    const res = await fetch(`${API_BASE}/drivers/${id}`, {
      method: 'PUT',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(data),
    })
    if (!res.ok) throw new Error('Failed to update driver')
    return res.json()
  },
  delete: async (id: string): Promise<void> => {
    const res = await fetch(`${API_BASE}/drivers/${id}`, { method: 'DELETE' })
    if (!res.ok) throw new Error('Failed to delete driver')
  },
}
