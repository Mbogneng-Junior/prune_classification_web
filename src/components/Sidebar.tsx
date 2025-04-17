'use client';

import { useState } from 'react';
import Link from 'next/link';
import Image from 'next/image';
import { usePathname } from 'next/navigation';
import { motion } from 'framer-motion';
import { BsHouseDoor, BsClock, BsPerson, BsGear } from 'react-icons/bs';
import { FiMenu } from 'react-icons/fi';

const menuItems = [
  { path: '/', icon: BsHouseDoor, label: 'Accueil' },
  { path: '/history', icon: BsClock, label: 'Historique' },
  { path: '/profile', icon: BsPerson, label: 'Profil' },
  { path: '/settings', icon: BsGear, label: 'Paramètres' }
];

export default function Sidebar() {
  const [isCollapsed, setIsCollapsed] = useState(false);
  const pathname = usePathname();

  return (
    <>
      {/* Desktop Sidebar */}
      <motion.div
        initial={{ x: -250 }}
        animate={{ x: 0 }}
        className="hidden lg:flex flex-col fixed left-0 top-0 h-screen bg-white shadow-lg z-30"
        style={{ width: isCollapsed ? '80px' : '250px' }}
      >
        {/* Logo Section */}
        <div className={`flex items-center p-5 ${isCollapsed ? 'justify-center' : 'justify-between'}`}>
          {!isCollapsed && (
            <Link href="/" className="flex items-center gap-3">
              <Image
                src="/image/icon.png"
                alt="Logo"
                width={40}
                height={40}
                className="rounded-lg"
              />
              <span className="font-semibold text-xl">Prunes AI</span>
            </Link>
          )}
          <button
            onClick={() => setIsCollapsed(!isCollapsed)}
            className="p-2 rounded-lg hover:bg-gray-100 transition-colors"
          >
            <FiMenu size={24} className="text-gray-600" />
          </button>
        </div>

        {/* Navigation Links */}
        <div className="flex-1 py-8">
          <div className="space-y-2 px-3">
            {menuItems.map((item) => {
              const isActive = pathname === item.path;
              return (
                <Link
                  key={ item.path}
                  href={item.path}
                  className={`flex items-center gap-3 p-3 rounded-xl transition-all relative group ${
                    isActive
                      ? 'text-teal-600 bg-teal-50'
                      : 'text-gray-600 hover:bg-gray-50'
                  }`}
                >
                  <item.icon size={22} />
                  {!isCollapsed && (
                    <span className="font-medium">{item.label}</span>
                  )}
                  {isActive && (
                    <motion.div
                      layoutId="activeTab"
                      className="absolute inset-0 border-2 border-teal-600 rounded-xl"
                      transition={{ type: "spring", bounce: 0.2, duration: 0.6 }}
                    />
                  )}
                </Link>
              );
            })}
          </div>
        </div>

        {/* Footer */}
        {!isCollapsed && (
          <div className="p-5 border-t">
            <div className="flex items-center gap-3 text-sm text-gray-600">
              <Image
                src="/image/icon.png"
                alt="Logo"
                width={32}
                height={32}
                className="rounded-full"
              />
              <div className="flex-1">
                <p className="font-medium">JCIA Hackathon</p>
                <p className="text-xs">v1.0.0</p>
              </div>
            </div>
          </div>
        )}
      </motion.div>

      

      {/* Content Margin */}
      <div className="hidden lg:block" style={{ width: isCollapsed ? '80px' : '250px' }} />
    </>
  );
}


{/* Mobile Navigation 
<div className="lg:hidden fixed bottom-0 left-0 right-0 bg-white border-t z-30">
<div className="flex justify-around items-center p-3">
  {menuItems.map((item) => {
    const isActive = pathname === item.path;
    return (
      <Link
        key={item.path}
        href={item.path}
        className={`flex flex-col items-center gap-1 p-2 ${
          isActive ? 'text-teal-600' : 'text-gray-600'
        }`}
      >
        <item.icon size={24} />
        <span className="text-xs font-medium">{item.label}</span>
        {isActive && (
          <motion.div
            layoutId="activeTabMobile"
            className="absolute bottom-0 h-0.5 w-12 bg-teal-600"
            transition={{ type: "spring", bounce: 0.2, duration: 0.6 }}
          />
        )}
      </Link>
    );
  })}
</div>
</div>*/}
