export default function History() {
  return (
    <div className="min-h-screen bg-gray-50 p-4 sm:p-6 lg:p-8">
      <div className="max-w-7xl mx-auto">
        <h1 className="text-2xl font-bold mb-6">History</h1>
        
        <div className="bg-white rounded-lg shadow">
          {/* Empty state */}
          <div className="flex flex-col items-center justify-center p-12">
            <div className="w-16 h-16 bg-gray-100 rounded-full flex items-center justify-center mb-4">
              <svg className="w-8 h-8 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z" />
              </svg>
            </div>
            <h3 className="text-lg font-medium text-gray-900 mb-1">No history available</h3>
            <p className="text-gray-500">Analysez des prunes pour les voir apparaitre ici</p>
          </div>
        </div>
      </div>
    </div>
  );
}
