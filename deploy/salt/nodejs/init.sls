nodejs-dependencies:
  pkg.installed:
    - names:
      - git-core
      - curl
      - build-essential

/tmp/node-v0.10.25.tar.gz:
  file:
    - managed
    - source: salt://nodejs/node-v0.10.25.tar.gz
    - mode: "755"
    - replace: no

nodejs.download:
  cmd:
    - run
    - name: tar xzvf /tmp/node-v0.10.25.tar.gz
    - cwd: /tmp
    - unless: test -d /tmp/node-v0.10.25

nodejs.compile:
  cmd:
    - run
    - name: ./configure --prefix=/usr && make
    - cwd: /tmp/node-v0.10.25
    - unless: node --version

nodejs.install:
  cmd:
    - run
    - name: make install
    - cwd: /tmp/node-v0.10.25
    - unless: node --version

npm.install:
  cmd:
    - run
    - name: curl https://npmjs.org/install.sh | sh
    - cwd: /tmp/node-v0.10.25
    - unless: npm --version

nodejs-commons:
  cmd:
    - run
    - name: npm install -g coffee-script bower grunt-cli karma recess less
    - cwd: /tmp/node-v0.10.25
