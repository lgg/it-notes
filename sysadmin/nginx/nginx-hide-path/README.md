# Hide path with nginx

## Using magic cookies

**Important! `If` is evil, so use this option with wisely due to performance**

* add code from [`nginx/add-this-to-your-site-config`](./nginx/add-this-to-your-site-config)
to your site's config
* edit it to fit your options
* upload `magic-gate.html` to your website to dir `/magic/` and rename to `index.html`
* also download [cookie.js](https://github.com/florian/cookie.js) and put it near `magic-gate.html`
* reload nginx (`service nginx reload`)

### With nginx for setting cookie

* see `nginx/nginx-set-cookie`

### Cookie's lifetime

* By default cookie's lifetime is set to 60 days, you may edit `magicWillExpireIn` in `magic-gate.html`
and change it to another value of days or set to `false` to expire when the browser is closed
* for more options of cookie settings see [cookie.js docs](https://github.com/florian/cookie.js)

### Whaaat? This is useless, this doesn't increase security

Yeap, but this "proof of concept", you can disable nginx redirect to `/secret-path`,
set cookie only after more complicated actions, etc

## Using fail2ban and HTTP-auth

* [See this for more info](http://serverfault.com/questions/421046/how-to-limit-nginx-auth-basic-re-tries)
