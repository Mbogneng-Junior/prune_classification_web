export default function Settings() {
  return (
    <div className="min-h-screen bg-gray-50 p-4 sm:p-6 lg:p-8">
      <div className="max-w-3xl mx-auto">
        <h1 className="text-2xl font-bold mb-6">Settings</h1>

        <div className="bg-white shadow rounded-lg divide-y divide-gray-200">
          {/* Appearance */}
          <div className="p-6">
            <h2 className="text-lg font-medium text-gray-900 mb-4">Apparence</h2>
            <div className="flex items-center justify-between">
              <div className="flex items-center space-x-3">
                <div className="w-8 h-8 bg-gray-100 rounded-full flex items-center justify-center">
                  <svg className="w-5 h-5 text-gray-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M20.354 15.354A9 9 0 018.646 3.646 9.003 9.003 0 0012 21a9.003 9.003 0 008.354-5.646z" />
                  </svg>
                </div>
                <div>
                  <span className="block text-sm font-medium text-gray-900">Dark Mode</span>
                </div>
              </div>
              <button
                type="button"
                className="relative inline-flex h-6 w-11 flex-shrink-0 cursor-pointer rounded-full border-2 border-transparent transition-colors duration-200 ease-in-out focus:outline-none focus:ring-2 focus:ring-teal-500 focus:ring-offset-2 bg-gray-200"
                role="switch"
                aria-checked="false"
              >
                <span className="translate-x-0 pointer-events-none relative inline-block h-5 w-5 transform rounded-full bg-white shadow ring-0 transition duration-200 ease-in-out">
                  <span className="opacity-0 duration-100 ease-in absolute inset-0 flex h-full w-full items-center justify-center transition-opacity" aria-hidden="true">
                    <svg className="h-3 w-3 text-gray-400" fill="none" viewBox="0 0 12 12">
                      <path d="M4 8l2-2m0 0l2-2M6 6L4 4m2 2l2 2" stroke="currentColor" strokeWidth={2} strokeLinecap="round" strokeLinejoin="round" />
                    </svg>
                  </span>
                </span>
              </button>
            </div>
          </div>

          {/* Language */}
          <div className="p-6">
            <h2 className="text-lg font-medium text-gray-900 mb-4">Language</h2>
            <div className="flex items-center justify-between">
              <div className="flex items-center space-x-3">
                <div className="w-8 h-8 bg-gray-100 rounded-full flex items-center justify-center">
                  <svg className="w-5 h-5 text-gray-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M3 5h12M9 3v2m1.048 9.5A18.022 18.022 0 016.412 9m6.088 9h7M11 21l5-10 5 10M12.751 5C11.783 10.77 8.07 15.61 3 18.129" />
                  </svg>
                </div>
                <div>
                  <span className="block text-sm font-medium text-gray-900">English</span>
                </div>
              </div>
              <svg className="w-5 h-5 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 5l7 7-7 7" />
              </svg>
            </div>
          </div>

          {/* About */}
          <div className="p-6">
            <h2 className="text-lg font-medium text-gray-900 mb-4">À propos</h2>
            <div className="space-y-4">
              <div>
                <span className="block text-sm font-medium text-gray-500">Version</span>
                <span className="block text-sm text-gray-900">1.0.0</span>
              </div>
              <div>
                <span className="block text-sm font-medium text-gray-500">JCIA Hackathon 2025</span>
                <span className="block text-sm text-gray-900">Développé pour le JCIA Hackathon 2025</span>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
