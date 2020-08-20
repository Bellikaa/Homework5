#!/usr/bin/env bash
sudo su
cd 
cp /vagrant/otus.repo /root/
cp /vagrant/nginx.spec /root/
cp /vagrant/default.conf /root/
yum install -y epel-release
yum install -y gcc
yum group install "Development Tools" -y
yum install -y redhat-lsb-core wget rpmdevtools rpm-build createrepo yum-utils
echo "Загрузим SRPM пакет NGINX для дальнейшей работы над ним"
wget https://nginx.org/packages/centos/7/SRPMS/nginx-1.14.1-1.el7_4.ngx.src.rpm /root/
echo "Под кем и какая директория"
pwd
whoami
echo "При установке такого пакета в домашней директории создается древо каталогов для сборки"
sudo rpm -i nginx-1.14.1-1.el7_4.ngx.src.rpm 
#rpm -i nginx-1.14.1-1.el7_4.ngx.src.rpm /root/
echo "Нужно скачать и разархивировать последний исходники для openssl"
wget https://www.openssl.org/source/latest.tar.gz /root/
tar -xvf /root/latest.tar.gz
echo "Заранее поставим все зависимости чтобы в процессе сборки не было ошибок"
yum-builddep -y /root/rpmbuild/SPECS/nginx.spec 
echo "Удалим изначальный спек файл"
rm /root/rpmbuild/SPECS/nginx.spec
echo "Скопируем измененный файл"
cp nginx.spec /root/rpmbuild/SPECS/
echo "Приступим к сборке пакета"
rpmbuild -bb /root/rpmbuild/SPECS/nginx.spec
ll /root/rpmbuild/RPMS/x86_64/
yum localinstall -y /root/rpmbuild/RPMS/x86_64/nginx-1.14.1-1.el7_4.ngx.x86_64.rpm
systemctl start nginx
systemctl status nginx
mkdir /usr/share/nginx/html/repo
cp /root/rpmbuild/RPMS/x86_64/nginx-1.14.1-1.el7_4.ngx.x86_64.rpm /usr/share/nginx/html/repo/
wget http://www.percona.com/downloads/percona-release/redhat/0.1-6/percona-release-0.1-6.noarch.rpm -O /usr/share/nginx/html/repo/percona-release-0.1-6.noarch.rpm
createrepo /usr/share/nginx/html/repo/
ls /usr/share/nginx/html/repo/
#Доступ к листингу каталогу
cp default.conf /etc/nginx/conf.d/
#Проверяем синтаксис и перезапускаем NGINX
nginx -t
nginx -s reload
#Проверяем репозиторий на наличие пакета
curl -a http://localhost/repo/
#Копируем файл локального репозитория
cp /vagrant/otus.repo /etc/yum.repos.d/
yum repolist enabled | grep otus
yum list | grep otus
yum install percona-release -y
