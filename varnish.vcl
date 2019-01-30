vcl 4.0;

backend default {
  .host = "localhost";
  .port = "4000";
}

sub vcl_backend_response {
  set beresp.ttl = 120s;
}

sub vcl_recv {
  unset req.http.X-Body-Len;

  ## Remove has_js and Cloudflare/Google Analytics __* cookies, and
  ## normalize cookies.
  set req.http.Cookie = regsuball(req.http.Cookie,
    "(^|;\s*)(_[_a-z]+|has_js)=[^;]*", "");
  set req.http.Cookie = regsub(req.http.Cookie, "^;\s*", "");
  if (req.http.Cookie ~ "^ *$") {
    unset req.http.Cookie;
  }

  if (req.method != "GET" && req.method != "HEAD") {
    return (pass);
  }

  if (req.http.Authorization) {
    return (pass);
  }

  if (req.http.X-Force-Backend) {
    return (pass);
  }
}

sub vcl_deliver {
  unset resp.http.Via;
  return (deliver);
}
