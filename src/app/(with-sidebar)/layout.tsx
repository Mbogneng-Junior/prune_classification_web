'use client';

import React from 'react';
import Navigation from '@/components/Navigation';
import Sidebar from '@/components/Sidebar';
import MobileNav from '@/components/MobileNav';

export default function WithSidebarLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <>
      <Sidebar />
      <Navigation />
      <MobileNav />
      <main className="has-sidebar flex-shrink-0">
        {children}
      </main>
      <footer className="footer mt-auto py-3 bg-light">
        <div className="container text-center">
          <span className="text-muted">© 2025 Tri Automatique des Prunes - JCIA Hackathon</span>
        </div>
      </footer>
    </>
  );
}
