'use client'

import { Table, TableHead, TableRow, TableHeaderCell, TableBody, TableCell, Badge, Button } from '@tremor/react'
import { useVehicles } from '../hooks/useVehicles'
import type { Vehicle } from '@/lib/api/vehicles'

const statusColor = { active: 'green', maintenance: 'yellow', retired: 'red' } as const

export function VehicleTable({ initialData }: { initialData: Vehicle[] }) {
  const { vehicles, isLoading, deleteVehicle } = useVehicles()
  const data = vehicles.length > 0 ? vehicles : initialData  // use live data if available

  return (
    <Table>
      <TableHead>
        <TableRow>
          <TableHeaderCell>Registration</TableHeaderCell>
          <TableHeaderCell>Make / Model</TableHeaderCell>
          <TableHeaderCell>Year</TableHeaderCell>
          <TableHeaderCell>Odometer</TableHeaderCell>
          <TableHeaderCell>Status</TableHeaderCell>
          <TableHeaderCell>Actions</TableHeaderCell>
        </TableRow>
      </TableHead>
      <TableBody>
        {data.map((v) => (
          <TableRow key={v.id}>
            <TableCell className="font-mono">{v.registration}</TableCell>
            <TableCell>{v.make} {v.model}</TableCell>
            <TableCell>{v.year}</TableCell>
            <TableCell>{v.odometer_km.toLocaleString()} km</TableCell>
            <TableCell>
              <Badge color={statusColor[v.status]}>{v.status}</Badge>
            </TableCell>
            <TableCell>
              <Button size="xs" variant="secondary" onClick={() => deleteVehicle(v.id)}>
                Delete
              </Button>
            </TableCell>
          </TableRow>
        ))}
      </TableBody>
    </Table>
  )
}