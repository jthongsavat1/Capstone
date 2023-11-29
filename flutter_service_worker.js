'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {".git/COMMIT_EDITMSG": "64d42024f1a77ee5e61e4096bdebac78",
".git/config": "03a0c86f826bf36becd8d0a4b87d5255",
".git/description": "a0a7c3fff21f2aea3cfa1d0316dd816c",
".git/FETCH_HEAD": "949bf73c93857144ee702a50600ae992",
".git/HEAD": "cf7dd3ce51958c5f13fece957cc417fb",
".git/hooks/applypatch-msg.sample": "ce562e08d8098926a3862fc6e7905199",
".git/hooks/commit-msg.sample": "579a3c1e12a1e74a98169175fb913012",
".git/hooks/fsmonitor-watchman.sample": "ea587b0fae70333bce92257152996e70",
".git/hooks/post-update.sample": "2b7ea5cee3c49ff53d41e00785eb974c",
".git/hooks/pre-applypatch.sample": "054f9ffb8bfe04a599751cc757226dda",
".git/hooks/pre-commit.sample": "305eadbbcd6f6d2567e033ad12aabbc4",
".git/hooks/pre-merge-commit.sample": "39cb268e2a85d436b9eb6f47614c3cbc",
".git/hooks/pre-push.sample": "2c642152299a94e05ea26eae11993b13",
".git/hooks/pre-rebase.sample": "56e45f2bcbc8226d2b4200f7c46371bf",
".git/hooks/pre-receive.sample": "2ad18ec82c20af7b5926ed9cea6aeedd",
".git/hooks/prepare-commit-msg.sample": "2b5c047bdb474555e1787db32b2d2fc5",
".git/hooks/push-to-checkout.sample": "c7ab00c7784efeadad3ae9b228d4b4db",
".git/hooks/update.sample": "647ae13c682f7827c22f5fc08a03674e",
".git/index": "c38e985ab8d9e8de01a5619b4023a560",
".git/info/exclude": "036208b4a1ab4a235d75c181e685e5a3",
".git/logs/HEAD": "7f67f50a7b8fd369581bdb70d2af6211",
".git/logs/refs/heads/main": "6a19cde1329adb4e38a56004ac457efd",
".git/logs/refs/remotes/origin/code": "b4261ff819976996bf569a56157c6336",
".git/logs/refs/remotes/origin/main": "da5da7cc4134a53414800691cc9b5743",
".git/objects/07/be849b2bef6dd77990992c43ee6515038a71c0": "181957f5740662c3cb305473928403ab",
".git/objects/07/ccff9fe7cd89d1ce6b3435353d2147bbae1bb5": "c65bc0fd43dfabbcdf74262857f4a3e2",
".git/objects/24/2414e8f335b0b04fb174f92f5b098b0e9c0db1": "a024d3e49e6535569a5472fe0fdb3c0e",
".git/objects/28/073cb662b468daf584451f0e4f391e98c88594": "20ab11ca6ab62356f4d80f69775d5ee6",
".git/objects/2b/825d25bcb457a6197f55d6d10ddc33d5d0bd62": "c30e6e24a137929569f553a16d288b65",
".git/objects/31/fa44e6ee5de172cff7c22e555bdf398a2215d0": "f9481c8d0f15f975cf4f297808f81865",
".git/objects/35/91af41948adc8001f3586d76b91181311953fc": "c91d33b29071dcff3b2b3385383761cb",
".git/objects/45/eb02382074456c7a04b995901923359cc86bf1": "4332a9e8cda41f5b7c5a75df2db70051",
".git/objects/46/4ab5882a2234c39b1a4dbad5feba0954478155": "2e52a767dc04391de7b4d0beb32e7fc4",
".git/objects/47/88ee3c3d4bac15b535bd8cd19f68e3cefd3901": "c0491e1b31aad37d479b822efeddf98d",
".git/objects/49/4acede0c520f847f75982ca1f671fc6eaa889e": "c4a42624eaa20c8a64455bab6edd0908",
".git/objects/49/acbc36372f95f3b5e621b84e15205d5730d2ff": "c9154de472f3c8aecec4716783c983e7",
".git/objects/4a/07c306946cefa9cd9ff3fd58e9334b468c53ba": "38a68a424ba5a231ff7acd0858f4bb0d",
".git/objects/4f/514143c13326c6d5e51baa9fe9f8e2efee8aa2": "512de6db76fcb92772133a8bde5c5969",
".git/objects/53/7807567919e88db2866b7825339c57e94c24d8": "970aec5149a3dbe9370a9dc982cdd022",
".git/objects/59/119b5e89e6224222018370668091ba4d89133a": "90744defe991157dfe290c8bc7c52a5f",
".git/objects/60/0c8fec2f867a553fa8e3ba60f1ee0a185ebed5": "1f3f36fee5c1a1b3ce5faeee078a1061",
".git/objects/65/ce56b3655be29f488e6935961fbcc858f5f545": "dbf9cbf428ec59767f6427ab9c5042b9",
".git/objects/6c/a3f6bdd5563141b3373fc6bd3917129f534238": "aa2f2720d6923eacc0f857c4456c14f6",
".git/objects/6f/4684e083a018fb2b9b3e3579fa83d88e00357d": "c36a0d2885d9ce067027d762572f1a49",
".git/objects/75/ee84bb46eb4f38785829747009009b32ff5362": "a56390ceacb9c49e78b04f9a279cc968",
".git/objects/83/2a5626119278dfa1b43123ef0d6478af4448aa": "906c6044052108fd1fe59d7d61c86e6f",
".git/objects/88/cfd48dff1169879ba46840804b412fe02fefd6": "e42aaae6a4cbfbc9f6326f1fa9e3380c",
".git/objects/89/74808be5a04510b142d9ddec9bd427fda835c9": "b3cb9d0e4f11e09d91a7866be95d809f",
".git/objects/8a/9c19a8e879874a760573e7b85b791d5c975924": "c36efe9ffab659dbde2a13c00f8b3964",
".git/objects/8a/aa46ac1ae21512746f852a42ba87e4165dfdd1": "1d8820d345e38b30de033aa4b5a23e7b",
".git/objects/99/4e2e2af0142cea7e73ff4e65ca7a0d8549a390": "c5b64e244db3dc1f4f065fdf2082107e",
".git/objects/9d/5f886353dcff6c222439cc1118e77eb1b007ea": "a87ff240c6e149d1ce495643e49417f9",
".git/objects/ae/7891056505a77739ea0103fd7baf99bc597983": "dc0595c34072688f39a8559916fe1907",
".git/objects/b7/49bfef07473333cf1dd31e9eed89862a5d52aa": "36b4020dca303986cad10924774fb5dc",
".git/objects/b7/e363627db781d560c1b69cfcf1d945a4dba0c6": "fcc9f908496745e2e4dcf025796e2ba2",
".git/objects/b8/cab122138dfeeadb026c7230e687c91d224ada": "b4948a4757ba68841684c987a2892545",
".git/objects/b9/2a0d854da9a8f73216c4a0ef07a0f0a44e4373": "f62d1eb7f51165e2a6d2ef1921f976f3",
".git/objects/bb/ac29f5ef7a40bf14c0901bc1457724156bc0de": "1393f20f0610cabefe2d4f45865b0f54",
".git/objects/c2/d8d2f44dd987786bbc249d4ad7bac3360f4811": "1926a57b256d9def261ccf6dc2914f65",
".git/objects/c9/0ae8b4c48a62bb0bd7b7fe5795f7f90a9fface": "5e56f3d11e70ea79277d2a27d3c32b09",
".git/objects/cc/56672458502e0f26141ab34fae8e65857145b0": "a052cb56752ecbcbf10db556a5e9638c",
".git/objects/cc/cfdc28d101cd2c67d4f0059677a3e8eedfe51a": "6be2e34f766d11c917c1f267d003bf0c",
".git/objects/d2/95fd52d0343565abdbc84abec859772aeafc56": "a046665bf06f113d7ccc40ac085ccfa5",
".git/objects/d3/efa7fd80d9d345a1ad0aaa2e690c38f65f4d4e": "610858a6464fa97567f7cce3b11d9508",
".git/objects/d5/b54bd4a898b373f82bb1fa52b9580e7a976e3e": "943e27e1d359e2bc22daf20c70287c19",
".git/objects/d6/9c56691fbdb0b7efa65097c7cc1edac12a6d3e": "868ce37a3a78b0606713733248a2f579",
".git/objects/d7/2c11112c7cb4e2ce754bc41470f9b829a2d00a": "d7280a766a5d6033f187d874a92b5ad6",
".git/objects/da/896c0b537e50b7d3c46128e9fc9fecd9d0e0c9": "b7cbcaa20eb7a046c4fbdbbc7f4720fd",
".git/objects/df/7d2dcb89ab89da87467c0e1059b38c8d8f9296": "a44162ff357b024e4638ab18a9bb01c7",
".git/objects/e0/49c81f7cb35ebc411a3e1b547bf4ccf91292e8": "efad70dc0ca77a90ee53b5cc3be528ca",
".git/objects/e0/9cd93fe32e230a3d5adae526ec40e2c2c2e46e": "4ab5b07d4fde604c9cae07c49b0c185f",
".git/objects/e2/ff5865b192241d53935e77de70a4e6dff2847a": "cad1058aedc6c21a518b3cb00af21fac",
".git/objects/e6/46d591f99adb142edab348e5d728ad2bddc4a3": "7630b34441d494db3bf4d884cd250e72",
".git/objects/e6/b745f90f2a4d1ee873fc396496c110db8ff0f3": "2933b2b2ca80c66b96cf80cd73d4cd16",
".git/objects/eb/9b4d76e525556d5d89141648c724331630325d": "37c0954235cbe27c4d93e74fe9a578ef",
".git/objects/f1/05cb3d61c11b0a09bc2d3443d969cae67a00f6": "3a65158a9ca484dea502a9da775a590d",
".git/objects/fa/543f32fac6d74b0b9cf9e3f2273390f93a84f8": "531293e39209d9b9ddd921576f9461f7",
".git/objects/fc/de1bb3df8c330568f07ef326d43d8ae3562897": "6e5bf2450330342c243afc3723b9c27e",
".git/objects/fd/b4f4a2d68a6faced07a4f225fb98e73c41fbdb": "6545ceb7fb0bb07b5b262282d730f652",
".git/objects/pack/pack-e8b4f3fbb190eab6932b41be4c304bec97283204.idx": "545dc72b25f92e6f234e7c376e9b96d4",
".git/objects/pack/pack-e8b4f3fbb190eab6932b41be4c304bec97283204.pack": "530fb15db8930c334b9d3a367e949313",
".git/ORIG_HEAD": "ce44e717266a2f65dd65ca364e17b332",
".git/refs/heads/main": "c78e0f51bb78e8943d1a5069b6e303b3",
".git/refs/remotes/origin/code": "5dc4445a66c39c9abd3a94844f11e47d",
".git/refs/remotes/origin/main": "c78e0f51bb78e8943d1a5069b6e303b3",
"assets/AssetManifest.bin": "dfa8570a8f4cf895be3be432802e7db6",
"assets/AssetManifest.json": "0dcc4f08c30c28703a3b9521c2d82bcd",
"assets/assets/images/apple.png": "4f658b9a7d067de5238644b78d8d09cc",
"assets/assets/images/background.jpg": "6289aa953606f0b228170facc113f1ac",
"assets/assets/images/google.png": "ca2f7db280e9c773e341589a81c15082",
"assets/assets/images/logo.jpg": "1d287c56a6ba1d9e55ae8fa82eba39ef",
"assets/assets/images/logo2.jpg": "abee3e0f05b27c1dab928f8f813cc6c0",
"assets/assets/images/marker.jpg": "b312e122541976934a6b691ea6825030",
"assets/assets/images/register.png": "6554da68ac24a3ad7efba085cd675a0e",
"assets/assets/images/shiba.jpg": "5b5ccf9ea712a12c99de3439385f126a",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/fonts/MaterialIcons-Regular.otf": "cfda36a73e9c890c507a259d63bb35e8",
"assets/NOTICES": "9b5387a5a840dbd4e3c277685ff00410",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "89ed8f4e49bcdfc0b5bfc9b24591e347",
"assets/shaders/ink_sparkle.frag": "f8b80e740d33eb157090be4e995febdf",
"canvaskit/canvaskit.js": "5caccb235fad20e9b72ea6da5a0094e6",
"canvaskit/canvaskit.wasm": "d9f69e0f428f695dc3d66b3a83a4aa8e",
"canvaskit/chromium/canvaskit.js": "ffb2bb6484d5689d91f393b60664d530",
"canvaskit/chromium/canvaskit.wasm": "393ec8fb05d94036734f8104fa550a67",
"canvaskit/skwasm.js": "95f16c6690f955a45b2317496983dbe9",
"canvaskit/skwasm.wasm": "d1fde2560be92c0b07ad9cf9acb10d05",
"canvaskit/skwasm.worker.js": "51253d3321b11ddb8d73fa8aa87d3b15",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"flutter.js": "6b515e434cea20006b3ef1726d2c8894",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"index.html": "e298dfd1525047bd388d2143eb7ded5a",
"/": "e298dfd1525047bd388d2143eb7ded5a",
"main.dart.js": "245548ff8ad327b505458d59bbd886be",
"manifest.json": "dd11246c8e0c898d38fef2f10d23a9fd",
"version.json": "b31a11d725b11fdf6d09cc1d9dcace7f"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"assets/AssetManifest.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}