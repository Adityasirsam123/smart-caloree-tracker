USERNAME="Adityasirsam"
PASSWORD="glpat--7-1Vzf5LukPvpUNxqAx3286MQp1OmduaGV2Cw.01.121mu2gsc"
EMAIL="aditya@oyebusy.in"

AUTH=$(echo -n "$USERNAME:$PASSWORD" | base64)
DOCKER_JSON=$(jq -nc --arg u "$USERNAME" --arg p "$PASSWORD" --arg e "$EMAIL" --arg a "$AUTH" \
  '{auths: {"https://registry.gitlab.com": {username: $u, password: $p, email: $e, auth: $a}}}')

echo "$DOCKER_JSON" | base64 -w 0

