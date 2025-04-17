'use client';

import { useState } from 'react';
import { motion, AnimatePresence } from 'framer-motion';
import { useRouter } from 'next/navigation';
import { BsCamera, BsStars, BsArrowRight } from 'react-icons/bs';

const slides = [
  {
    icon: <BsStars size={40} className="text-teal-600" />,
    title: "Bienvenue dans Tri Automatique des Prunes",
    description: "Découvrez si vos prunes sont de bonne qualité grâce à l'intelligence artificielle.",
    buttonText: "Suivant"
  },
  {
    icon: <BsCamera size={40} className="text-teal-600" />,
    title: "Prenez une photo",
    description: "Prenez simplement une photo ou importez-la depuis votre galerie.",
    buttonText: "Suivant"
  },
  {
    icon: (
      <svg width="40" height="40" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" className="text-teal-600">
        <path d="M20 7L10 17L5 12" />
      </svg>
    ),
    title: "Obtenez des résultats instantanés",
    description: "Notre modèle IA classifie votre prune et vous fournit des conseils adaptés.",
    buttonText: "Continuer"
  }
];

export default function Onboarding() {
  const [currentSlide, setCurrentSlide] = useState(0);
  const router = useRouter();

  const handleNext = () => {
    if (currentSlide === slides.length - 1) {
      router.push('/auth/login');
    } else {
      setCurrentSlide(prev => prev + 1);
    }
  };

  const handleSkip = () => {
    router.push('/auth/login');
  };

  return (
    <div className="min-h-screen bg-gradient-to-b from-teal-50 to-white flex flex-col">
      <div className="flex-1 flex flex-col items-center justify-center p-6">
        <div className="w-full max-w-md">
          <AnimatePresence mode="wait">
            <motion.div
              key={currentSlide}
              initial={{ opacity: 0, y: 20 }}
              animate={{ opacity: 1, y: 0 }}
              exit={{ opacity: 0, y: -20 }}
              transition={{ duration: 0.3 }}
              className="text-center"
            >
              <div className="bg-white rounded-full w-24 h-24 mx-auto mb-8 flex items-center justify-center shadow-lg">
                {slides[currentSlide].icon}
              </div>

              <h1 className="text-2xl font-bold mb-4 text-gray-800">
                {slides[currentSlide].title}
              </h1>
              
              <p className="text-gray-600 mb-8">
                {slides[currentSlide].description}
              </p>

              <div className="flex justify-center gap-2 mb-8">
                {slides.map((_, index) => (
                  <div
                    key={index}
                    className={`h-2 rounded-full transition-all duration-300 ${
                      index === currentSlide 
                        ? 'w-8 bg-teal-600' 
                        : 'w-2 bg-gray-300'
                    }`}
                  />
                ))}
              </div>
            </motion.div>
          </AnimatePresence>

          <div className="flex flex-col gap-4">
            <button
              onClick={handleNext}
              className="bg-teal-600 text-white py-4 px-6 rounded-xl font-medium hover:bg-teal-700 transition-colors flex items-center justify-center gap-2"
            >
              {slides[currentSlide].buttonText}
              <BsArrowRight />
            </button>
            
            {currentSlide < slides.length - 1 && (
              <button
                onClick={handleSkip}
                className="text-gray-500 py-2 hover:text-gray-700 transition-colors"
              >
                Passer
              </button>
            )}
          </div>
        </div>
      </div>
    </div>
  );
}
