# kush.weedlabs.io


## 1. install dependencies

```bash
npm install -g coffee-script bower recess
curd install -r requirements.txt
```

## 2. run the website

```bash
python manage.py assets build
python manage.py run
```

## 3. deploy in vagrant

```bash
vagrant up
vagrant ssh
sudo salt-call --local state.highstate -l debug
```
