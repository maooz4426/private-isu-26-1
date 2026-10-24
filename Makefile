.PHONY: init
init: webapp/sql/dump.sql.bz2 benchmarker/userdata/img

webapp/sql/dump.sql.bz2:
	cd webapp/sql && \
	curl -L -O https://github.com/catatsuy/private-isu/releases/download/img/dump.sql.bz2

benchmarker/userdata/img.zip:
	cd benchmarker/userdata && \
	curl -L -O https://github.com/catatsuy/private-isu/releases/download/img/img.zip

benchmarker/userdata/img: benchmarker/userdata/img.zip
	cd benchmarker/userdata && \
	unzip -qq -o img.zip

.PHONY: deploy rotate-log
deploy:
	git pull
	cd webapp/ruby && bundle install
	sudo systemctl restart isu-ruby

rotate-log:
	sudo truncate -s 0 /var/log/mysql/mysql-slow.log /var/log/nginx/access.log /var/log/nginx/error.log
