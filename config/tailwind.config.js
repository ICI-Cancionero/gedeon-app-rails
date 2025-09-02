module.exports = {
  content: [
    './public/*.html',
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js',
    './app/views/**/*.{erb,haml,html,slim}'
  ],
  theme: {
    extend: {
      fontFamily: {
        sans: ['Nunito', 'ui-sans-serif', 'system-ui', '-apple-system', 'Segoe UI', 'Roboto', 'Ubuntu', 'Cantarell', 'Noto Sans', 'Helvetica Neue', 'Arial', 'sans-serif']
      },
      screens: {
        print: {
          raw: 'print'
        }
      },
    },
  },
  daisyui: {
    themes: [
      {
        mytheme: {
          "primary": "#ed74b8",
          "secondary": "#dd4e44",
          "accent": "#00137f",
          "neutral": "#1f1424",
          "base-100": "#f9fafb",
          "info": "#6b8beb",
          "success": "#25b17b",
          "warning": "#edbc4a",
          "error": "#f35e59",
        },
      },
    ],
  },
  plugins: [
    require('@tailwindcss/forms'),
    require('@tailwindcss/aspect-ratio'),
    require('@tailwindcss/typography'),
    require('@tailwindcss/container-queries'),
    require('daisyui')
  ]
}
