const defaultTheme = require('tailwindcss/defaultTheme')

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
        sans: ['Inter var', ...defaultTheme.fontFamily.sans],
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
