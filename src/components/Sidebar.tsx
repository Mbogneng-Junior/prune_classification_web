'use client';

import Link from 'next/link';
import { usePathname } from 'next/navigation';
import { BsHouseDoor, BsClock, BsPerson, BsGear, BsBoxArrowRight } from 'react-icons/bs';
import { useRouter } from 'next/navigation';

export default function Sidebar() {
  const pathname = usePathname();
  const router = useRouter();

  const menuItems = [
    { name: 'Accueil', path: '/', icon: BsHouseDoor },
    { name: 'Historique', path: '/history', icon: BsClock },
    { name: 'Profil', path: '/profile', icon: BsPerson },
    { name: 'Paramètres', path: '/settings', icon: BsGear },
  ];

  const handleLogout = () => {
    localStorage.removeItem('isAuthenticated');
    router.push('/auth/login');
  };

  return (
    <div className="sidebar bg-white border-r border-gray-200 d-none d-lg-flex flex-column">
      <div className="sidebar-brand p-4">
        <Link href="/" className="text-decoration-none d-flex align-items-center">
          <div className="bg-teal-600 rounded-lg p-2 me-3">
            <svg className="text-white" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
              <path d="M20 7L10 17L5 12" />
            </svg>
          </div>
          <span className="fs-5 fw-semibold text-gray-800">Tri des Prunes</span>
        </Link>
      </div>

      <div className="sidebar-menu flex-grow-1 px-3">
        {menuItems.map((item) => {
          const Icon = item.icon;
          const isActive = pathname === item.path;
          
          return (
            <Link
              key={item.path}
              href={item.path}
              className={`sidebar-item d-flex align-items-center text-decoration-none p-3 mb-2 rounded-lg transition-all ${
                isActive 
                  ? 'bg-teal-50 text-teal-600 font-medium'
                  : 'text-gray-600 hover:bg-gray-50'
              }`}
            >
              <Icon className="me-3" size={20} />
              <span>{item.name}</span>
              {isActive && (
                <div className="ms-auto">
                  <div className="bg-teal-600 rounded-full w-2 h-2" />
                </div>
              )}
            </Link>
          );
        })}
      </div>

      <div className="sidebar-footer p-4">
        <button 
          onClick={handleLogout}
          className="btn w-100 border-2 border-gray-200 text-gray-700 d-flex align-items-center justify-content-center gap-2 hover:bg-gray-50"
        >
          <BsBoxArrowRight />
          Déconnexion
        </button>
      </div>
    </div>
  );
}
