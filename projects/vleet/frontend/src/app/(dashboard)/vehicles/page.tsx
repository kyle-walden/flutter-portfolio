import { vehicleApi } from '@/lib/api/vehicles'
import { VehicleTable } from '@/features/vehicles/components/VehicleTable'

export default async function VehiclesPage() {
  const vehicles = await vehicleApi.getAll()  // runs on server — no useEffect
  return (
    <div>
      <h1 className="text-2xl font-bold mb-6">Vehicles</h1>
      <VehicleTable initialData={vehicles} />
    </div>
  )
}