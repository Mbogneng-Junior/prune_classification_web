'use client';

import { useEffect } from 'react';
import bootstrap from 'bootstrap/dist/js/bootstrap.bundle.min.js';

export function Providers({ children }: { children: React.ReactNode }) {
  useEffect(() => {
    // Initialize all Bootstrap components
    Object.values(bootstrap).forEach((component) => {
      if (typeof component === 'function') {
        component();
      }
    });
  }, []);

  return <>{children}</>;
}
