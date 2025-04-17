'use client';

import { motion } from 'framer-motion';
import { BsCamera } from 'react-icons/bs';
import { FiUpload } from 'react-icons/fi';
import Image from 'next/image';

export default function Home() {
  return (
    <div className="container-fluid px-0">
      {/* Hero Section */}
      <div className="hero-gradient py-5 mb-5">
        <div className="container py-5">
          <div className="row align-items-center">
            <div className="col-lg-6">
              <motion.div
                initial={{ opacity: 0, x: -20 }}
                animate={{ opacity: 1, x: 0 }}
                transition={{ duration: 0.5 }}
              >
                <h1 className="display-4 fw-bold mb-3">
                  <span className="text-gradient">Tri Automatique</span>
                  <br />
                  des Prunes
                </h1>
                <p className="lead mb-4 text-gray-600">
                  Utilisez l&apos;intelligence artificielle pour analyser et classifier vos prunes
                  en quelques secondes. Simple, rapide et précis.
                </p>
                <div className="d-flex gap-3">
                  <button className="btn btn-primary btn-lg shadow-sm">
                    Commencer l&apos;analyse
                  </button>
                  <button className="btn btn-outline-primary btn-lg">
                    En savoir plus
                  </button>
                </div>
              </motion.div>
            </div>
            <div className="col-lg-6">
              <motion.div
                initial={{ opacity: 0, x: 20 }}
                animate={{ opacity: 1, x: 0 }}
                transition={{ duration: 0.5, delay: 0.2 }}
                className="text-center"
              >
                <Image
                  src="/image/icon.png"
                  alt="Analyse de prunes"
                  width={400}
                  height={400}
                  className="img-fluid rounded-4 shadow-lg"
                  style={{ maxHeight: '400px', objectFit: 'cover' }}
                />
              </motion.div>
            </div>
          </div>
        </div>
      </div>

      {/* Upload Section */}
      <div className="container mb-5">
        <h2 className="text-center h1 mb-5">
          Comment ça marche ?
        </h2>
        <div className="row g-4 justify-content-center">
          <div className="col-md-6">
            <motion.div
              whileHover={{ scale: 1.02 }}
              className="card h-100 border-0 shadow-sm"
            >
              <div className="card-body text-center p-5">
                <div className="display-1 text-primary mb-3">
                  <BsCamera />
                </div>
                <h3 className="card-title h4 mb-3">Prendre une photo</h3>
                <p className="card-text text-muted mb-4">
                  Utilisez votre caméra pour prendre une photo en temps réel
                  de vos prunes à analyser.
                </p>
                <button className="btn btn-primary">
                  Ouvrir la caméra
                </button>
              </div>
            </motion.div>
          </div>

          <div className="col-md-6">
            <motion.div
              whileHover={{ scale: 1.02 }}
              className="card h-100 border-0 shadow-sm"
            >
              <div className="card-body text-center p-5">
                <div className="display-1 text-primary mb-3">
                  <FiUpload />
                </div>
                <h3 className="card-title h4 mb-3">Importer une image</h3>
                <p className="card-text text-muted mb-4">
                  Sélectionnez une image depuis votre galerie
                  pour une analyse instantanée.
                </p>
                <button className="btn btn-primary">
                  Parcourir les fichiers
                </button>
              </div>
            </motion.div>
          </div>
        </div>
      </div>
    </div>
  );
}
