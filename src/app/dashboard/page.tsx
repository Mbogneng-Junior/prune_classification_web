'use client';

import { motion } from 'framer-motion';
import { BsCamera } from 'react-icons/bs';
import { FiUpload } from 'react-icons/fi';

export default function Dashboard() {
  return (
    <div className="container-fluid px-4 py-5">
      {/* Welcome Section */}
      <div className="row mb-5">
        <div className="col-12">
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            className="card card-gradient p-4"
          >
            <h1 className="h3 text-white mb-2">Bienvenue sur votre tableau de bord</h1>
            <p className="text-white-50 mb-0">
              Commencez à analyser vos prunes en quelques clics
            </p>
          </motion.div>
        </div>
      </div>

      {/* Upload Section */}
      <div className="row g-4 mb-5">
        <div className="col-12">
          <h2 className="h4 mb-4">Analyser des prunes</h2>
        </div>
        <div className="col-md-6">
          <motion.div
            whileHover={{ scale: 1.02 }}
            className="card h-100"
          >
            <div className="card-body p-4">
              <div className="text-teal-600 display-5 mb-3">
                <BsCamera />
              </div>
              <h3 className="h5 mb-3">Prendre une photo</h3>
              <p className="text-muted mb-4">
                Utilisez votre caméra pour prendre une photo en temps réel
                de vos prunes à analyser.
              </p>
              <button className="btn btn-teal">
                Ouvrir la caméra
              </button>
            </div>
          </motion.div>
        </div>

        <div className="col-md-6">
          <motion.div
            whileHover={{ scale: 1.02 }}
            className="card h-100"
          >
            <div className="card-body p-4">
              <div className="text-teal-600 display-5 mb-3">
                <FiUpload />
              </div>
              <h3 className="h5 mb-3">Importer une image</h3>
              <p className="text-muted mb-4">
                Sélectionnez une image depuis votre galerie
                pour une analyse instantanée.
              </p>
              <button className="btn btn-teal">
                Parcourir les fichiers
              </button>
            </div>
          </motion.div>
        </div>
      </div>

      {/* Recent Activity */}
      <div className="row">
        <div className="col-12">
          <h2 className="h4 mb-4">Activité récente</h2>
        </div>
        <div className="col-12">
          <div className="card">
            <div className="card-body">
              <div className="text-center text-muted py-5">
                <p className="mb-0">Aucune activité récente</p>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
