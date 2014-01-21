kush_deploy_key:
  file.managed:
    - name: /root/.ssh/kush
    - source: salt://kush/id_rsa
    - makedirs: True
    - mode: 600

kush_public_key:
  file.managed:
    - name: /root/.ssh/kush.pub
    - source: salt://kush/id_rsa.pub
    - makedirs: True
    - mode: 600

include:
  - wsgi-container

/etc/nginx/sites-enabled/kush:
  file:
    - managed
    - template: jinja
    - source: salt://kush/nginx.conf
    - require:
      - pkg: nginx


/etc/supervisor/conf.d/kush.conf:
  file:
    - managed
    - template: jinja
    - source: salt://kush/supervisor.conf
    - require:
      - pkg: supervisor


kush-reread-supervisor:
  cmd.run:
    - name: supervisorctl reread


kush-update-supervisor:
  cmd.run:
    - name: supervisorctl update


kush-reload-supervisor:
  cmd.run:
    - name: supervisorctl reload all


start-kush:
  cmd.run:
    - name: supervisorctl restart kush || echo "running"
    - require:
      - pkg: supervisor


kush-reload-nginx:
  cmd.run:
    - name: service nginx force-reload


kush-salt-repository:
  git.latest:
    - name: {{ pillar['kush']['repository'] }}
    - rev: master
    - target: {{ pillar['kush']['salt_repo_path'] }}
    - force: true
    - require:
      - pkg: app-pkgs
      - file: kush_deploy_key
      - file: kush_public_key
      - file: ssh_config


set-cronjob-highstate:
  module.run:
    - name: cron.set_job
    - user: root
    - minute: 10
    - hour: '*'
    - month: '*'
    - daymonth: '*'
    - dayweek: '*'
    - cmd: 'cd {{ pillar['kush']['salt_repo_path'] }} && (git fetch --prune; git reset --hard origin/master;git reset --hard;git clean -df) && salt-call --local state.highstate -l debug'
