import useSWR from 'swr'
import { vehicleApi, CreateVehicleInput } from '@/lib/api/vehicles'

export function useVehicles() {
  const { data, error, isLoading, mutate } = useSWR(
    '/vehicles',            // cache key — like Provider's identity
    vehicleApi.getAll       // fetcher function
  )

  const createVehicle = async (input: CreateVehicleInput) => {
    await vehicleApi.create(input)
    mutate()  // equivalent of notifyListeners() — triggers re-fetch
  }

  const deleteVehicle = async (id: string) => {
    await vehicleApi.delete(id)
    mutate()
  }

  return {
    vehicles: data ?? [],
    isLoading,
    error,
    createVehicle,
    deleteVehicle,
  }
}