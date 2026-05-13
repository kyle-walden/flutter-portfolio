import { z } from 'zod'

export const driverSchema = z.object({
  first_name: z.string().min(1, 'First name is required'),
  last_name: z.string().min(1, 'Last name is required'),
  license_number: z.string().min(1, 'License number is required'),
  license_expiry: z.string().min(1, 'License expiry is required'),
  phone: z.string().optional(),
  email: z.string().email('Invalid email').optional().or(z.literal('')),
  status: z.enum(['active', 'inactive', 'suspended']).default('active'),
  assigned_vehicle_id: z.string().nullable().optional(),
})

export type DriverFormValues = z.infer<typeof driverSchema>
