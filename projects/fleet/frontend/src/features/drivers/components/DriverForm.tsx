'use client'

import { useForm } from 'react-hook-form'
import { zodResolver } from '@hookform/resolvers/zod'
import { Button, TextInput, Select, SelectItem, Card } from '@tremor/react'
import { driverSchema, DriverFormValues } from '../schemas/driver-schema'
import { useDrivers } from '../hooks/useDrivers'
import { useVehicles } from '@/features/vehicles/hooks/useVehicles'

interface DriverFormProps {
  onSuccess: () => void
}

export function DriverForm({ onSuccess }: DriverFormProps) {
  const { createDriver } = useDrivers()
  const { vehicles } = useVehicles()

  const {
    register,
    handleSubmit,
    setValue,
    formState: { errors, isSubmitting },
    reset,
  } = useForm<DriverFormValues>({
    resolver: zodResolver(driverSchema),
    defaultValues: { status: 'active' },
  })

  const onSubmit = async (values: DriverFormValues) => {
    await createDriver(values)
    reset()
    onSuccess()
  }

  return (
    <Card>
      <form onSubmit={handleSubmit(onSubmit)} className="space-y-4">
        <div className="grid grid-cols-2 gap-4">
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-1">First Name</label>
            <TextInput
              {...register('first_name')}
              placeholder="John"
              error={!!errors.first_name}
              errorMessage={errors.first_name?.message}
            />
          </div>
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-1">Last Name</label>
            <TextInput
              {...register('last_name')}
              placeholder="Smith"
              error={!!errors.last_name}
              errorMessage={errors.last_name?.message}
            />
          </div>
        </div>

        <div className="grid grid-cols-2 gap-4">
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-1">License Number</label>
            <TextInput
              {...register('license_number')}
              placeholder="DL-12345"
              error={!!errors.license_number}
              errorMessage={errors.license_number?.message}
            />
          </div>
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-1">License Expiry</label>
            <TextInput
              type="date"
              {...register('license_expiry')}
              error={!!errors.license_expiry}
              errorMessage={errors.license_expiry?.message}
            />
          </div>
        </div>

        <div className="grid grid-cols-2 gap-4">
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-1">Phone</label>
            <TextInput {...register('phone')} placeholder="+27 82 000 0000" />
          </div>
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-1">Email</label>
            <TextInput
              {...register('email')}
              placeholder="driver@example.com"
              error={!!errors.email}
              errorMessage={errors.email?.message}
            />
          </div>
        </div>

        <div className="grid grid-cols-2 gap-4">
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-1">Status</label>
            <Select
              defaultValue="active"
              onValueChange={(val) => setValue('status', val as DriverFormValues['status'])}
            >
              <SelectItem value="active">Active</SelectItem>
              <SelectItem value="inactive">Inactive</SelectItem>
              <SelectItem value="suspended">Suspended</SelectItem>
            </Select>
          </div>
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-1">Assigned Vehicle</label>
            <Select onValueChange={(val) => setValue('assigned_vehicle_id', val || null)}>
              <SelectItem value="">None</SelectItem>
              {vehicles.map((v) => (
                <SelectItem key={v.id} value={v.id}>
                  {v.registration} — {v.make} {v.model}
                </SelectItem>
              ))}
            </Select>
          </div>
        </div>

        <div className="flex justify-end">
          <Button type="submit" loading={isSubmitting}>Add Driver</Button>
        </div>
      </form>
    </Card>
  )
}
