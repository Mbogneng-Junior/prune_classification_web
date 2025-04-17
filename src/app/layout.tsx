import React from 'react';
import './globals.css';
import { Inter } from 'next/font/google';
import Navigation from '@/components/Navigation';
import Sidebar from '@/components/Sidebar';
import MobileNav from '@/components/MobileNav';
import { Providers } from './providers';
import { headers } from 'next/headers';

const inter = Inter({ subsets: ['latin'] });

export const metadata = {
  title: 'Tri Automatique des Prunes',
  description: 'Application web pour le tri automatique des prunes - JCIA Hackathon 2025',
};

export default async function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  // Check if we're on a public page (onboarding, login, register)
  const headersList = await headers();
  const pathname = headersList.get("x-pathname") || "";
  const isPublicPage = pathname.includes("/auth/") || pathname.includes("/onboarding");

  return (
    <html lang="fr" className="h-100">
      <body className={`${inter.className} d-flex flex-column h-100`}>
        <Providers>
          {!isPublicPage && (
            <>
              <Sidebar />
              <Navigation />
              <MobileNav />
            </>
          )}
          <main className={`flex-shrink-0 ${!isPublicPage ? 'has-sidebar' : ''}`}>
            {children}
          </main>
          {!isPublicPage && (
            <footer className="footer mt-auto py-3 bg-light">
              <div className="container text-center">
                <span className="text-muted"> 2025 Tri Automatique des Prunes - JCIA Hackathon</span>
              </div>
            </footer>
          )}
        </Providers>
      </body>
    </html>
  );
}
