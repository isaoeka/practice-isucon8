SERVICE_NAME := torb

log-access:
	tail -f /var/log/nginx/access.log

restart-nginx:
	sudo rm -f /var/log/nginx/access.log
	sudo systemctl restart nginx

restart-db:
	sudo rm -f /var/log/mysql/mysql-slow.log
	sudo systemctl restart mariadb

restart-app:
	sudo systemctl daemon-reload
	sudo systemctl restart $(SERVICE_NAME).go


TIMESTAMP = $(shell date +%s)

analyze-alp::
	sudo alp -f /var/log/nginx/access.log --sum --reverse --aggregates "/api/users/[0-9]+","/api/events/[0-9]+","/api/events/[0-9]+/sheets/C/[0-9]+/reservation","/admin/api/reports/events/[0-9]+/sales","/admin/api/events/[0-9]+","/api/events/[0-9]+/actions/reserve","/css/.+","/js/.+" > log/alp/$(TIMESTAMP).txt

analyze-query:
	sudo pt-query-digest --explain h=localhost,u=isucon,p=isucon /var/log/mysql/mysql-slow.log > log/query/$(TIMESTAMP).txt

