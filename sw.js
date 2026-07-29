const CACHE_NAME = 'kfy-shell-v1';
const SAME_ORIGIN_ASSETS = ['./app.html', './logo.png'];

self.addEventListener('install', (event) => {
  // כל קובץ בנפרד (לא addAll) כדי שכשל בקובץ אחד לא יפיל את כל ה-install
  event.waitUntil(
    caches.open(CACHE_NAME).then((cache) =>
      Promise.all(SAME_ORIGIN_ASSETS.map((url) => cache.add(url).catch(() => {})))
    )
  );
  self.skipWaiting();
});

self.addEventListener('activate', (event) => {
  event.waitUntil(
    caches.keys().then((keys) => Promise.all(keys.filter((k) => k !== CACHE_NAME).map((k) => caches.delete(k))))
  );
  self.clients.claim();
});

// שומרים במטמון רק את קליפת האפליקציה עצמה (הקבצים שלנו + ה-CDN של הספריות),
// לא את הבקשות ל-Supabase — נתונים מנוהלים בנפרד ב-localStorage בתוך האפליקציה.
const CACHEABLE_HOSTS = ['esm.sh', 'fonts.googleapis.com', 'fonts.gstatic.com', self.location.hostname];

self.addEventListener('fetch', (event) => {
  if (event.request.method !== 'GET') return;
  const url = new URL(event.request.url);
  if (!CACHEABLE_HOSTS.includes(url.hostname)) return;

  event.respondWith(
    fetch(event.request)
      .then((res) => {
        const resClone = res.clone();
        caches.open(CACHE_NAME).then((cache) => cache.put(event.request, resClone));
        return res;
      })
      .catch(() => caches.match(event.request))
  );
});
