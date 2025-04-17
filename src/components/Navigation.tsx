'use client';

import Link from 'next/link';
import { usePathname } from 'next/navigation';
import { BsHouseDoor, BsClock, BsPerson, BsGear } from 'react-icons/bs';
import { useRouter } from 'next/navigation';

export default function Navigation() {
  const pathname = usePathname();
  const router = useRouter();

  const navItems = [
    { name: 'Accueil', path: '/', Icon: BsHouseDoor },
    { name: 'Historique', path: '/history', Icon: BsClock },
    { name: 'Profil', path: '/profile', Icon: BsPerson },
    { name: 'Paramètres', path: '/settings', Icon: BsGear },
  ];

  const handleLogout = () => {
    localStorage.removeItem('isAuthenticated');
    router.push('/auth/login');
  };

  return (
    <nav className="navbar navbar-expand-lg navbar-light bg-white fixed-top shadow-sm">
      <div className="container">
        <Link href="/" className="navbar-brand d-flex align-items-center text-success">
          <svg className="me-2" width="30" height="30" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
            <path d="M20 7L10 17L5 12" />
          </svg>
          <span className="fw-bold">Tri des Prunes</span>
        </Link>

        <button
          className="navbar-toggler"
          type="button"
          data-bs-toggle="collapse"
          data-bs-target="#navbarNav"
          aria-controls="navbarNav"
          aria-expanded="false"
          aria-label="Toggle navigation"
        >
          <span className="navbar-toggler-icon"></span>
        </button>

        <div className="collapse navbar-collapse justify-content-end" id="navbarNav">
          <ul className="navbar-nav align-items-center">
            {navItems.map((item) => {
              const Icon = item.Icon;
              return (
                <li key={item.path} className="nav-item">
                  <Link
                    href={item.path}
                    className={`nav-link px-3 py-2 d-flex align-items-center ${
                      pathname === item.path ? 'text-success fw-bold' : 'text-muted'
                    }`}
                  >
                    <Icon className="me-2" />
                    {item.name}
                  </Link>
                </li>
              );
            })}
            <li className="nav-item ms-lg-3">
              <button
                onClick={handleLogout}
                className="btn btn-outline-success"
              >
                Déconnexion
              </button>
            </li>
          </ul>
        </div>
      </div>
    </nav>
  );
}
