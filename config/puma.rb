
# Número de hilos por worker (JRuby usa threads reales)
min_threads = ENV.fetch("RAILS_MIN_THREADS") { 5 }.to_i
max_threads = ENV.fetch("RAILS_MAX_THREADS") { 16 }.to_i
threads min_threads, max_threads

# Puma escucha en el puerto especificado
port ENV.fetch("PORT") { 3000 }

# Entorno Rails
environment ENV.fetch("RAILS_ENV") { "development" }

# Como JRuby no soporta fork, mantenemos 1 worker
# Puedes simular "workers" usando múltiples JVMs (p. ej. con Docker)
workers 0

# No uses preload_app! en JRuby: no aporta beneficios (no hay Copy-on-Write)
# preload_app!

# Configuración del pool de conexiones de ActiveRecord (si usas JDBC)
before_fork do
  ActiveRecord::Base.connection_pool.disconnect! if defined?(ActiveRecord)
end

on_worker_boot do
  ActiveRecord::Base.establish_connection if defined?(ActiveRecord)
end

# Usa thread pool dinámico
worker_timeout 60 if ENV.fetch("RAILS_ENV", "development") == "development"

# Optimización JRuby (recomendado para entornos de producción)
# Puedes definir estas opciones en JAVA_OPTS o .env
# Ejemplo:
# export JAVA_OPTS="-J-Xms512m -J-Xmx1024m -J-XX:+UseG1GC"
# export JRUBY_OPTS="--server --debug"

# Logging
stdout_redirect "log/puma.stdout.log", "log/puma.stderr.log", true

# Permitir reinicio con `rails restart`
plugin :tmp_restart
