#!/bin/bash

function gen_request {

	local method="GET"
	local n=$((1 + RANDOM % 5))
	case $n in
		1) method="GET";;
		2) method="POST";;
		3) method="PUT";;
		4) method="PATCH";;
		5) method="DELETE";;
	esac

	local target=""
	local n=$((1 + RANDOM % 14))
	case $n in
		 1) target="/status";;
		 2) target="/id";;
		 3) target="/profile";;
		 4) target="/deal_in";;
		 5) target="/deal_out";;
		 6) target="/position";;
		 7) target="/buying_price";;
		 8) target="/selling_price";;
		 9) target="/open_time";;
		10) target="/close_time";;
		11) target="/volume";;
		12) target="/profit";;
		13) target="/balance";;
		14) target="/server_id";;
  esac

  local http_version=""
  n=$((1 + RANDOM % 3))
  case $n in
    1) http_version="HTTP/1.0";;
    2) http_version="HTTP/1.1";;
    3) http_version="HTTP/2";;
  esac
  echo "\"$method $target $http_version\""
}
