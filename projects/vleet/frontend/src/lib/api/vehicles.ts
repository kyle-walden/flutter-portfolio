const API_BASE = process.env.NEXT_PUBLIC_API_URL ?? 'http://localhost:8000/api/v1'

export interface Vehicle {
  id: string
  registration: string
  make: string
  model: string
  year: number
  odometer_km: number
  status: 'active' | 'maintenance' | 'retired'
  created_at: string
}

export interface CreateVehicleInput {
  registration: string
  make: string
  model: string
  year: number
  odometer_km?: number
  status?: Vehicle['status']
}

export const vehicleApi = {
  getAll: async (): Promise<Vehicle[]> => {
    const res = await fetch(`${API_BASE}/vehicles`)
    if (!res.ok) throw new Error('Failed to fetch vehicles')
    return res.json()
  },
  getById: async (id: string): Promise<Vehicle> => {
    const res = await fetch(`${API_BASE}/vehicles/${id}`)
    if (!res.ok) throw new Error('Vehicle not found')
    return res.json()
  },
  create: async (data: CreateVehicleInput): Promise<Vehicle> => {
    const res = await fetch(`${API_BASE}/vehicles`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(data),
    })
    if (!res.ok) throw new Error('Failed to create vehicle')
    return res.json()
  },
  update: async (id: string, data: Partial<CreateVehicleInput>): Promise<Vehicle> => {
    const res = await fetch(`${API_BASE}/vehicles/${id}`, {
      method: 'PUT',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(data),
    })
    if (!res.ok) throw new Error('Failed to update vehicle')
    return res.json()
  },
  delete: async (id: string): Promise<void> => {
    const res = await fetch(`${API_BASE}/vehicles/${id}`, { method: 'DELETE' })
    if (!res.ok) throw new Error('Failed to delete vehicle')
  },
}