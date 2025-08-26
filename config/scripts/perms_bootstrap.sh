uname -a
curl --head -X GET --retry 15 --retry-connrefused --retry-delay 5 http://$${KEYCLOAK_HOSTNAME:-authenticator}:4480
export keycloak_base_url="http://$${KEYCLOAK_HOSTNAME:-authenticator}:4480"
export admin_user=$${KEYCLOAK_ADMIN:-"admin"}
export admin_password=$${KEYCLOAK_ADMIN_PASSWORD:-"admin"}
export realm_name="netspi"
export app_admin_username=$${APP_ADMIN_USERNAME:-"nova"}
export app_admin_password=$${APP_ADMIN_PASSWORD:-"admin"}
export app_admin_user_email="netspilocal@local.io"
export app_admin_user_first_name="nova"
export app_admin_user_last_name="local"
export authscript_sql_file="authscript.sql"
export token_response=$$(curl -s -X POST --data-urlencode "client_id=admin-cli" --data-urlencode "username=$${admin_user}" --data-urlencode "password=$${admin_password}" --data-urlencode "grant_type=password" -H "Content-Type: application/x-www-form-urlencoded" "$${keycloak_base_url}/realms/master/protocol/openid-connect/token")
export access_token=$$(echo "$${token_response}" | jq -r '.access_token')
export create_user_response=$$(curl -s -X POST -d '{"username": "'$${app_admin_username}'", "email": "'$${app_admin_user_email}'", "firstName": "'$${app_admin_user_first_name}'", "lastName": "'$${app_admin_user_last_name}'", "enabled": true, "credentials": [{"type": "password", "value": "'$${app_admin_password}'", "temporary": false}], "attributes": {"checklist.assign": ["true"], "checklist_template.manage": ["true"], "client.admin": ["true"], "client.manage": ["true"], "export_template.manage": ["true"], "finding_template.correlate": ["true"], "finding_template.manage": ["true"], "finding_template.read": ["true"], "global_tag.manage": ["true"], "internal_data.read": ["true"], "notification.manage": ["true"], "project_type.manage": ["true"], "report_template.manage": ["true"], "unpublished_data.read": ["true"], "user.admin": ["true"]}}' -H "Content-Type: application/json" -H "Authorization: Bearer $${access_token}" "$${keycloak_base_url}/admin/realms/$${realm_name}/users")
export user_url="$${keycloak_base_url}/admin/realms/$${realm_name}/users/?username=$${app_admin_username}"
user_id=$$(curl -s -X GET -H "Authorization: Bearer $${access_token}" "$${user_url}" |jq -r '.[0].id')
export PGPASSWORD='${POSTGRES_PASSWORD:-postgres}'; psql -h 4432 -p 5432 -U ${POSTGRES_USER:-postgres} -d novaapi -c "select * from users;"
export PGPASSWORD='${POSTGRES_PASSWORD:-postgres}'; psql -h 4432 -p 5432 -U ${POSTGRES_USER:-postgres} -d novaapi -c "update users set uid='$${user_id}' where first_name = 'nova';"
export PGPASSWORD='${POSTGRES_PASSWORD:-postgres}'; psql -h 4432 -p 5432 -U ${POSTGRES_USER:-postgres} -d novaapi -c "select * from users;"
echo 'delete erroneous, blocking function permission on admin role'
export PGPASSWORD='${POSTGRES_PASSWORD:-postgres}'; psql -h 4432 -p 5432 -U postgres -d novaapi -c "DELETE FROM role_function del_rf USING role_function rf JOIN role r ON r.id = rf.role_id JOIN function f ON f.id = rf.function_id WHERE f.name = 'client' AND r.name = 'Global Admin Role' AND del_rf.id = rf.id;"
echo 'install pgcrypto'
export PGPASSWORD='${POSTGRES_PASSWORD:-postgres}'; psql -h 4432 -p 5432 -U postgres -d novaapi -c "CREATE EXTENSION IF NOT EXISTS pgcrypto;"
export PGPASSWORD='${POSTGRES_PASSWORD:-postgres}'; psql -h 4432 -p 5432 -U postgres -d novaapi -c "UPDATE feature_toggle SET feature_toggle_enabled = true WHERE name = 'asm';"
export PGPASSWORD='${POSTGRES_PASSWORD:-postgres}'; psql -h 4432 -p 5432 -U postgres -d novaapi -c "INSERT INTO authorization_scope (name, created_by) VALUES ('AuthScope_1_null_1', 1);"
export PGPASSWORD='${POSTGRES_PASSWORD:-postgres}'; psql -h 4432 -p 5432 -U postgres -d novaapi -c "INSERT INTO user_role_authorization_scope (authorization_scope_id, user_id, role_id, created_by, has_all_clients) VALUES ((SELECT id FROM authorization_scope WHERE name = 'AuthScope_1_null_1'), 1, 10, 1, true);"

