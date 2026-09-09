// DEMACO portal — proxy a la Edge Function contract-portal.
// Necesario porque *.supabase.co fuerza text/plain para HTML
// (anti-phishing); aquí restituimos el content-type correcto.
const ORIGIN = 'https://kybskbioejysfhdmeend.supabase.co';
const FN_PATH = '/functions/v1/contract-portal';

export default {
  async fetch(req) {
    const url = new URL(req.url);
    const upstream = new URL(ORIGIN);
    upstream.pathname =
      url.pathname === '/' || url.pathname === '/contrato'
        ? FN_PATH
        : url.pathname;
    upstream.search = url.search;
    // Solo los headers necesarios: reenviar Host confunde el
    // enrutamiento de Cloudflare (error 1042).
    const fwd = new Headers();
    for (const k of ['content-type', 'accept', 'authorization']) {
      const v = req.headers.get(k);
      if (v) fwd.set(k, v);
    }
    const resp = await fetch(upstream, {
      method: req.method,
      headers: fwd,
      // Buffer completo: reenviar el stream directo falla en Workers.
      body: ['GET', 'HEAD'].includes(req.method)
        ? undefined
        : await req.arrayBuffer(),
    });
    const h = new Headers(resp.headers);
    const esPagina = upstream.pathname === FN_PATH &&
      req.method === 'GET' && !url.searchParams.has('token');
    if (esPagina) {
      h.set('content-type', 'text/html; charset=utf-8');
      h.delete('x-content-type-options');
      // Supabase añade una CSP 'default-src none; sandbox' que mata
      // los estilos y el script de la página: fuera.
      h.delete('content-security-policy');
      h.set('content-security-policy',
        "default-src 'self'; style-src 'unsafe-inline'; " +
        "script-src 'unsafe-inline'; img-src 'self' data: blob:; " +
        "connect-src 'self'");
    }
    return new Response(resp.body, { status: resp.status, headers: h });
  },
};
