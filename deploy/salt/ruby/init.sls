ruby-dependencies:
  pkg.installed:
    - names:
      - build-essential
      - git-core
      - curl
      - bison
      - openssl
      - libreadline6
      - libreadline6-dev
      - zlib1g
      - zlib1g-dev
      - libssl-dev
      - libyaml-dev
      - libxml2-dev
      - libxslt1-dev
      - autoconf
      - libc6-dev
      - libncurses5-dev
      - libcurl4-openssl-dev
      - libopenssl-ruby
      - apache2-prefork-dev
      - libapr1-dev
      - libaprutil1-dev
      - libx11-dev
      - libffi-dev
      - tcl-dev
      - tk-dev


/tmp/ruby-2.1.0.tar.gz:
  file:
    - managed
    - source: salt://ruby/ruby-2.1.0.tar.gz
    - mode: "755"
    - replace: no

ruby.download:
  cmd:
    - run
    - name: tar xzvf /tmp/ruby-2.1.0.tar.gz
    - cwd: /tmp
    - unless: test -d /tmp/ruby-2.1.0

ruby.compile:
  cmd:
    - run
    - name: ./configure --prefix=/usr && make
    - cwd: /tmp/ruby-2.1.0
    - unless: ruby --version | egrep '2[.]1[.]0'

ruby.install:
  cmd:
    - run
    - name: make install
    - cwd: /tmp/ruby-2.1.0
    - unless: ruby --version | egrep '2[.]1[.]0'

update-gems:
  cmd:
    - run
    - name: gem update --system
    - cwd: /tmp/ruby-2.1.0
