#!/bin/bash

gen_status () {
  local res=200
  local n=$((1 + RANDOM % 10))
  case $n in
     1) local res=200;;
     2) local res=201;;
     3) local res=400;;
     4) local res=401;;
     5) local res=403;;
     6) local res=404;;
     7) local res=500;;
     8) local res=501;;
     9) local res=502;;
    10) local res=503;;
  esac
  echo $res
}

### 200 OK 
# The request succeeded. The result meaning of "success" depends on the HTTP request:
#   GET: The resource has been fetched and transmitted in the message body.
#   HEAD: The representation headers are included in the status without any message body.
#   PUT or POST: The resource describing the result of the action is transmitted in the message body.
#   TRACE: The message body contains the request message as received by the server.

### 201 Created
# The request succeeded, and a new resource was created as a result. 
# This is typically the status sent after POST requests, or some PUT requests.

### 400 Bad Request
# The server cannot or will not process the request due to something that is perceived to be a client error (e.g., malformed request syntax, invalid request message framing, or deceptive request routing).

### 401 Unauthorized
# Although the HTTP standard specifies "unauthorized", semantically this status means "unauthenticated". 
# That is, the client must authenticate itself to get the requested status.

### 403 Forbidden
# The client does not have access rights to the content; that is, it is unauthorized, so the server is refusing to give the requested resource. 
# Unlike 401 Unauthorized, the client's identity is known to the server.

### 404 Not Found
# The server cannot find the requested resource. 
# In the browser, this means the URL is not recognized. 
# In an API, this can also mean that the endpoint is valid but the resource itself does not exist. 
# Servers may also send this status instead of 403 Forbidden to hide the existence of a resource from an unauthorized client. 
# This status code is probably the most well known due to its frequent occurrence on the web.

### 500 Internal Server Error
# The server has encountered a situation it does not know how to handle.

### 501 Not Implemented
# The request request is not supported by the server and cannot be handled. 
# The only requests that servers are required to support (and therefore that must not return this code) are GET and HEAD.

### 502 Bad Gateway
# This error status means that the server, while working as a gateway to get a status needed to handle the request, got an invalid status.

### 503 Service Unavailable
# The server is not ready to handle the request. 
# Common causes are a server that is down for maintenance or that is overloaded. 
# Note that together with this status, a user-friendly page explaining the problem should be sent. 
# This status should be used for temporary conditions and the Retry-After HTTP header should, if possible, contain the estimated time before the recovery of the service. 
# The webmaster must also take care about the caching-related headers that are sent along with this status, as these temporary condition statuss should usually not be cached.
