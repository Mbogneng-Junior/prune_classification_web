import { NextResponse } from 'next/server';
import type { NextRequest } from 'next/server';

export function middleware(request: NextRequest) {
  const path = request.nextUrl.pathname;

  // Check if the user has completed onboarding
  const hasSeenOnboarding = request.cookies.get('hasSeenOnboarding')?.value;
  const isAuthenticated = request.cookies.get('isAuthenticated')?.value;

  // Public routes that don't need authentication
  const isPublicRoute = path === '/onboarding' || path.startsWith('/auth/');

  // If user hasn't seen onboarding and isn't on onboarding page
  if (!hasSeenOnboarding && path !== '/onboarding' && !path.startsWith('/auth/')) {
    return NextResponse.redirect(new URL('/onboarding', request.url));
  }

  // If user is not authenticated and trying to access protected routes
  if (!isAuthenticated && !isPublicRoute) {
    return NextResponse.redirect(new URL('/auth/login', request.url));
  }

  // If user is authenticated and trying to access auth pages
  if (isAuthenticated && isPublicRoute) {
    return NextResponse.redirect(new URL('/dashboard', request.url));
  }

  return NextResponse.next();
}

export const config = {
  matcher: [
    '/((?!api|_next/static|_next/image|favicon.ico).*)',
  ],
};
