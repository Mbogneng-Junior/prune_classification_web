import React from 'react';
import './globals.css';
import { Inter } from 'next/font/google';
import { Providers } from './providers';

const inter = Inter({ subsets: ['latin'] });

export const metadata = {
  title: 'Tri Automatique des Prunes',
  description: 'Application web pour le tri automatique des prunes - JCIA Hackathon 2025',
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="fr" className="h-100">
      <body className={`${inter.className} d-flex flex-column h-100`}>
        <Providers>
          {children}
        </Providers>
      </body>
    </html>
  );
}
