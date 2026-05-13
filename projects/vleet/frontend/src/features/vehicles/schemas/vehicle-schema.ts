import { z } from 'zod'

export const vehicleSchema = z.object({
  registration: z.string().min(2).max(20).toUpperCase(),
  make: z.string().min(1, 'Make is required'),
  model: z.string().min(1, 'Model is required'),
  year: z.coerce.number().min(1990).max(new Date().getFullYear() + 1),
  odometer_km: z.coerce.number().min(0).default(0),
  status: z.enum(['active', 'maintenance', 'retired']).default('active'),
})

export type VehicleFormValues = z.infer<typeof vehicleSchema>