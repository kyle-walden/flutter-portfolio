'use client'

import Link from 'next/link'
import { usePathname } from 'next/navigation'
import { TruckIcon, UsersIcon, BeakerIcon, ArrowUpTrayIcon, ChatBubbleLeftIcon } from '@heroicons/react/24/outline'

const navItems = [
  { label: 'Dashboard', href: '/', icon: BeakerIcon },
  { label: 'Vehicles', href: '/vehicles', icon: TruckIcon },
  { label: 'Drivers', href: '/drivers', icon: UsersIcon },
  { label: 'Fuel', href: '/fuel', icon: BeakerIcon },
  { label: 'Ingest', href: '/ingest', icon: ArrowUpTrayIcon },
  { label: 'Analyst', href: '/analyst', icon: ChatBubbleLeftIcon },
]

// usePathname() is the equivalent of _indexFromPath() in your AppShell.dart
export function Sidebar({ isOpen }: { isOpen: boolean }) {
  const pathname = usePathname()

  return (
    <aside className={`${isOpen ? 'w-56' : 'w-16'} bg-white border-r border-gray-200 transition-all duration-200`}>
      <div className="p-4 font-bold text-lg border-b">Fleet</div>
      <nav className="p-2 space-y-1">
        {navItems.map((item) => {
          const isActive = pathname === item.href || (item.href !== '/' && pathname.startsWith(item.href))
          return (
            <Link
              key={item.href}
              href={item.href}
              className={`flex items-center gap-3 px-3 py-2 rounded-lg text-sm transition-colors
                ${isActive ? 'bg-blue-50 text-blue-700 font-medium' : 'text-gray-600 hover:bg-gray-100'}`}
            >
              <item.icon className="h-5 w-5 flex-shrink-0" />
              {isOpen && <span>{item.label}</span>}
            </Link>
          )
        })}
      </nav>
    </aside>
  )
}