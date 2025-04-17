'use client';

import { motion } from 'framer-motion';
import { BsPhone, BsEnvelope, BsShieldLock, BsBoxArrowRight, BsTrash } from 'react-icons/bs';

export default function Profile() {
  const userInfo = {
    name: 'Jean Dupont',
    email: 'jean.dupont@example.com',
    phone: '+237 456 789 123',
  };

  return (
    <div className="container-fluid max-w-4xl mx-auto px-4 py-8">
      {/* Profile Header */}
      <div className="bg-white rounded-2xl p-8 shadow-sm mb-8">
        <div className="flex flex-col items-center text-center">
          <div className="w-24 h-24 bg-teal-100 rounded-full flex items-center justify-center text-2xl font-bold text-teal-600 mb-4">
            {userInfo.name.split(' ').map(n => n[0]).join('')}
          </div>
          <h1 className="text-2xl font-bold mb-2">{userInfo.name}</h1>
          <p className="text-gray-600">{userInfo.email}</p>
        </div>
      </div>

      {/* Personal Information */}
      <div className="bg-white rounded-2xl p-8 shadow-sm mb-8">
        <h2 className="text-xl font-bold mb-6">Informations personnelles</h2>
        <div className="space-y-6">
          <div className="flex items-center gap-4">
            <div className="bg-teal-50 p-3 rounded-xl">
              <BsPhone className="text-teal-600" size={24} />
            </div>
            <div>
              <p className="text-sm text-gray-500">Phone</p>
              <p className="font-medium">{userInfo.phone}</p>
            </div>
          </div>

          <div className="flex items-center gap-4">
            <div className="bg-teal-50 p-3 rounded-xl">
              <BsEnvelope className="text-teal-600" size={24} />
            </div>
            <div>
              <p className="text-sm text-gray-500">Email</p>
              <p className="font-medium">{userInfo.email}</p>
            </div>
          </div>

          <div className="flex items-center gap-4">
            <div className="bg-teal-50 p-3 rounded-xl">
              <BsShieldLock className="text-teal-600" size={24} />
            </div>
            <div className="flex-1">
              <p className="text-sm text-gray-500">Mot de passe</p>
              <p className="font-medium">••••••••</p>
            </div>
            <button className="text-teal-600 hover:text-teal-700 font-medium">
              Changer
            </button>
          </div>
        </div>
      </div>

      {/* Actions */}
      <div className="space-y-4">
        <motion.button
          whileHover={{ scale: 1.01 }}
          whileTap={{ scale: 0.99 }}
          className="w-full p-4 bg-red-50 text-red-600 rounded-xl font-medium flex items-center justify-center gap-2 hover:bg-red-100 transition-colors"
        >
          <BsBoxArrowRight size={20} />
          Déconnexion
        </motion.button>

        <motion.button
          whileHover={{ scale: 1.01 }}
          whileTap={{ scale: 0.99 }}
          className="w-full p-4 border border-red-200 text-red-600 rounded-xl font-medium flex items-center justify-center gap-2 hover:bg-red-50 transition-colors"
        >
          <BsTrash size={20} />
          Supprimer le compte
        </motion.button>
      </div>
    </div>
  );
}
