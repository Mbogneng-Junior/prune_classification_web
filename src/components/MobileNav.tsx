'use client';

import Link from 'next/link';
import { usePathname } from 'next/navigation';
import { BsHouseDoor, BsClock, BsPerson, BsGear } from 'react-icons/bs';

export default function MobileNav() {
  const pathname = usePathname();

  const navItems = [
    { name: 'Accueil', path: '/', icon: BsHouseDoor },
    { name: 'Historique', path: '/history', icon: BsClock },
    { name: 'Profil', path: '/profile', icon: BsPerson },
    { name: 'Paramètres', path: '/settings', icon: BsGear },
  ];

  return (
    <div className="mobile-nav d-flex d-lg-none">
      {navItems.map((item) => {
        const Icon = item.icon;
        const isActive = pathname === item.path;
        
        return (
          <Link
            key={item.path}
            href={item.path}
            className={`mobile-nav-item ${isActive ? 'active' : ''}`}
          >
            <Icon size={24} className="d-block mx-auto mb-1" />
            <small>{item.name}</small>
          </Link>
        );
      })}
    </div>
  );
}
