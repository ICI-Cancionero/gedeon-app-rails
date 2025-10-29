web: jruby -J-Xms256m -J-Xmx384m -J-XX:+UseSerialGC -J-XX:MaxMetaspaceSize=128m -J-Djava.awt.headless=true -S bundle exec puma -C config/puma.rb
release: jruby -S bundle exec rails db:migrate
