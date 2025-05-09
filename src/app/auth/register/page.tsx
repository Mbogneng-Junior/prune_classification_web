'use client';

import { useState } from 'react';
import Link from 'next/link';
import { motion } from 'framer-motion';

export default function Register() {
  const [isLoading, setIsLoading] = useState(false);
  const [formData, setFormData] = useState({
    name: '',
    email: '',
    password: '',
    confirmPassword: ''
  });

  const handleChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    setFormData({
      ...formData,
      [e.target.name]: e.target.value
    });
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setIsLoading(true);
    
    try {
      // Définir les cookies pour l'authentification et l'onboarding
      document.cookie = 'isAuthenticated=true; path=/';
      document.cookie = 'hasSeenOnboarding=true; path=/';
      
      // Rediriger vers le dashboard
      window.location.href = '/dashboard';
    } catch (error) {
      console.error('Registration error:', error);
    } finally {
      setIsLoading(false);
    }
  };

  return (
    <div className="min-h-screen bg-gradient-to-b from-teal-50 to-white flex flex-col">
      <div className="container">
        <div className="row min-vh-100 align-items-center justify-content-center py-5">
          <div className="col-12 col-md-8 col-lg-6 col-xl-5">
            <motion.div
              initial={{ opacity: 0, y: 20 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ duration: 0.5 }}
              className="bg-white p-4 p-md-5 rounded-4 shadow-lg"
            >
              <div className="text-center mb-4">
                <div className="bg-teal-600 rounded-xl p-3 d-inline-block mb-4">
                  <svg className="text-white" width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                    <path d="M20 7L10 17L5 12" />
                  </svg>
                </div>
                <h1 className="h3 mb-3">Créer un compte</h1>
                <p className="text-muted">Rejoignez-nous pour commencer à analyser vos prunes</p>
              </div>

              <form onSubmit={handleSubmit} className="needs-validation">
                <div className="form-floating mb-3">
                  <input
                    type="text"
                    className="form-control"
                    id="name"
                    name="name"
                    placeholder="Votre nom"
                    value={formData.name}
                    onChange={handleChange}
                    required
                  />
                  <label htmlFor="name">Nom complet</label>
                </div>

                <div className="form-floating mb-3">
                  <input
                    type="email"
                    className="form-control"
                    id="email"
                    name="email"
                    placeholder="name@example.com"
                    value={formData.email}
                    onChange={handleChange}
                    required
                  />
                  <label htmlFor="email">Adresse email</label>
                </div>

                <div className="form-floating mb-3">
                  <input
                    type="password"
                    className="form-control"
                    id="password"
                    name="password"
                    placeholder="Mot de passe"
                    value={formData.password}
                    onChange={handleChange}
                    required
                  />
                  <label htmlFor="password">Mot de passe</label>
                </div>

                <div className="form-floating mb-4">
                  <input
                    type="password"
                    className="form-control"
                    id="confirmPassword"
                    name="confirmPassword"
                    placeholder="Confirmer le mot de passe"
                    value={formData.confirmPassword}
                    onChange={handleChange}
                    required
                  />
                  <label htmlFor="confirmPassword">Confirmer le mot de passe</label>
                </div>

                <button
                  type="submit"
                  className="btn btn-teal w-100 py-3 mb-4"
                  disabled={isLoading}
                >
                  {isLoading ? (
                    <>
                      <span className="spinner-border spinner-border-sm me-2" role="status" aria-hidden="true"></span>
                      Création du compte...
                    </>
                  ) : (
                    'Créer mon compte'
                  )}
                </button>

                <div className="text-center">
                  <p className="text-muted">
                    Déjà un compte ?{' '}
                    <Link href="/auth/login" className="text-teal-600 text-decoration-none">
                      Se connecter
                    </Link>
                  </p>
                </div>
              </form>
            </motion.div>
          </div>
        </div>
      </div>
    </div>
  );
}
