'use client';

import { useEffect } from 'react';
import 'bootstrap/dist/js/bootstrap.bundle.min.js';
import 'bootstrap/dist/css/bootstrap.min.css';

export function Providers({ children }: { children: React.ReactNode }) {
  useEffect(() => {
    // Bootstrap is automatically initialized when imported
    // No need for manual initialization
  }, []);

  return <>{children}</>;
}
