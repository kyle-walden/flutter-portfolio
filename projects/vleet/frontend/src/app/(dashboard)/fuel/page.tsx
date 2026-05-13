import { AreaChart, BarChart, Card, Metric, Text } from '@tremor/react'

export default async function FuelPage() {
  const [summary, transactions] = await Promise.all([
    fuelApi.getSummaryByVehicle(),
    fuelApi.getRecent(30),       // last 30 days
  ])

  return (
    <div className="space-y-6">
      {/* KPI Cards */}
      <div className="grid grid-cols-3 gap-4">
        <Card>
          <Text>Total Spend (30d)</Text>
          <Metric>R {summary.total_cost.toFixed(2)}</Metric>
        </Card>
        ...
      </div>

      {/* Spend over time */}
      <Card>
        <AreaChart data={transactions} index="date" categories={['total_cost']} />
      </Card>

      {/* L/100km per vehicle */}
      <Card>
        <BarChart data={summary.byVehicle} index="registration" categories={['l_per_100km']} />
      </Card>
    </div>
  )
}