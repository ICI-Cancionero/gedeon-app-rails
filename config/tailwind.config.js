module.exports = {
  darkMode: 'class',
  content: [
    './app/views/**/*.erb',
    './app/views/**/*.html.erb',
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js',
    './app/javascript/**/*.ts'
  ],
  safelist: [
    'bg-base-100',
    'bg-base-200', 
    'bg-base-300',
    'border',
    'border-base-300',
    'collapse',
    'collapse-arrow',
    'collapse-title',
    'collapse-content',
    'group',
    'prose',
    'max-w-none',
    'rounded-xl',
    'transition',
    'duration-200',
    'hover:border-primary/60',
    'hover:shadow-sm',
    'font-semibold',
    'text-primary',
    'hover:text-primary-focus',
    'flex',
    'items-center',
    'justify-between',
    'badge',
    'badge-ghost',
    'group-open:hidden',
    'pt-0',
    'mt-2',
    'sticky',
    'top-0',
    'left-0',
    'right-0',
    'z-40',
    'backdrop-blur',
    'border-b',
    'card',
    'shadow-sm',
    'alert',
    'shadow',
    'rounded-t-xl'
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
    themes: ['light', 'dark'],
    darkTheme: 'dark'
  },
  plugins: [
    require('@tailwindcss/forms'),
    require('@tailwindcss/aspect-ratio'),
    require('@tailwindcss/typography'),
    require('@tailwindcss/container-queries'),
    require('daisyui')
  ]
}
