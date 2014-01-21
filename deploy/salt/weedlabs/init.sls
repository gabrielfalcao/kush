weedlabs_deploy_key:
  file.managed:
    - name: /root/.ssh/github
    - source: salt://weedlabs/id_rsa
    - makedirs: True
    - mode: 600

weedlabs_public_key:
  file.managed:
    - name: /root/.ssh/github.pub
    - source: salt://weedlabs/id_rsa.pub
    - makedirs: True
    - mode: 600


/etc/nginx/sites-enabled/weedlabs:
  file:
    - managed
    - template: jinja
    - source: salt://weedlabs/nginx.conf
    - require:
      - pkg: nginx

/etc/nginx/sites-enabled/fallback:
  file:
    - managed
    - template: jinja
    - source: salt://weedlabs/www-fallback.conf
    - require:
      - pkg: nginx


{{ pillar['weedlabs']['www_fallback'] }}/www-fallback.tar.gz:
  file:
    - managed
    - template: jinja
    - source: salt://weedlabs/www-fallback.tar.gz


extract-www-fallback:
  module.run:
    - name: archive.tar
    - options: zxf
    - tarfile: {{ pillar['weedlabs']['www_fallback'] }}/www-fallback.tar.gz
    - dest: {{ pillar['weedlabs']['www_fallback'] }}/
    - archive_format: tar
    - require:
      - file: {{ pillar['weedlabs']['www_fallback'] }}/www-fallback.tar.gz

weedlabs.io:
  git.latest:
    - name: {{ pillar['weedlabs']['repository'] }}
    - rev: {{ pillar['weedlabs']['revision'] }}
    - target: {{ pillar['weedlabs']['www_root'] }}
    - force: true
    - require:
      - pkg: app-pkgs
      - file: weedlabs_deploy_key
      - file: weedlabs_public_key

weedlabs-reload-nginx:
  cmd.run:
    - name: service nginx force-reload
