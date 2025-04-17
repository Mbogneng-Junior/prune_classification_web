'use client';

import { motion } from 'framer-motion';
import { BsCheckCircle, BsClock, BsExclamationTriangle, BsCalendar, BsSearch } from 'react-icons/bs';
import { useState } from 'react';

const mockAnalyses = [
  {
    id: 1,
    date: '17 Avril 2025',
    time: '14:30',
    result: 'Bonne qualité',
    status: 'success',
    icon: BsCheckCircle,
    color: 'text-green-500',
    bg: 'bg-green-50'
  },
  {
    id: 2,
    date: '16 Avril 2025',
    time: '11:15',
    result: 'Non mûre',
    status: 'warning',
    icon: BsClock,
    color: 'text-yellow-500',
    bg: 'bg-yellow-50'
  },
  {
    id: 3,
    date: '15 Avril 2025',
    time: '09:45',
    result: 'Mauvaise qualité',
    status: 'danger',
    icon: BsExclamationTriangle,
    color: 'text-red-500',
    bg: 'bg-red-50'
  }
];

export default function History() {
  const [searchTerm, setSearchTerm] = useState('');

  return (
    <div className="container-fluid max-w-7xl mx-auto px-4 py-8">
      {/* Header */}
      <div className="flex flex-col md:flex-row md:items-center md:justify-between gap-4 mb-8">
        <div>
          <h1 className="text-3xl font-bold mb-2">Historique</h1>
          <p className="text-gray-600">Consultez vos analyses précédentes</p>
        </div>
        
        {/* Search Bar */}
        <div className="relative max-w-md w-full">
          <input
            type="text"
            placeholder="Rechercher dans l'historique..."
            value={searchTerm}
            onChange={(e) => setSearchTerm(e.target.value)}
            className="w-full pl-12 pr-4 py-3 rounded-xl border border-gray-200 focus:border-teal-500 focus:ring-2 focus:ring-teal-200 transition-all"
          />
          <BsSearch className="absolute left-4 top-1/2 transform -translate-y-1/2 text-gray-400" size={20} />
        </div>
      </div>

      {/* Analysis Cards */}
      <div className="grid gap-4">
        {mockAnalyses.map((analysis, index) => (
          <motion.div
            key={analysis.id}
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ delay: index * 0.1 }}
            className="bg-white rounded-2xl shadow-sm hover:shadow-md transition-shadow"
          >
            <div className="p-6">
              <div className="flex items-start justify-between">
                <div className="flex items-center gap-4">
                  <div className={`${analysis.bg} p-3 rounded-xl`}>
                    <analysis.icon size={24} className={analysis.color} />
                  </div>
                  <div>
                    <h3 className="text-lg font-semibold mb-1">{analysis.result}</h3>
                    <div className="flex items-center gap-2 text-sm text-gray-500">
                      <BsCalendar size={14} />
                      <span>{analysis.date}</span>
                      <span>•</span>
                      <span>{analysis.time}</span>
                    </div>
                  </div>
                </div>
                <div className="flex gap-2">
                  <motion.button
                    whileHover={{ scale: 1.02 }}
                    whileTap={{ scale: 0.98 }}
                    className="px-4 py-2 text-sm font-medium text-teal-600 bg-teal-50 rounded-lg hover:bg-teal-100 transition-colors"
                  >
                    Voir détails
                  </motion.button>
                  <motion.button
                    whileHover={{ scale: 1.02 }}
                    whileTap={{ scale: 0.98 }}
                    className="px-4 py-2 text-sm font-medium text-red-600 bg-red-50 rounded-lg hover:bg-red-100 transition-colors"
                  >
                    Supprimer
                  </motion.button>
                </div>
              </div>
            </div>
          </motion.div>
        ))}

        {mockAnalyses.length === 0 && (
          <div className="bg-white rounded-2xl p-8 text-center">
            <BsClock size={48} className="mx-auto mb-4 text-gray-400" />
            <h3 className="text-lg font-medium text-gray-900 mb-2">Aucun historique</h3>
            <p className="text-gray-500">
              Vos analyses apparaîtront ici une fois que vous aurez analysé des prunes
            </p>
          </div>
        )}
      </div>

      {/* Pagination */}
      <div className="mt-8 flex justify-center">
        <nav className="flex gap-2">
          <button className="px-4 py-2 rounded-lg border border-gray-200 text-gray-600 hover:bg-gray-50 transition-colors">
            Précédent
          </button>
          <button className="px-4 py-2 rounded-lg bg-teal-600 text-white hover:bg-teal-700 transition-colors">
            1
          </button>
          <button className="px-4 py-2 rounded-lg border border-gray-200 text-gray-600 hover:bg-gray-50 transition-colors">
            Suivant
          </button>
        </nav>
      </div>
    </div>
  );
}
