// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import './controllers';

// Register PWA Service Worker scoped to /app/
if ('serviceWorker' in navigator) {
  window.addEventListener('load', () => {
    navigator.serviceWorker
      .register('/app/sw.js', { scope: '/app/' })
      .catch((err) => console.warn('SW registration failed', err));
  });
}