
FROM mariadb:10.3 
#as builder
ARG root_pass=secret_pass
ENV MYSQL_ROOT_PASSWORD=$root_pass

ARG user=sandbox
ENV MYSQL_USER=$user

ARG pass=highlyillogical
ENV MYSQL_PASSWORD=$pass

ARG db=bookstore
ENV MYSQL_DATABASE=$db

RUN mkdir -p /tmp/bookstore && \
	mkdir -p /tmp/bookstore/csv && \
	apt-get update && \
	apt-get -y install curl && \
	curl https://downloads.mariadb.com/sample-data/smallsb.tar --output /tmp/bookstore/csv/bookstore.tar && \
	tar -vxf /tmp/bookstore/csv/bookstore.tar --directory /tmp/bookstore/csv/ && \
	cd /tmp/bookstore/csv/ && \
	gunzip -v *.gz && \
	sed -i 's/%CSV%/\/tmp\/bookstore\/csv\//g' /tmp/bookstore/csv/load_tx_template.sql && \
	sed -i 's/%DB%/bookstore/g' /tmp/bookstore/csv/load_tx_template.sql && \
	cp /tmp/bookstore/csv/load_tx_template.sql /docker-entrypoint-initdb.d/load_tx_data.sql

RUN /bin/bash -c "/usr/bin/mysqld_safe --skip-grant-tables &" && \
	sleep 15 && \
	mysql -uroot -p$MYSQL_ROOT_PASSWORD < /tmp/bookstore/csv/load_tx_template.sql &&\
	ls -la /var/lib/mysql/ && \
	mysqladmin shutdown
# FROM mariadb:10.3

# ARG root_pass=secret_pass
# ENV MYSQL_ROOT_PASSWORD=$root_pass

# ARG user=sandbox
# ENV MYSQL_USER=$user

# ARG pass=highlyillogical
# ENV MYSQL_PASSWORD=$pass

# ARG db=bookstore
# ENV MYSQL_DATABASE=$db

# COPY --from=builder /var/lib/mysql /var/lib/mysql