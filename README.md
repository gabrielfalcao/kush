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


### if you haven't deployed yet...

you gotta make sure to create your keys and export to github

```bash
ssh-keygen -f deploy/salt/kush/id_rsa -N ""
cat deploy/salt/kush/id_rsa | pbcopy

# now go and add this as deploy key for your repo, otherwise salt won't be able to git clone.
```

### after you already have the deploy keys at github

```bash
vagrant up
vagrant ssh
sudo salt-call --local state.highstate -l debug
```
