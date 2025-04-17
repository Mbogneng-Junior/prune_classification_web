'use client';

import { motion } from 'framer-motion';
import { BsCamera, BsImage, BsCheckCircle, BsClock, BsExclamationTriangle } from 'react-icons/bs';
import Image from 'next/image';

const categories = [
  { name: 'Good Quality', icon: BsCheckCircle, color: 'text-green-500', bg: 'bg-green-50' },
  { name: 'Unripe', icon: BsClock, color: 'text-yellow-500', bg: 'bg-yellow-50' },
  { name: 'Spotted', icon: BsExclamationTriangle, color: 'text-blue-500', bg: 'bg-blue-50' },
  { name: 'Cracked', icon: BsExclamationTriangle, color: 'text-orange-500', bg: 'bg-orange-50' },
  { name: 'Bruised', icon: BsExclamationTriangle, color: 'text-purple-500', bg: 'bg-purple-50' },
  { name: 'Rotten', icon: BsExclamationTriangle, color: 'text-red-500', bg: 'bg-red-50' },
];

export default function Dashboard() {
  return (
    <div className="container-fluid max-w-7xl mx-auto px-4 py-8">
      {/* Welcome Section */}
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        className="bg-gradient-to-r from-teal-600 to-teal-700 rounded-3xl p-8 mb-8 text-white relative overflow-hidden"
      >
        <div className="absolute right-0 top-0 opacity-10">
          <Image
            src="/image/icon.png"
            alt="Background"
            width={200}
            height={200}
            className="transform rotate-12"
          />
        </div>
        <h1 className="text-3xl font-bold mb-3">Bienvenue !</h1>
        <p className="text-teal-100 text-lg mb-6">
          Analysez vos prunes en toute simplicité
        </p>
        <div className="flex flex-wrap gap-4">
          <motion.button
            whileHover={{ scale: 1.02 }}
            whileTap={{ scale: 0.98 }}
            className="bg-white text-teal-600 px-6 py-3 rounded-xl font-medium flex items-center gap-2 shadow-lg"
          >
            <BsCamera size={20} />
            Prendre une photo
          </motion.button>
          <motion.button
            whileHover={{ scale: 1.02 }}
            whileTap={{ scale: 0.98 }}
            className="bg-teal-500 text-white px-6 py-3 rounded-xl font-medium flex items-center gap-2 shadow-lg"
          >
            <BsImage size={20} />
            Importer une image
          </motion.button>
        </div>
      </motion.div>

      {/* Categories Grid */}
      <div className="mb-8">
        <h2 className="text-2xl font-bold mb-6">Catégories de prunes</h2>
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
          {categories.map((category, index) => (
            <motion.div
              key={category.name}
              initial={{ opacity: 0, y: 20 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ delay: index * 0.1 }}
              className="bg-white rounded-2xl p-6 shadow-sm hover:shadow-md transition-shadow"
            >
              <div className={`${category.bg} w-12 h-12 rounded-xl flex items-center justify-center mb-4`}>
                <category.icon size={24} className={category.color} />
              </div>
              <h3 className="text-lg font-semibold mb-2">{category.name}</h3>
              <p className="text-gray-600">
                Description détaillée de la catégorie {category.name.toLowerCase()}
              </p>
            </motion.div>
          ))}
        </div>
      </div>

      {/* Recent Activity */}
      <div>
        <h2 className="text-2xl font-bold mb-6">Activité récente</h2>
        <div className="bg-white rounded-2xl p-6 shadow-sm">
          <div className="text-center text-gray-500 py-8">
            <BsClock size={48} className="mx-auto mb-4 text-gray-400" />
            <p className="text-lg">Aucune activité récente</p>
            <p className="text-sm text-gray-400">
              Vos analyses apparaîtront ici
            </p>
          </div>
        </div>
      </div>
    </div>
  );
}
