import { driverApi } from '@/lib/api/drivers'
import { DriverTable } from '@/features/drivers/components/DriverTable'

export default async function DriversPage() {
  const drivers = await driverApi.getAll()
  return (
    <div>
      <h1 className="text-2xl font-bold mb-6">Drivers</h1>
      <DriverTable initialData={drivers} />
    </div>
  )
}
