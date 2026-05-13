'use client'

import { useState } from 'react'
import { Table, TableHead, TableRow, TableHeaderCell, TableBody, TableCell, Badge, Button } from '@tremor/react'
import { useDrivers } from '../hooks/useDrivers'
import { DriverForm } from './DriverForm'
import type { Driver } from '@/lib/api/drivers'

const statusColor = { active: 'green', inactive: 'gray', suspended: 'red' } as const

export function DriverTable({ initialData }: { initialData: Driver[] }) {
  const { drivers, deleteDriver } = useDrivers()
  const [showForm, setShowForm] = useState(false)
  const data = drivers.length > 0 ? drivers : initialData

  return (
    <div className="space-y-4">
      <div className="flex justify-end">
        <Button variant="secondary" onClick={() => setShowForm(!showForm)}>
          {showForm ? 'Cancel' : 'Add Driver'}
        </Button>
      </div>

      {showForm && <DriverForm onSuccess={() => setShowForm(false)} />}

      <Table>
        <TableHead>
          <TableRow>
            <TableHeaderCell>Name</TableHeaderCell>
            <TableHeaderCell>License</TableHeaderCell>
            <TableHeaderCell>Expiry</TableHeaderCell>
            <TableHeaderCell>Phone</TableHeaderCell>
            <TableHeaderCell>Email</TableHeaderCell>
            <TableHeaderCell>Status</TableHeaderCell>
            <TableHeaderCell>Actions</TableHeaderCell>
          </TableRow>
        </TableHead>
        <TableBody>
          {data.map((d) => (
            <TableRow key={d.id}>
              <TableCell>{d.first_name} {d.last_name}</TableCell>
              <TableCell className="font-mono">{d.license_number}</TableCell>
              <TableCell>{new Date(d.license_expiry).toLocaleDateString()}</TableCell>
              <TableCell>{d.phone ?? '—'}</TableCell>
              <TableCell>{d.email ?? '—'}</TableCell>
              <TableCell>
                <Badge color={statusColor[d.status]}>{d.status}</Badge>
              </TableCell>
              <TableCell>
                <Button size="xs" variant="secondary" onClick={() => deleteDriver(d.id)}>
                  Delete
                </Button>
              </TableCell>
            </TableRow>
          ))}
        </TableBody>
      </Table>
    </div>
  )
}
