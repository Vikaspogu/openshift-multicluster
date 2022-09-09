cd /root/openshift
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_rsa
sshKeyVar=$(cat ~/.ssh/id_rsa.pub)
sed -i "s|sshKey: |sshKey: ${sshKeyVar}|ig" install-config.yaml
cat install-config.yaml
cp install-config.yaml install-config.yaml.bak
openshift-install create manifests
sed -i 's/mastersSchedulable: true/mastersSchedulable: false/g' manifests/cluster-scheduler-02-config.yml
cat manifests/cluster-scheduler-02-config.yml
openshift-install create ignition-configs
cp *.ign /var/www/html/ignition/
cd /var/www/html/ignition/
chmod 777 *
