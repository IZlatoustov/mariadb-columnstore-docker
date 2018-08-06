FROM alpine:3.4

RUN apk add --update mysql-client && rm -rf /var/cache/apk/*
# RUN mysql --host=10.5.0.2 --user=zeppelin_user --password=zepplin_pass --database=bookstore --execute='select count(*) from bookstore.books' 
COPY tests /tmp/sql

ENTRYPOINT ["/tmp/sql"]
#docker run --rm columnstore_test mysql --host=10.5.0.2 --user=zeppelin_user --password=zepplin_pass --database=bookstore --execute='select count(*) from bookstore.books' 