import useSWR from 'swr'
import { driverApi, CreateDriverInput } from '@/lib/api/drivers'

export function useDrivers() {
  const { data, error, isLoading, mutate } = useSWR('/drivers', driverApi.getAll)

  const createDriver = async (input: CreateDriverInput) => {
    await driverApi.create(input)
    mutate()
  }

  const deleteDriver = async (id: string) => {
    await driverApi.delete(id)
    mutate()
  }

  return {
    drivers: data ?? [],
    isLoading,
    error,
    createDriver,
    deleteDriver,
  }
}
